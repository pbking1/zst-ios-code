//
//  DataManager.h
//  MicroCoordination
//
//  Created by fang on 13-9-17.
//  Copyright (c) 2013年 fang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StorageManager.h"

typedef enum _DATA_SOURCE_TYPE{
    DATA_FROM_NETWOTK = 0,
    DATA_FROM_SOCKET = 1,
    DTAT_FROM_LOCAL = 2,
    DATA_FROM_SOCKET_REGISTER=3,
    DATA_NETWORK_PING
}DATA_SOURCE_TYPE;



@class DataManager;

@protocol DataManagerDelegate <NSObject>

@optional

-(void)dataManager:(DataManager *)dataManager requestResult:(NSArray *)result  dataSourceType:(DATA_SOURCE_TYPE)type  isUpdate:(BOOL)flag tag:(NSInteger)tag;

-(void)dataManager:(DataManager *)dataManager requestFailed:(NSError *)error dataSourceType:(DATA_SOURCE_TYPE)type   tag:(NSInteger)tag;

@end




@interface DataManager : NSObject
{
    
}

@property(nonatomic,retain,readonly)StorageManager* storageManager;
@property(nonatomic,assign)id<DataManagerDelegate>delegate;


- (BOOL)get:(NSString *)uri params:(NSDictionary *)params tag:(NSInteger)tag dataSourceType:(DATA_SOURCE_TYPE)type;

- (BOOL)getSync:(NSString *)uri params:(NSDictionary *)params dataSourceType:(DATA_SOURCE_TYPE)type;


@end
