//
//  HuEasyOrder.m
//  huyihui
//
//  Created by John Zhang on 4/12/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "HuEasyOrder.h"
@interface HuEasyOrder()
{
    NSMutableDictionary *_data;
}
@end

@implementation HuEasyOrder

- (id)init
{
    self = [super init];
    if(self){
        _data = [NSMutableDictionary new];
        
        //初始化默认值
        [self setValue:@0 forKey:@"payMethod"];
        [self setValue:@0 forKey:@"point"];
        [self setValue:@"" forKey:@"billingTitle"];
        [self setValue:@0 forKey:@"orderType"];
        [self setValue:@"auto" forKey:@"groupId"];
        [self setValue:@"" forKey:@"remark"];
        [self setValue:@"ALIPAY" forKey:@"payBank"];
        [self setValue:@"" forKey:@"couponId"];
        [self setValue:@"1" forKey:@"deliveryOption"];//默认选择快递
        [self setValue:@"1" forKey:@"deliveryTime"];
        [self setValue:@"0" forKey:@"isBilling"];
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    [super dealloc];
}

static NSString * getterToSetter(NSString *getter)
{
    NSString *firstCharecter = [getter substringWithRange:NSMakeRange(0, 1)];
    return [NSString stringWithFormat:@"set%@:",[getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstCharecter uppercaseStringWithLocale:[NSLocale currentLocale]]]];
}

- (void)setValue:(id)value forKey:(id)key
{
    if([key isKindOfClass:[NSString class]] && [self respondsToSelector:NSSelectorFromString(key)]){
        SEL aSelector = NSSelectorFromString(getterToSetter(key));
        if(![value isEqual:[NSNull null]]){
            [self performSelector:aSelector withObject:value];
            [_data setValue:value forKey:key];
        }
    }else{
        [self setValue:value forUndefinedKey:key];
    }
}

//+ (BOOL)instancesRespondToSelector:(SEL)aSelector
//{
//    return [[self class] instancesRespondToSelector:aSelector];
//}
//- (BOOL)respondsToSelector:(SEL)aSelector
//{
//    NSLog(@"%@", NSStringFromSelector(aSelector));
//    IMP imp = [NSObject instanceMethodForSelector:aSelector];
//    return [super respondsToSelector:aSelector];
//}

//接口中不需要的键在这里设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key %@ is not set, its value is %@.",key, value);
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"Set nil value for key: %@", key);
    return [super setNilValueForKey:key];
}

- (NSString *)description
{
    NSMutableString *strM = [[NSMutableString new] autorelease];
    [_data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendString:[NSString stringWithFormat:@"(%@: %@);",key,obj]];
    }];
    return [[strM copy] autorelease];
}

- (void)loadDataFromDictionary:(NSDictionary *)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key];
    }];
}

- (NSDictionary *)toDictionary
{
    return [[_data copy] autorelease];
}

- (id)objectForKey:(id)key
{
    return [_data objectForKey:key];
}

- (void)setObject:(id<NSCopying>)object forKey:(id)aKey
{
    if(object != nil){
        [self setValue:object forKey:aKey];
    }else{
        [self setNilValueForKey:aKey];
    }
}

@end
