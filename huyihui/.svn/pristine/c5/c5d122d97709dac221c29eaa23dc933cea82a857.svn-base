//
//  DataManager.m
//  MicroCoordination
//
//  Created by fang on 13-9-17.
//  Copyright (c) 2013年 fang. All rights reserved.
//

#import "DataManager.h"
#import "CtDataBase.h"

@interface DataManager()
{
//    NSDictionary* _customInterfaceDict;
}
@end

@implementation DataManager

@synthesize storageManager = _storageManager;
@synthesize delegate=_delegate;

- (id)init {
    self = [super init];
    if (self)
    {
        _storageManager = [[StorageManager alloc] init];
        
//        _customInterfaceDict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                               @"1",kLAST_COMMUNICATION_FRIENDS_LIST
//                               , nil];
    }
    return self;
}


-(void)setDelegate:(id<DataManagerDelegate>)delegate
{
    _delegate = delegate;
//    [_TcpResponseProcess reSetDelegate:_delegate];
}


- (void) dealloc
{
    [_storageManager release],_storageManager = nil;
    
//    [_customInterfaceDict release],_customInterfaceDict=nil;
    [super dealloc];
}

//-(BOOL)post:(NSString *)uri params:(NSDictionary *)params tag:(NSInteger)tag dataSourceType:(DATA_SOURCE_TYPE)type;
//{
//    NSArray* resultArr=nil;
//    
//    if(DATA_FROM_NETWOTK == type)
//    {
//        
//        [_remoteManager httpPost:uri params:params tag:tag];
//        
//    }
//    else if(DTAT_FROM_LOCAL == type)
//    {
//        resultArr = [_storageManager post:uri params:params tag:tag];
//        if([_delegate respondsToSelector:@selector(dataManager:requestResult:dataSourceType:isUpdate:tag:)])
//        {
//            [self.delegate dataManager:self requestResult:resultArr dataSourceType:type isUpdate:YES tag:-999];
//        }
//    }
//    else if(DATA_FROM_SOCKET == type)
//    {
//        if([_customInterfaceDict objectForKey:uri])
//        {
//            [_TcpResponseProcess processMessageWithTypeStr:uri withParam:params];
//        }
//        else
//        {
//            [params setValue:uri forKey:@"socketInterfaceName"];
//            NSError* err=nil;
//            NSData *reqBodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
//            if(!err)
//            {
//                [_socketManager sendWithData:reqBodyData];
//            }
//            
//        }
//    }
//    
//    else if (DATA_FROM_SOCKET_REGISTER == type)
//    {
//        [params setValue:uri forKey:@"socketInterfaceName"];
//        NSError* err=nil;
//        NSData *reqBodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
//        if(!err)
//        {
//            [_phRegisterSocketManager sendWithData:reqBodyData];
//        }
//    }
//
//    else if(DATA_NETWORK_PING == type)
//    {
//        [params setValue:uri forKey:@"socketInterfaceName"];
//        NSError* err=nil;
//        NSData *reqBodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&err];
//        if(!err)
//        {
//            [_pingSocketManager sendWithData:reqBodyData];
//        }
//    }
//    
//    return TRUE;
//}
//
//-(BOOL)postSync:(NSString *)uri parmas:(NSDictionary *)params dataSourceType:(DATA_SOURCE_TYPE)type;
//{
//    NSArray* resultArr=nil;
//    if(DATA_FROM_NETWOTK == type)
//    {
//        
//        [_remoteManager httpPostSync:uri parmas:params];
//        
//    }
//    else if(DTAT_FROM_LOCAL == type)
//    {
//        resultArr = [_storageManager postSync:uri parmas:params];
//        if([_delegate respondsToSelector:@selector(dataManager:requestResult:dataSourceType:isUpdate:tag:)])
//        {
//            [self.delegate dataManager:self requestResult:resultArr dataSourceType:type isUpdate:YES tag:-999];
//        }
//    }
//    
//    return TRUE;
//}
//
//
//-(BOOL)parseJson:(NSData*)data
//{
//    
//    return TRUE;
//}
//
//
//- (BOOL)get:(NSString *)uri params:(NSDictionary *)params tag:(NSInteger)tag dataSourceType:(DATA_SOURCE_TYPE)type
//{
//    NSArray* resultArr=nil;
//    
//    if(DATA_FROM_NETWOTK == type)
//    {
//        //        [_remoteManager httpGet:uri params:params tag:tag];
//        [_remoteManager httpPost:uri params:params tag:tag];
//    }
//    else if(DTAT_FROM_LOCAL == type)
//    {
//        resultArr = [_storageManager get:uri params:params tag:tag];
//        if([_delegate respondsToSelector:@selector(dataManager:requestResult:dataSourceType:isUpdate:tag:)])
//        {
//            [self.delegate dataManager:self requestResult:resultArr dataSourceType:type isUpdate:YES tag:-999];
//        }
//        
//    }
//    
//    return TRUE;
//}
//
//- (BOOL)getSync:(NSString *)uri params:(NSDictionary *)params dataSourceType:(DATA_SOURCE_TYPE)type
//{
//    NSArray* resultArr=nil;
//    if(DATA_FROM_NETWOTK == type)
//    {
//        [_remoteManager httpGetSync:uri params:params];
//        //        [_remoteManager httpPostSync:uri parmas:params];
//    }
//    else if(DTAT_FROM_LOCAL == type)
//    {
//        resultArr = [_storageManager getSync:uri params:params];
//        if([_delegate respondsToSelector:@selector(dataManager:requestResult:dataSourceType:isUpdate:tag:)])
//        {
//            [self.delegate dataManager:self requestResult:resultArr dataSourceType:type isUpdate:YES tag:-999];
//        }
//    }
//    
//    return TRUE;
//}


@end
