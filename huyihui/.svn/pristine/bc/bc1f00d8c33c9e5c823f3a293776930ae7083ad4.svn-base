//
//  RemoteManager.h
//  huyihui
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteManager : NSObject

+ (void)Posts:(NSString *)url Parameters:(NSDictionary *)dict WithBlock:(void(^)(id json, NSError *error))block;  //POST

+ (void)PostAsync:(NSString *)url Parameters:(NSDictionary *)dict WithBlock:(void(^)(id json, NSError *error))block;  //Async POST

+ (void)Gets:(NSString *)url Parameters:(NSDictionary *)dict WithBlock:(void(^)(id json, NSError *error))block;   //GET

//同步调用，测试接口用
+ (id)PostTest:(NSString *)url Parameters:(NSDictionary *)dict;
@end
