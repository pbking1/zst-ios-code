//
//  HuEasySystemInfo.m
//  huyihui
//
//  Created by zaczh on 14-4-21.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "HuEasySystemInfo.h"
@interface HuEasySystemInfo()

@property(copy, nonatomic) NSString *userId;
@property(copy, nonatomic) NSString *userKo;
@property(copy, nonatomic) NSNumber *versionCode;
@property(copy, nonatomic) NSString *versionName;
@property(copy, nonatomic) NSString *uploadMessage;
@property(copy, nonatomic) NSString *downLoadUrl;
@property(copy, nonatomic) NSDate *updateTime;
@property(copy, nonatomic) NSString *token;
@property(copy, nonatomic) NSString *merchantId;

@end

@implementation HuEasySystemInfo
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        [self loadValuesFromDict:dict];
    }
    
    return self;
}


- (void)loadValuesFromDict:(NSDictionary *)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([self respondsToSelector:NSSelectorFromString(key)]){
            [self setValue:obj forKey:key];
        }
    }];
}
@end
