//
//  CtDataBase.m
//  ECMobile
//
//  Created by fang on 13-7-9.
//  Copyright (c) 2013年 fang. All rights reserved.
//

#import "CtDataBase.h"
#import "FMDatabaseQueue.h"


//#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
//#import "FMDatabasePool.h"
#import "FMResultSet.h"

@implementation CtDataBase


CtDataBase *ctDataBaseinstance = nil;
//static dispatch_once_t once;

+ (CtDataBase *)sharedSocketInstance;
{
    
    if(!ctDataBaseinstance)
    {
        NSLog(@"创建数据库实例");
        ctDataBaseinstance = [[CtDataBase alloc] init];
    }
        return ctDataBaseinstance;
    
//    dispatch_once( &once, ^{
//        NSLog(@"创建数据库实例");
//        instance = [[CtDataBase alloc] init];
//    } );
    
//    return instance;
}


+(void)refreshDBPath;
{
    [ctDataBaseinstance release],ctDataBaseinstance = nil;
    NSLog(@"释放数据库实例");
//    instance = [[CtDataBase alloc] init];
}



-(FMDatabaseQueue*)dbQueue;
{
    return dbQueue;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        NSString *databasePath = [NUSD objectForKey:kCURRENT_USER_DATABASE_PATH];
        NSLog(@"databasePath:%@",databasePath);
        if(databasePath){
            dbQueue = [[FMDatabaseQueue databaseQueueWithPath:databasePath] retain];
        }
    }
    
    
    return self;
    
}


- (void)dealloc
{
    
    [dbQueue release];
    [super dealloc];
}
//创建表

-(BOOL)createTable:(NSString*)sqlCreateTable
{
    __block BOOL result = NO;
    NSLog(@"createTable is :%@\n",sqlCreateTable);
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
//        [fdb open];
        if (![fdb executeUpdate:sqlCreateTable])
        {
            NSLog(@"创建数据表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"创建数据表成功\n");
            result = YES;
        }
        
//        [fdb close];
        
    }];
    return result;
    
    
}


-(BOOL)execSql:(NSString *)sql
{
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase* fdb){
        NSLog(@"excSql is :%@\n",sql);
        
        [fdb open];
        
        if (![fdb executeUpdate:sql])
        {
            NSLog(@"执行sql失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"执行sql成功\n");
            result = YES;
        }
        
        [fdb close];
    }];
    return result;
    
}

//-(BOOL)execWithSqlArr:(NSArray*)sqlArr
//{
//    NSLog(@"execSqlArr is :%@\n",sqlArr);
//    
//    [dbQueue inDatabase:^(FMDatabase* fdb){
//        
//        if([fdb open])
//        {
//        [fdb beginTransaction];
//        for(int i=0; i<[sqlArr count]; i++)
//        {
//            [fdb executeUpdate:[sqlArr objectAtIndex:i]];
//        }
//        [fdb commit];
//        [fdb close];
//        }
//        else
//        {
//            NSLog(@"打开数据库失败");
//        }
//    }];
//    return YES;
//}


-(BOOL)InsertTable:(NSString*)sqlInsert
{
    __block BOOL result = NO;
    NSLog(@"[InsertTable]:%@\n",sqlInsert);
    [dbQueue inDatabase:^(FMDatabase* fdb){
        [fdb open];
        if (![fdb executeUpdate:sqlInsert])
        {
            NSLog(@"插入数据表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            NSLog(@"插入数据表成功\n");
            result = YES;
        }
        
        
        [fdb close];
    }];
    
    return result;
    
}


-(BOOL)UpdataTable:(NSString*)sqlUpdata{
    
    NSLog(@"[UpdataTable]:%@\n",sqlUpdata);
    [dbQueue inDatabase:^(FMDatabase*fdb){
        [fdb open];
        
        if([fdb executeUpdate:sqlUpdata])
        {
            NSLog(@"\n更新表成功\n");
        }
        else
        {
            NSLog(@"\n更新表失败\n");
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
        }
        
        [fdb close];
    }];
    
    return YES;
    
}
//select
-(NSArray*)querryTable:(NSString*)sqlQuerry
{
    NSLog(@"[querryTable]:%@\n",sqlQuerry);
    __block NSMutableArray*    array = [[NSMutableArray alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase* fdb){
        
        [fdb open];
        FMResultSet* dataSet = [fdb executeQuery:sqlQuerry];
        while ([dataSet next]) {
            NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:[dataSet resultDictionary]];
            [array addObject:dataDict];
            [dataDict release];
        }
        
        dataSet = nil;
        [fdb close];  
    }];
    
    return [array autorelease]; 
}


//
-(BOOL)transaction:(NSArray*)sqlArr
{
    NSLog(@"[%s]:%@",__func__,sqlArr);
    
   __block BOOL resFlag = TRUE;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        
        for (int i=0; i<[sqlArr count]; i++)
        {
            if([[sqlArr objectAtIndex:i] isKindOfClass:[NSString class]])
            {
                if(![db executeUpdate:((NSString*)[sqlArr objectAtIndex:i])])
                {
                    *rollback = YES;
                    resFlag = FALSE;
                    return;
                }
            }
        }

    }];
    
    return resFlag;
}


//<<<<<<< .mine
//=======

- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table
{
    return [self insertDataDictionary:dict toTable:table returnId:nil];
}

- (BOOL)insertDataDictionary:(NSDictionary *)dict toTable:(NSString *)table returnId:(NSInteger *)retId
{
    NSMutableString *sqlCmdM = [[NSMutableString alloc] init];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    NSMutableArray *replacement = [[NSMutableArray alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [args addObject:key];
        [replacement addObject:[NSString stringWithFormat:@":%@",key]];
    }];
    [sqlCmdM appendFormat:@"INSERT INTO %@(%@) VALUES(%@);",table,[args componentsJoinedByString:@","],[replacement componentsJoinedByString:@","]];
    [args release];
    [replacement release];
    
    NSLog(@"%s:%@",__func__,sqlCmdM);
    __block BOOL result = NO;
    [dbQueue inDatabase:^(FMDatabase* fdb){
        [fdb open];
        if (![fdb executeUpdate:sqlCmdM withParameterDictionary:dict])
        {
            NSLog(@"写入失败 Command =  %@ dict = %@",sqlCmdM, dict);
            NSLog(@"Last error message: %@",self.dbQueue.database.lastErrorMessage);
            result = NO;
        }
        else
        {
            result = YES;
            if(retId != nil)
            {
                NSString *queryStr = [NSString stringWithFormat:@"SELECT id FROM %@ ORDER BY id DESC LIMIT 1",table];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
                FMResultSet *dataSet = [fdb executeQuery:queryStr];
                while ([dataSet next]) {
                    NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:[dataSet resultDictionary]];
                    [array addObject:dataDict];
                    [dataDict release];
                }
                dataSet = nil;
                
                if([array count] > 0)
                {
                    *retId = [[[array objectAtIndex:0] objectForKey:@"id"] integerValue];
                }
            }
        }
        [fdb close];
    }];
    [sqlCmdM release];
    return result;
}


@end
