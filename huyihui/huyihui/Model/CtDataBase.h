//
//  CtDataBase.h
//  ECMobile
//
//  Created by fang on 13-7-9.
//  Copyright (c) 2013年 fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface CtDataBase : NSObject
{
    FMDatabaseQueue *dbQueue;
}

+ (CtDataBase *)sharedSocketInstance;
+ (void)refreshDBPath;

-(FMDatabaseQueue*)dbQueue;

-(BOOL)createTable:(NSString*)sqlCreateTable;

//执行sql语句
-(BOOL)execSql:(NSString*)sql;
//-(BOOL)execWithSqlArr:(NSArray*)sqlArr;

//插入数据库表数据
-(BOOL)InsertTable:(NSString*)sqlInsert;

//更新数据
-(BOOL)UpdataTable:(NSString*)sqlUpdata;

//查询数据，以NSArray元素为NSMutableDictionary结构,NSArray元素个数即为记录数
-(NSArray*)querryTable:(NSString*)sqlQuerry;

-(BOOL)transaction:(NSArray*)sqlArr;

- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table returnId:(NSInteger *)retId;
- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table;
@end
