//
//  HuEasyShoppingCart.m
//  huyihui
//
//  Created by zaczh on 14-3-27.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "HuEasyShoppingCart.h"

@interface HuEasyShoppingCart()
{
    NSMutableArray *localCartItems;
    NSMutableArray *serverCartItems;
}
@end

@implementation HuEasyShoppingCart

static  HuEasyShoppingCart *_sharedInstance = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if(self){
        localCartItems = [NSMutableArray new];
        serverCartItems = [NSMutableArray new];
        if(APP_DELEGATE.isLoggedIn){
            [self getshoppingCartFromServer];
        }
    }
    return self;
}

- (void)dealloc{
    [_sharedInstance release], _sharedInstance = nil;
    [localCartItems release], localCartItems = nil;
    [serverCartItems release], serverCartItems = nil;
    [super dealloc];
}

- (NSArray *)items{
    if(APP_DELEGATE.isLoggedIn){
        return [serverCartItems.copy autorelease];
    }
    return [localCartItems.copy autorelease];
}

- (NSArray *)mutableItems
{
    NSMutableArray *arr = [[NSMutableArray new] autorelease];
    if(APP_DELEGATE.isLoggedIn){
        @synchronized(self){
            [serverCartItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [arr addObject:[[obj mutableCopy] autorelease]];
            }];
        }
    }else{
        @synchronized(self){
            [localCartItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [arr addObject:[[obj mutableCopy] autorelease]];
            }];
        }
    }
    return [[arr copy] autorelease];
}

- (void)removeItemBySpeciesId:(NSString *)speciesId
                       andSku:(NSString *)sku
                      success:(void (^)())successBlock
                      failure:(void (^)())failureBlock
{
//    if(APP_DELEGATE.isLoggedIn){
//        [self requestDeleteItemInCartWithSpeciesId:speciesId andSku:sku success:^{
//            [self pullCompletion:successBlock];
//        } failure:^{
//            if(failureBlock != nil){
//                failureBlock();
//            }
//        }];
//    }else{
//        @synchronized(self){
//            for(int i =0;i<localCartItems.count;i++){
//                if([localCartItems[i][@"speciesId"] isEqualToString:speciesId] &&
//                   [localCartItems[i][@"sku"] isEqualToString:sku]){
//                    [localCartItems removeObjectAtIndex:i];
//                    i--;
//                    
//                }
//            }
//        }
//        if(successBlock != nil){
//            successBlock();
//        }
//    }
    [self removeItemBySpeciesId:speciesId andSku:sku completion:^(NSError *err) {
        if(err == nil){
            if(successBlock != nil){
                successBlock();
            }
        }else{
            if(failureBlock != nil){
                failureBlock();
            }
        }
    }];
}

- (void)removeItemBySpeciesId:(NSString *)speciesId
                       andSku:(NSString *)sku
                      completion:(void (^)(NSError *err))completionBlock
{
    if(APP_DELEGATE.isLoggedIn){
        __block NSError *localError = nil;
        dispatch_group_t localGroup = dispatch_group_create();
        
        dispatch_group_enter(localGroup);
        [self requestDeleteItemInCartWithSpeciesId:speciesId andSku:sku completion:^(NSError *err) {
            if(err == nil){
                dispatch_group_enter(localGroup);
                [self pullWithCompletionBlock:^(NSError *error) {
                    if(error){
                        localError = [[error copy] autorelease];
                    }
                    dispatch_group_leave(localGroup);
                }];
            }
            dispatch_group_leave(localGroup);
        }];
        dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
            if(completionBlock != nil){
                completionBlock(localError);
            }
        });
        
        dispatch_release(localGroup);
    }else{
        @synchronized(self){
            for(int i =0;i<localCartItems.count;i++){
                if([localCartItems[i][@"speciesId"] isEqualToString:speciesId] &&
                   [localCartItems[i][@"sku"] isEqualToString:sku]){
                    [localCartItems removeObjectAtIndex:i];
                    i--;
                }
            }
            [serverCartItems removeAllObjects];
            [serverCartItems addObjectsFromArray:localCartItems];
        }
        if(completionBlock != nil){
            completionBlock(nil);
        }
    }
}

- (void)addItems:(NSArray *)items
      completion:(void (^)(NSError *error))completionBlock
{
    __block NSError *localError = nil;
    dispatch_group_t localGroup = dispatch_group_create();
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(localGroup);
        [self addItem:obj completion:^(NSError *err) {
            if(err){
                localError = [[err copy] autorelease];
                *stop = YES;
            }
            dispatch_group_leave(localGroup);
        }];
    }];
    
    if(APP_DELEGATE.isLoggedIn){
        dispatch_group_enter(localGroup);
        [self pullWithCompletionBlock:^(NSError *error) {
            if(error){
                localError = [[error copy] autorelease];
            }
            dispatch_group_leave(localGroup);
        }];
    }
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(localGroup);
}

- (void)removeItems:(NSArray *)items
         completion:(void (^)(NSError *err))completionBlock
{
    __block NSError *localError = nil;
    dispatch_group_t deleteGroup = dispatch_group_create();
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(deleteGroup);
        [self removeItemBySpeciesId:obj[@"speciesId"] andSku:obj[@"sku"] completion:^(NSError *err) {
            if(err){
                localError = [[err copy] autorelease];
                *stop = YES;
            }
            dispatch_group_leave(deleteGroup);
        }];
    }];
    
    if(APP_DELEGATE.isLoggedIn){
        dispatch_group_enter(deleteGroup);
        [self pullWithCompletionBlock:^(NSError *error) {
            if(error){
                localError = [[error copy] autorelease];
            }
            dispatch_group_leave(deleteGroup);
        }];
    }
    dispatch_group_notify(deleteGroup, dispatch_get_main_queue(), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(deleteGroup);
}

- (void)addItem:(NSDictionary *)item
        success:(void(^)(void))successBlock
        failure:(void(^)(void))failureBlock
{
//    if(APP_DELEGATE.isLoggedIn){
//            //判断购物车是否已经有同种商品
//            BOOL find = NO;
//            for(int i = 0;i<serverCartItems.count;i++){
//                if([serverCartItems[i][@"speciesId"] isEqualToString:item[@"speciesId"]] &&
//                   [serverCartItems[i][@"sku"] isEqualToString:item[@"sku"]]){
//                    NSInteger quantity = [serverCartItems[i][@"prodNumber"] integerValue] + [item[@"prodNumber"] integerValue];
//                    
//                    [self requestUpdateProductQuantityWithSpeciesId:item[@"speciesId"] andSku:item[@"sku"] previousQuantity:[serverCartItems[i][@"prodNumber"] integerValue] nowQuantity:quantity success:^{
//                        [self pullCompletion:successBlock];
//                    } failure:failureBlock];
//                    
//                    find = YES;
//                    break;
//                }
//            }
//            //没有已加入的同种商品
//            if(!find){
//                [self requestAddItemToCart:item success:^(){
//                    [self pullCompletion:successBlock];
//                } failure:failureBlock];
//            }
//    }else{
//        //判断购物车是否已经有同种商品
//        BOOL find = NO;
//        for(int i = 0;i<localCartItems.count;i++){
//            if([localCartItems[i][@"speciesId"] isEqualToString:item[@"speciesId"]] &&
//               [localCartItems[i][@"sku"] isEqualToString:item[@"sku"]]){
//                NSInteger quantity = [localCartItems[i][@"prodNumber"] integerValue] + [item[@"prodNumber"] integerValue];
//                
//                NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary:localCartItems[i]];
//                [modifiedItem setObject:[NSNumber numberWithUnsignedInteger:quantity] forKey:@"prodNumber"];
//                [localCartItems replaceObjectAtIndex:i withObject:[[modifiedItem copy] autorelease]];
//                find = YES;
//                break;
//            }
//        }
//        //没有已加入的同种商品
//        if(!find){
//            [localCartItems addObject:item];
//        }
//        if(successBlock != nil){
//            successBlock();
//        }
//    }
    [self addItem:item completion:^(NSError *err) {
        if(err == nil){
            if(successBlock != nil){
                successBlock();
            }
        }else{
            if(failureBlock != nil){
                failureBlock();
            }
        }
    }];
}

- (void)addItem:(NSDictionary *)item
     completion:(void (^)(NSError *err))completionBlock
{
    if(APP_DELEGATE.isLoggedIn){
        __block NSError *localError = nil;
        dispatch_group_t localGroup = dispatch_group_create();
        //判断购物车是否已经有同种商品
        BOOL find = NO;
        for(int i = 0;i<serverCartItems.count;i++){
            if([serverCartItems[i][@"speciesId"] isEqualToString:item[@"speciesId"]] &&
               [serverCartItems[i][@"sku"] isEqualToString:item[@"sku"]]){
                NSInteger quantity = [serverCartItems[i][@"prodNumber"] integerValue] + [item[@"prodNumber"] integerValue];
                dispatch_group_enter(localGroup);
                [self requestUpdateProductQuantityWithSpeciesId:item[@"speciesId"] andSku:item[@"sku"] previousQuantity:[serverCartItems[i][@"prodNumber"] integerValue] nowQuantity:quantity completion:^(NSError *error) {
                    dispatch_group_leave(localGroup);
                }];
                
                find = YES;
                break;
            }
        }
        //没有已加入的同种商品
        if(!find){
            dispatch_group_enter(localGroup);
            [self requestAddItemToCart:item completion:^(NSError *error) {
                if(error == nil){
                    dispatch_group_enter(localGroup);
                    [self pullWithCompletionBlock:^(NSError *error) {
                        if(error != nil){
                            localError = [[error copy] autorelease];
                        }
                        dispatch_group_leave(localGroup);
                    }];
                }else{
                    localError = [[error copy] autorelease];
                }
                dispatch_group_leave(localGroup);
            }];
        }
        dispatch_group_enter(localGroup);
        [self pullWithCompletionBlock:^(NSError *error) {
            if(error){
                localError = [[error copy] autorelease];
            }
            dispatch_group_leave(localGroup);
        }];
        
        dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
            if(completionBlock != nil){
                completionBlock(localError);
            }
        });
        dispatch_release(localGroup);
        
    }else{
        //判断购物车是否已经有同种商品
        BOOL find = NO;
        for(int i = 0;i<localCartItems.count;i++){
            if([localCartItems[i][@"speciesId"] isEqualToString:item[@"speciesId"]] &&
               [localCartItems[i][@"sku"] isEqualToString:item[@"sku"]]){
                NSInteger quantity = [localCartItems[i][@"prodNumber"] integerValue] + [item[@"prodNumber"] integerValue];
                
                NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary:localCartItems[i]];
                [modifiedItem setObject:[NSNumber numberWithUnsignedInteger:quantity] forKey:@"prodNumber"];
                [localCartItems replaceObjectAtIndex:i withObject:[[modifiedItem copy] autorelease]];
                find = YES;
                break;
            }
        }
        //没有已加入的同种商品
        if(!find){
            [localCartItems addObject:item];
        }
        
        if(completionBlock != nil){
            completionBlock(nil);
        }
    }
    
}

- (void)clearAfterLogout
{
    [self clearAfterLogoutCompletion:nil];
}

- (void)clearAfterLogoutCompletion:(void (^)())completionBlock{
    @synchronized(self){
        [localCartItems removeAllObjects];
        [serverCartItems removeAllObjects];
    }
}

- (void)pullCompletion:(void(^)())completionBlock;
{
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
//    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
//    [params setObject:[NSNumber numberWithInt:32767] forKey:@"num"];
//    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
//    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
//    
//    [RemoteManager Posts:kGET_CART_INFO Parameters:params WithBlock:^(id json, NSError *error) {
//        if (!error)
//        {
//            if([[json objectForKey:@"state"] integerValue] == 1){
//                @synchronized(self){
//                    [serverCartItems removeAllObjects];
//                    [serverCartItems addObjectsFromArray:json[@"cartList"]];
//                    [localCartItems removeAllObjects];
//                    [localCartItems addObjectsFromArray:json[@"cartList"]];
//                }
//                
//                if(completionBlock != nil){
//                    completionBlock();
//                }
//            }else{
//                NSLog(@"获取服务器购物车商品失败");
//                NSLog(@"server error");
//                NSLog(@"reason: %@",[json objectForKey:@"message"]);
//            }
//        }
//    }];
//    [params release];
    [self pullWithCompletionBlock:^(NSError *error) {
        if(completionBlock != nil){
            completionBlock();
        }
    }];
}

- (void)pullWithCompletionBlock:(void(^)(NSError *error))completionBlock{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NSNumber numberWithInt:32767] forKey:@"num"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    
    __block NSError *localError = nil;
    dispatch_group_t localGroup = dispatch_group_create();
    dispatch_group_enter(localGroup);
    [RemoteManager Posts:kGET_CART_INFO Parameters:params WithBlock:^(id json, NSError *error) {
        if (!error){
            if([[json objectForKey:@"state"] integerValue] == 1){
                @synchronized(self){
                    [serverCartItems removeAllObjects];
                    [serverCartItems addObjectsFromArray:json[@"cartList"]];
                    [localCartItems removeAllObjects];
                    [localCartItems addObjectsFromArray:json[@"cartList"]];
                }
            }else{
                NSLog(@"获取服务器购物车商品失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                localError = [[[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{@"message":@"服务器返回错误"}] autorelease];
            }
        }else{
            localError = [[error copy] autorelease];
        }
        dispatch_group_leave(localGroup);
    }];
    [params release];
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(localGroup);
}

- (void)syncCompletion:(void(^)())completionBlock;
{
    dispatch_group_t localGroup = dispatch_group_create();
    __block NSError *localError = nil;
    
    NSMutableArray *_localCart = [localCartItems mutableCopy];
    NSMutableArray *_serverCart = [serverCartItems mutableCopy];
    
    for(int j=0;j<[_localCart count];j++) {
        NSDictionary *obj = _localCart[j];
        
        for(int i=0; i<[_serverCart count];i++){
            if([_serverCart[i][@"speciesId"] isEqualToString:obj[@"speciesId"]] &&
               [_serverCart[i][@"sku"] isEqualToString:obj[@"sku"]]){
                //如果本地商品和服务器商品数量不同，则需要合并
                NSUInteger localQuantity = [obj[@"prodNumber"] unsignedIntegerValue];
                NSUInteger serverQuantity = [_serverCart[i] unsignedIntegerValue];
                if(localQuantity != serverQuantity){
                    NSLog(@"购物车：本地商品和服务器商品数量冲突，需要合并");
                    dispatch_group_enter(localGroup);
                    [self requestUpdateProductQuantityWithSpeciesId:obj[@"speciesId"] andSku:obj[@"sku"] previousQuantity:[serverCartItems[i][@"prodNumber"] integerValue] nowQuantity:localQuantity+serverQuantity completion:^(NSError *error0) {
                        if(error0 == nil){
                            dispatch_group_enter(localGroup);
                            [self pullWithCompletionBlock:^(NSError *error1) {
                                if(error1 != nil){
                                    localError = [[error1 copy] autorelease];
                                }
                                dispatch_group_leave(localGroup);
                            }];
                        }else{
                            localError = [[error0 copy] autorelease];
                        }
                        dispatch_group_leave(localGroup);
                    }];
                    
//                        [self requestUpdateProductQuantityWithSpeciesId:obj[@"speciesId"] andSku:obj[@"sku"] previousQuantity:[serverCartItems[i][@"prodNumber"] integerValue] nowQuantity:localQuantity+serverQuantity success:^(){
//                            [self pullCompletion:completionBlock];
//                        } failure:^(){
//                            [self pullCompletion:completionBlock];
//                        }];
                }
                [_serverCart removeObjectAtIndex:i];
                [_localCart removeObjectAtIndex:j];
                j--;
                i--;
            }
        }
    }
//        
        if(_localCart.count>0){
            //上传至服务器
            NSLog(@"购物车：上传至服务器");
            for(int i=0;i<_localCart.count;i++) {
                dispatch_group_enter(localGroup);
                [self requestAddItemToCart:_localCart[i] completion:^(NSError *error0) {
                    if(error0 != nil){
                        localError = [[error0 copy] autorelease];
                    }
                    dispatch_group_leave(localGroup);
                }];
//                [self requestAddItemToCart:_localCart[i] success:^{
//                    if(i == _localCart.count - 1){
//                        [self pullCompletion:completionBlock];
//                    }
//                } failure:nil];
            }
        }
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        [self pullCompletion:completionBlock];
    });
        
        [_localCart release];
        [_serverCart release];
    
    dispatch_release(localGroup);
}

- (void)sync
{
    [self syncCompletion:nil];
}

- (void)updateQuantityOfSpeciesId:(NSString *)speciesId
                           andSku:(NSString *)sku
                         quantity:(NSInteger)quantity
                       success:(void (^)())successBlock
                          failure:(void (^)())failureBlock
{
    if(APP_DELEGATE.isLoggedIn){
        for(int i =0;i<serverCartItems.count;i++){
            if([serverCartItems[i][@"speciesId"] isEqualToString:speciesId] &&
               [serverCartItems[i][@"sku"] isEqualToString:sku]){
                NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary:serverCartItems[i]];
                [modifiedItem setObject:[NSNumber numberWithUnsignedInteger:quantity] forKey:@"prodNumber"];
                int oldNum = [serverCartItems[i][@"prodNumber"] intValue];
                [modifiedItem setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
                [self requestUpdateProductQuantityWithSpeciesId:speciesId
                                                         andSku:sku
                                               previousQuantity:oldNum
                                                    nowQuantity:quantity
                                                        success:^(){
                                                            [serverCartItems replaceObjectAtIndex:i withObject:[[modifiedItem copy] autorelease]];
                                                            if(successBlock != nil){
                                                                successBlock();
                                                            }
                                                        }
                                                        failure:failureBlock];
                break;
            }
        }
    }else{//not logged in
        for(int i =0;i<localCartItems.count;i++){
            if([localCartItems[i][@"speciesId"] isEqualToString:speciesId] &&
               [localCartItems[i][@"sku"] isEqualToString:sku]){
                NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary:localCartItems[i]];
                [modifiedItem setObject:[NSNumber numberWithUnsignedInteger:quantity] forKey:@"prodNumber"];
                [localCartItems replaceObjectAtIndex:i withObject:[[modifiedItem copy] autorelease]];
                if(successBlock != nil){
                    successBlock();
                }
                break;
            }
        }
    }
}

#pragma mark - request to server
- (void)requestEmptyCart{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:@1 forKey:@"num"];
    [param setObject:@1 forKey:@"pageIndex"];
    
    [RemoteManager PostAsync:kDELETE_ALL_CART_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSLog(@"清空购物车成功");
            }else{
                NSLog(@"清空购物车失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"清空购物车失败");
            NSLog(@"network error: %@",error);
        }
    }];
    [param release];
}

- (void)requestAddItemToCart:(NSDictionary *)item completion:(void(^)(NSError *error))completionBlock
{
    __block NSError *localError = nil;
    dispatch_group_t localGroup = dispatch_group_create();
    
    NSString *itemStr = nil;
    NSError *err = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:item];
    [dict setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];//增加登录用户名字段，请求必填
    NSArray *itemsArr = [NSArray arrayWithObject:[[dict copy] autorelease]];//顶层必须是数组
    NSData *itemData = [NSJSONSerialization dataWithJSONObject:itemsArr options:0 error:&err];
    
    if(err == nil){
        itemStr = [[[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding] autorelease];
    }else{
        NSLog(@"向服务器购物车添加商品失败");
        NSLog(@"json转换失败");
        localError = [NSError errorWithDomain:@"hueasy.shoppingcart" code:-1 userInfo:@{@"message":@"参数json转换失败"}];
        if(completionBlock != nil){
            completionBlock(localError);
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:itemStr forKey:@"cartWareInfoList"];
    
    dispatch_group_enter(localGroup);
    [RemoteManager PostAsync:kADD_CART_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSLog(@"向服务器购物车添加商品成功");
                localError = nil;
            }else{
                NSLog(@"向服务器购物车添加商品失败, params: %@",param);
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                localError = [NSError errorWithDomain:@"hueasy.shoppingcart" code:-1 userInfo:@{@"message":@"服务器返回错误"}];
            }
        }else{
            NSLog(@"向服务器购物车添加商品失败");
            NSLog(@"network error: %@",error);
            localError = error;
        }
        dispatch_group_leave(localGroup);
    }];
    [param release];
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(localGroup);
}

- (void)requestAddItemToCart:(NSDictionary *)item success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock
{
    NSString *itemStr = nil;
    NSError *err = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:item];
    [dict setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];//增加登录用户名字段，请求必填
    NSArray *itemsArr = [NSArray arrayWithObject:[[dict copy] autorelease]];//顶层必须是数组
    NSData *itemData = [NSJSONSerialization dataWithJSONObject:itemsArr options:0 error:&err];
    
    if(err == nil){
        itemStr = [[[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding] autorelease];
    }else{
        NSLog(@"向服务器购物车添加商品失败");
        NSLog(@"json转换失败");
        if(failureBlock != nil){
            failureBlock();
        }
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:itemStr forKey:@"cartWareInfoList"];
    
    [RemoteManager Posts:kADD_CART_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSLog(@"向服务器购物车添加商品成功");
                if(successBlock != nil){
                    successBlock();
                }
            }else{
                NSLog(@"向服务器购物车添加商品失败, params: %@",param);
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                if(failureBlock != nil){
                    failureBlock();
                }
            }
        }else{
            NSLog(@"向服务器购物车添加商品失败");
            NSLog(@"network error: %@",error);
            if(failureBlock != nil){
                failureBlock();
            }
        }
    }];
    [param release];
}

- (void)requestAddItemToCart:(NSDictionary *)item{
    [self requestAddItemToCart:item success:nil failure:nil];
}

- (void)requestDeleteItemInCartWithSpeciesId:(NSString *)speciesId
                                      andSku:(NSString *)sku
                                     success:(void(^)(void))successBlock
                                     failure:(void(^)(void))failureBlock
{
    [self requestDeleteItemInCartWithSpeciesId:speciesId andSku:sku completion:^(NSError *err) {
        if(err == nil){
            if(successBlock != nil){
                successBlock();
            }
        }else{
            if(failureBlock != nil){
                failureBlock();
            }
        }
    }];
}

- (void)requestDeleteItemInCartWithSpeciesId:(NSString *)speciesId
                                      andSku:(NSString *)sku
                                  completion:(void (^)(NSError *err))completionBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:speciesId forKey:@"speciesId"];
    [param setObject:sku forKey:@"sku"];
    [param setObject:@1 forKey:@"num"];
    [param setObject:@1 forKey:@"pageIndex"];
    
    __block NSError *localError = nil;
    dispatch_group_t localGroup = dispatch_group_create();
    
    dispatch_group_enter(localGroup);
    [RemoteManager PostAsync:kDELETE_CART_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSLog(@"从服务器删除购物车商品成功");
                localError = nil;
            }else{
                NSLog(@"从服务器删除购物车商品失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                localError = [[[NSError alloc] initWithDomain:@"" code:-1 userInfo:@{@"message":@"服务器返回错误"}] autorelease];
            }
        }else{
            NSLog(@"从服务器删除购物车商品失败");
            NSLog(@"network error: %@",error);
            localError = [[error copy] autorelease];
        }
        dispatch_group_leave(localGroup);
    }];
    [param release];
    
    dispatch_group_notify(localGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(localGroup);
}

- (void)requestDeleteItemInCartWithSpeciesId:(NSString *)speciesId
                                      andSku:(NSString *)sku
{
    [self requestDeleteItemInCartWithSpeciesId:speciesId
                                        andSku:sku
                                       success:nil
                                       failure:nil];
}


- (void)requestUpdateProductQuantityWithSpeciesId:(NSString *)speciesId
                                         andSku:(NSString *)sku
                               previousQuantity:(NSInteger)preBuyNum
                                    nowQuantity:(NSInteger)nowBuyNum
                                        success:(void(^)(void))successBlock
                                        failure:(void(^)(void))failureBlock
{
    int type = nowBuyNum>preBuyNum?1:0;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"flag"];
    [params setObject:[NSNumber numberWithInteger:preBuyNum] forKey:@"preBuyNum"];
    [params setObject:[NSNumber numberWithInteger:nowBuyNum] forKey:@"nowBuyNum"];
    [params setObject:speciesId forKey:@"speciesId"];
    [params setObject:sku forKey:@"sku"];
    
    [RemoteManager Posts:kCHANGE_AMOUNT Parameters:params WithBlock:^(id json, NSError *error) {
        if (!error)
        {
            if([[json objectForKey:@"state"] integerValue] == 1){
                if(successBlock != nil){
                    successBlock();
                }
            }else{
                NSLog(@"购物车商品数量增减失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                if(failureBlock != nil){
                    failureBlock();
                }
            }
        }
    }];
    [params release];
}

- (void)requestUpdateProductQuantityWithSpeciesId:(NSString *)speciesId
                                           andSku:(NSString *)sku
                                 previousQuantity:(NSInteger)preBuyNum
                                      nowQuantity:(NSInteger)nowBuyNum
                                          completion:(void(^)(NSError *error))completionBlock
{
    __block NSError *localError = nil;
    dispatch_group_t localGroup = dispatch_group_create();
    
    int type = nowBuyNum>preBuyNum?1:0;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"flag"];
    [params setObject:[NSNumber numberWithInteger:preBuyNum] forKey:@"preBuyNum"];
    [params setObject:[NSNumber numberWithInteger:nowBuyNum] forKey:@"nowBuyNum"];
    [params setObject:speciesId forKey:@"speciesId"];
    [params setObject:sku forKey:@"sku"];
    
    dispatch_group_enter(localGroup);
    [RemoteManager PostAsync:kCHANGE_AMOUNT Parameters:params WithBlock:^(id json, NSError *error) {
        if (!error){
            if([[json objectForKey:@"state"] integerValue] != 1){
                NSLog(@"购物车商品数量增减失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                localError = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"message":[json objectForKey:@"message"]}];
            }
        }else{
            localError = [[error copy] autorelease];
        }
        dispatch_group_leave(localGroup);
    }];
    [params release];
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        if(completionBlock != nil){
            completionBlock(localError);
        }
    });
    
    dispatch_release(localGroup);
}

-(void)getshoppingCartFromServer
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NSNumber numberWithInt:32767] forKey:@"num"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    
    [RemoteManager Posts:kGET_CART_INFO Parameters:params WithBlock:^(id json, NSError *error) {
        if (!error)
        {
            if([[json objectForKey:@"state"] integerValue] == 1){
                [serverCartItems removeAllObjects];
                [serverCartItems addObjectsFromArray:json[@"cartList"]];
            }else{
                NSLog(@"获取服务器购物车商品失败");
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }
    }];
    [params release];
}
@end
