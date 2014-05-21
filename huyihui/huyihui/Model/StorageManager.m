//
//  StorageManager.m
//  huyihui
//
//  Created by linyi on 14-3-7.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "StorageManager.h"
#import "CtDataBase.h"

@implementation StorageManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)createDB
{
    NSLog(@"%s",__func__);
    
    //FIXME:检查数据库字段是否有更新
    NSString *databasePath = [NUSD objectForKey:kCURRENT_USER_DATABASE_PATH];
    if(!databasePath){
        NSLog(@"Error! Database path not set.");
        return;
    }
    NSLog(@"databasePath = %@",databasePath);
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\
                               \n\
                               "];
    
    NSString *messageTableSql = [[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\);"] stringByTrimmingCharactersInSet:charSet];
    
    [[CtDataBase sharedSocketInstance] transaction:
     [NSArray arrayWithObjects: messageTableSql, nil]
     ];
}

- (void) dealloc {
    [super dealloc];
}

@end
