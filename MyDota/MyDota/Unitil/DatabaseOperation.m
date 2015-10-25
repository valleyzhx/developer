//
//  DatabaseOperation.m
//  XeraTouch
//
//  Created by cai yong on 3/12/12.
//  Copyright (c) 2012 Aldelo. All rights reserved.
//
#define keyDatabaseName @"DatabaseName"
#define keyAppStatus  @"AppStatus"         //进入过live后，保存状态，以后就不能进demo了
#define keyDatabaseName @"DatabaseName"

//#define keyDBLiveFileName @"XeraDatabase.sqlite"
//#define keyDBDemoFileName @"XeraDatabase_Demo.sqlite"
#define keyDBLiveFileName @"Wy_database.sqlite"
#define keyDBDemoFileName @"Wy_database.sqlite"
#define keyGetTableIndex  @"GetTableIndex"

#define keyDBSyncName @"XeraDatabase_Sync"
#define keyDBDemoName_1 @"XeraDatabase_Demo1.sqlite"
#define keyResturantName_1 @"xera"
#define keyDBDemoName_2 @"XeraDatabase_Demo1.sqlite"
#define keyResturantName_2 @"xera2"
#define keyWebAddress @"WebAddress"
#define keyLiveActivate @"LiveActivate"

#import "DatabaseOperation.h"
#import "sqlite3.h" 

//#import "Utility.h"
#include <sys/xattr.h>
#import "objc/runtime.h"

//static FMDatabase *dataBaseEntry;

@implementation DatabaseOperation

+ (FMDatabase *)openDataBase
{
//    if(dataBaseEntry)
//    {
//        return dataBaseEntry;
//    }

    //getDOCpath
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    
    NSString *databaseName = [[NSUserDefaults standardUserDefaults] objectForKey:keyDatabaseName];
    NSString *fn = [DOCPath stringByAppendingPathComponent:databaseName];
    //NSLog(@"db path ===>%@",fn);

    //open DB
    FMDatabase *db = [FMDatabase databaseWithPath:fn];  //dataBaseEntry
    if (![db open]) 
    {
         NSLog(@"!!!!!!Could not open db");

        db = nil;
    }
//    else
//    {
//        NSLog(@"open db OK!");
//    }

    return db;
}

+ (void)closeDataBase:(FMDatabase *)db
{    
    [db close];
    db = nil;
    //NSLog(@"Close database");	    
}


+ (BOOL)createTable:(NSString *)tableName DB:(FMDatabase *)db  //INTEGER PRIMARY KEY 
{
    Class cs = NSClassFromString(tableName); 
    NSArray *a1 = [self getPropertyAndType_SQLite:cs];   //直接转换sqlite的字段类型   //自动增加
    NSString *create_sql = [NSString stringWithFormat:@"%@ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",tableName];

    if ([tableName isEqualToString:@"OrderHeader"]) {
        create_sql = [NSString stringWithFormat:@"OrderID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT"];
    }
    for (int i = 1; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
    { 
       create_sql = [create_sql stringByAppendingFormat:@",%@ %@",
                    [[a1 objectAtIndex:0] objectAtIndex:i],[[a1 objectAtIndex:1] objectAtIndex:i]];
    }
   
    //NSLog(@"属性名称: %@",[[a1 objectAtIndex:0] objectAtIndex:i]);
    //NSLog(@"属性类型: %@",[[a1 objectAtIndex:1] objectAtIndex:i]);
    //itemSubstitutionID TEXT PRIMARY KEY,globalID TEXT,rowTS TEXT,sourceItemID TEXT,substituteItemID TEXT
    NSString *sql_String = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",tableName,create_sql];
    BOOL success = [db executeUpdate:sql_String];
    return success;
}

+ (BOOL)dropTable:(NSString *)tableName DB:(FMDatabase *)db
{
    NSString *drop_sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    BOOL success = [db executeUpdate:drop_sql];
    return success;
}

#pragma mark -
#pragma mark 从第1个字段开始插入数据(CSV专用方法)
+ (BOOL)insertObjectWithID:(NSObject *)obj toTable:(NSString *)tableName
{  
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [self getPropertyAndType_OC:cs];       //取得oc的类型
    
    NSString *fn;// = [NSString stringWithFormat:@""];         //属性名称
    NSString *ft;// = [NSString stringWithFormat:@""];         //属性type
    NSString *field_name = [NSString stringWithFormat:@""]; 
    NSString *field_value = [NSString stringWithFormat:@""];
    
    for (int i = 0; i < [[a1 objectAtIndex:0] count]; i++)  //从0开始
    { 
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);
        
        //509

        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue]; 
            field_value = [field_value stringByAppendingFormat:@",%d",aa];
        }
//        else if ([ft isEqualToString:@"float"])
//        {
//            float aa = [[obj valueForKey:fn] floatValue];
//            field_value = [field_value stringByAppendingFormat:@",%.0f",aa];
//        }
        else if ([ft isEqualToString:@"double"])
        {
//            NSLog(@"%@",[obj valueForKey:fn]);
//            NSLog(@"%f,,,%f",[[obj valueForKey:fn] doubleValue],[[obj valueForKey:fn] floatValue]);
            double bb = [[obj valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
        }
        else if ([ft isEqualToString:@"NSString"]) 
        {
            NSString *fv = [obj valueForKey:fn];     //NSLog(@"string: %@",fv);
            
            if ([fv respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                fv = [fv stringByReplacingOccurrencesOfString:@"'" withString:@"''"];  //‘：字符串转义
            }
            
            //添加到 field_value 字符串中
            field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
        }
        field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
    }
    
    field_name = [field_name substringFromIndex:1];                    //截掉，
    field_value = [field_value substringFromIndex:1];                  //截掉，
    field_value = [field_value  stringByAppendingFormat:@")"];         //加上)
    //NSLog(@"field_value: %@",field_value);
    //field_value: '9EAA0213-A1D7-4A02-AB33-DB7159D4429E',1333878912,'Server5','xxx',55,'qq',1)
    
    //生成sqlite
    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];
    //NSLog(@"insert_sql: %@",insert_sql);
    //sqlite: INSERT INTO SecurityRole(GlobalID,RowTS,SecurityRoleName,SecurityRoleAltName,POSStartScreen,Memo,Hide)
    //VALUES('9EAA0213-A1D7-4A02-AB33-DB7159D4429E',1333878912,'Server5','xxx',55,'qq',1)
    
    sqlite3 *mySqlite;
    
    //getDOCpath
    NSString *appPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseName = [[NSUserDefaults standardUserDefaults] objectForKey:keyDatabaseName];
	NSString *sqlPath =[appPath stringByAppendingPathComponent:databaseName];
	
    NSLog(@"--------->path is %@",sqlPath)  ;
    
	if (sqlite3_open([sqlPath UTF8String], &mySqlite)!= SQLITE_OK) {		
		NSLog(@"create sqlite failed");
		sqlite3_close(mySqlite);
		return NO;
	}
    
    char *error;
    //建表
    NSString *TableStr =[self getSqliteTableStr:NSClassFromString(tableName)];
    NSString *frontStr = [NSString stringWithFormat:@"_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,%@ID text",tableName];

    
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",tableName,frontStr,TableStr];
    if (sqlite3_exec(mySqlite,[createStr UTF8String], NULL,NULL, &error)!=SQLITE_OK) {
        sqlite3_close(mySqlite);
        free(error);
        return NO;
    }
    
    
	if (sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error)!= SQLITE_OK) {
		sqlite3_close(mySqlite);
		sqlite3_free(error);
        return NO;
	}
	
	sqlite3_close(mySqlite);
    
    return YES;
}

#pragma mark 从第2个字段开始插入数据
//509
+ (BOOL)insertObjectWithoutID:(NSObject *)obj toTable:(NSString *)tableName
{
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [self getPropertyAndType_OC:cs];       //取得oc的类型
    
    NSString *fn = @"";         //属性名称
    NSString *ft = @"";         //属性type
    NSString *field_name = @"";
    NSString *field_value = @"";
    
//    for (int i = 1; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
    for (int i = 0; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
    {
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);
        

        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue];
            field_value = [field_value stringByAppendingFormat:@",%d",aa];
        }
        else if ([ft isEqualToString:@"double"])
        {
            double bb = [[obj valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
        }
        else if ([ft isEqualToString:@"NSString"])
        {
            NSString *fv = [obj valueForKey:fn];          //NSLog(@"string: %@",fv);
            
            if ([fv respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                fv = [fv stringByReplacingOccurrencesOfString:@"'" withString:@"''"];  //‘：字符串转义
            }
            
            //添加到 field_value 字符串中
            field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
        }
        
        field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
    }
    
    field_name = [field_name substringFromIndex:1];                    //截掉，
    field_value = [field_value substringFromIndex:1];                  //截掉，
    field_value = [field_value  stringByAppendingFormat:@")"];         //加上)

//    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];

    sqlite3 *mySqlite;
    NSString *appPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseName = [[NSUserDefaults standardUserDefaults] objectForKey:keyDatabaseName];
	NSString *sqlPath =[appPath stringByAppendingPathComponent:databaseName];
    
    NSLog(@"sqlPath is ------------->%@",sqlPath);
    
	
	if (sqlite3_open([sqlPath UTF8String], &mySqlite)!= SQLITE_OK) {
		NSLog(@"create sqlite failed");
		sqlite3_close(mySqlite);
		return NO;
	}
    NSString *TableStr =[self getSqliteTableStr:NSClassFromString(tableName)];
    NSString *frontStr = [NSString stringWithFormat:@"%@ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",tableName];
    if ([tableName isEqualToString:@"OrderHeader"]) {
        frontStr = [NSString stringWithFormat:@"OrderID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT"];
    }
    char *error;
    
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",tableName,frontStr,TableStr];
    if (sqlite3_exec(mySqlite,[createStr UTF8String], NULL,NULL, &error)!=SQLITE_OK) {
        sqlite3_close(mySqlite);
        free(error);
        return NO;
    }
    
    
//    for (int i = 0;i < 3;++i) {
//        char *error = "";
//        int result = sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error);
//        if(result!=SQLITE_OK ) {
//            NSString *stringError =[NSString stringWithUTF8String:error];
//            if ([stringError isEqualToString:@"database is locked"]) {
//                sqlite3_free(error);
//                sleep(1);
//                continue;
//            }
//            else {
//                NSLog(@"%s",error);
//                sqlite3_free(error);
//                return NO;
//            }
//        }
//        else {
//            break;
//        }
//    }
    
	sqlite3_close(mySqlite);
    
    return YES;
}

+ (BOOL)deleteDataWithID:(int)keyprvl DB:(FMDatabase *)db nsobject:(NSObject *)nsobject
{
    NSString *tablename = NSStringFromClass(nsobject.class);

    BOOL success = [db executeUpdate:
                    [NSString stringWithFormat:@"DELETE FROM %@ where %@ID = %d",tablename,tablename,keyprvl]];
    return success;
}


+ (BOOL)saveDataWithDB:(FMDatabase *)db errorMessage:(NSString *__autoreleasing *)errorMessage nsobject:(NSObject *)nsobject{
    

    //类名跟表名必须一致
    NSString *tablename = NSStringFromClass(nsobject.class);
    
    
    @synchronized(self) { //加锁保证线程安全
        // new time card record
        if ([DatabaseOperation insertObjectWithID:nsobject toTable:tablename database:db.sqliteHandle]==NO) {
//            if (*errorMessage != nil) {
//                if (db.hadError) {
//                    *errorMessage = db.lastErrorMessage;
//                }
//                else {
//                    *errorMessage = @"Insert msg Failed";
//                }
//            }
            return NO;
        }
        

        
    }
    return YES;
    
}


#pragma mark -
#pragma mark 从第1个字段开始插入数据(CSV专用方法)
+ (BOOL)insertObjectWithID:(NSObject *)obj toTable:(NSString *)tableName database:(sqlite3 *)mySqlite
{
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [self getPropertyAndType_OC:cs];       //取得oc的类型
    
    //建表
    char *error;
    NSString *TableStr =[self getSqliteTableStr:NSClassFromString(tableName)];
    NSString *frontStr = [NSString stringWithFormat:@"%@ID TEXT NOT NULL PRIMARY KEY ",tableName];
    
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",tableName,frontStr,TableStr];
    if (sqlite3_exec(mySqlite,[createStr UTF8String], NULL,NULL, &error)!=SQLITE_OK) {
        sqlite3_close(mySqlite);
        //        free(error);
        return NO;
    }

    NSString *fn;// = [NSString stringWithFormat:@""];         //属性名称
    NSString *ft;// = [NSString stringWithFormat:@""];         //属性type
    NSString *field_name = [NSString stringWithFormat:@""];
    NSString *field_value = [NSString stringWithFormat:@""];
    
    for (int i = 0; i < [[a1 objectAtIndex:0] count]; i++)  //从0开始
    {
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);

        
        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue];
            field_value = [field_value stringByAppendingFormat:@",%d",aa];
        }
        //        else if ([ft isEqualToString:@"float"])
        //        {
        //            float aa = [[obj valueForKey:fn] floatValue];
        //            field_value = [field_value stringByAppendingFormat:@",%.0f",aa];
        //        }
        else if ([ft isEqualToString:@"double"])
        {
            //            NSLog(@"%@",[obj valueForKey:fn]);
            //            NSLog(@"%f,,,%f",[[obj valueForKey:fn] doubleValue],[[obj valueForKey:fn] floatValue]);
            double bb = [[obj valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
        }
        else if ([ft isEqualToString:@"NSString"])
        {
            NSString *fv = [obj valueForKey:fn];     //NSLog(@"string: %@",fv);
            
            if ([fv respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                fv = [fv stringByReplacingOccurrencesOfString:@"'" withString:@"''"];  //‘：字符串转义
            }
            
            //添加到 field_value 字符串中
            field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
        }
        field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
        
        //无此字段，添加
        if (![DatabaseOperation checkColumnExistsToTable:tableName columnname:fn   database:mySqlite]) {
            //ALTER TABLE  //only text type Support!!!!
            sqlite3_stmt *statement;
            NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE %@ ADD COLUMN %@ TEXT",tableName,fn];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mySqlite, update_stmt, -1, &statement, NULL);
            
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
            }
            // Release the compiled statement from memory
            sqlite3_finalize(statement);

        }
        
    }
    
    field_name = [field_name substringFromIndex:1];                    //截掉，
    field_value = [field_value substringFromIndex:1];                  //截掉，
    field_value = [field_value  stringByAppendingFormat:@")"];         //加上)
    //NSLog(@"field_value: %@",field_value);
    //field_value: '9EAA0213-A1D7-4A02-AB33-DB7159D4429E',1333878912,'Server5','xxx',55,'qq',1)
    
    //生成sqlite
    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];
    //NSLog(@"insert_sql: %@",insert_sql);
    //sqlite: INSERT INTO SecurityRole(GlobalID,RowTS,SecurityRoleName,SecurityRoleAltName,POSStartScreen,Memo,Hide)
    //VALUES('9EAA0213-A1D7-4A02-AB33-DB7159D4429E',1333878912,'Server5','xxx',55,'qq',1)
    
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(mySqlite,[insert_sql UTF8String], -1, &statement,NULL)==SQLITE_OK)
    {
        if (sqlite3_step(statement)!=SQLITE_DONE){}
    }
    else {
        return NO;
    }
    sqlite3_finalize(statement);
    
//	if (sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error)!= SQLITE_OK) {
//		sqlite3_close(mySqlite);
//		sqlite3_free(error);
//        return NO;
//	}
	
    return YES;
}


//检查某列是否存在
+(BOOL)checkColumnExistsToTable:(NSString *)tableName columnname:(NSString *)columnname database:(sqlite3 *)mySqlite
{
    BOOL columnExists = NO;
    
    sqlite3_stmt *selectStmt;
    
    const char *sqlStatement = [[NSString stringWithFormat:@"select %@ from %@",columnname,tableName] UTF8String];
    if(sqlite3_prepare_v2(mySqlite, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)
        columnExists = YES;
    
    sqlite3_finalize(selectStmt);

    return columnExists;
}

#pragma mark 从第2个字段开始插入数据
//509
+ (BOOL)insertObjectWithoutID:(NSObject *)obj toTable:(NSString *)tableName database:(sqlite3 *)mySqlite
{
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [self getPropertyAndType_OC:cs];       //取得oc的类型
    
    NSString *fn = @"";         //属性名称
    NSString *ft = @"";         //属性type
    NSString *field_name = @"";
    NSString *field_value = @"";
    
    for (int i = 1; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
    {
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);
        
        //509

        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue];
            field_value = [field_value stringByAppendingFormat:@",%d",aa];
        }
        else if ([ft isEqualToString:@"double"])
        {
            double bb = [[obj valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
        }
        else if ([ft isEqualToString:@"NSString"])
        {
            NSString *fv = [obj valueForKey:fn];          //NSLog(@"string: %@",fv);
            
            if ([fv respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                fv = [fv stringByReplacingOccurrencesOfString:@"'" withString:@"''"];  //‘：字符串转义
            }
            
            //添加到 field_value 字符串中
            field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
        }
        
        field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
    }
    
    field_name = [field_name substringFromIndex:1];                    //截掉，
    field_value = [field_value substringFromIndex:1];                  //截掉，
    field_value = [field_value  stringByAppendingFormat:@")"];         //加上)
    
    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];
    
    
    NSString *TableStr =[self getSqliteTableStr:NSClassFromString(tableName)];
    NSString *frontStr = [NSString stringWithFormat:@"%@ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",tableName];

    
    char *error;
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",tableName,frontStr,TableStr];
    if (sqlite3_exec(mySqlite,[createStr UTF8String], NULL,NULL, &error)!=SQLITE_OK) {
        return NO;
    }
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(mySqlite,[insert_sql UTF8String], -1, &statement,NULL)==SQLITE_OK)
    {
        if (sqlite3_step(statement)!=SQLITE_DONE)
        {
            
        }
    }
    else {
        sqlite3_finalize(statement);
        return NO;
    }
    
    sqlite3_finalize(statement);
//    for (int i=0;i<3;++i) {
//        char *error = "";
//        int result = sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error);
//        if(result!=SQLITE_OK ){
//            NSString *stringError =[NSString stringWithUTF8String:error];
//            if ([stringError isEqualToString:@"database is locked"]) {
//                sqlite3_free(error);
//                sleep(1);
//                continue;
//            }
//            else{
//                NSLog(@"%s",error);
//                sqlite3_free(error);
//                return NO;
//            }
//        }
//        else{
//            break;
//        }
//    }
    
    return YES;
}



#pragma mark 从第2个字段开始插入数据-----原来的命名
/*
+ (BOOL)insertTable:(NSString *)tableName Obj:(NSObject *)obj
{
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [Utility getPropertyAndType_OC:cs];       //取得oc的类型
    
    NSString *fn = [NSString stringWithFormat:@""];         //属性名称
    NSString *ft = [NSString stringWithFormat:@""];         //属性type
    NSString *field_name = [NSString stringWithFormat:@""];
    NSString *field_value = [NSString stringWithFormat:@""];
    
    for (int i = 1; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
    {
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);
        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue];
            field_value = [field_value stringByAppendingFormat:@",%d",aa];
        }
        else if ([ft isEqualToString:@"double"])
        {
            double bb = [[obj valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.2f",bb];
        }
        else if ([ft isEqualToString:@"NSString"])
        {
            NSString *fv = [obj valueForKey:fn];          //NSLog(@"string: %@",fv);
            
            if ([fv respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)])
            {
                [fv stringByReplacingOccurrencesOfString:@"'" withString:@"''"];  //‘：字符串转义
            }
            
            //添加到 field_value 字符串中
            field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
        }
        
        field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
    }
    
    field_name = [field_name substringFromIndex:1];                    //截掉，
    field_value = [field_value substringFromIndex:1];                  //截掉，
    field_value = [field_value  stringByAppendingFormat:@")"];         //加上)
    
    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];
    
    sqlite3 *mySqlite;
    NSString *appPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *databaseName = [[NSUserDefaults standardUserDefaults] objectForKey:keyDatabaseName];
    
	NSString *sqlPath =[appPath stringByAppendingPathComponent:databaseName];
	
	if (sqlite3_open([sqlPath UTF8String], &mySqlite)!= SQLITE_OK) {
		NSLog(@"create sqlite failed");
		sqlite3_close(mySqlite);
		return NO;
	}
    NSString *TableStr =[Utility getSqliteTableStr:NSClassFromString(tableName)];
    NSString *frontStr = [NSString stringWithFormat:@"%@ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",tableName];
    if ([tableName isEqualToString:@"OrderHeader"]) {
        frontStr = [NSString stringWithFormat:@"OrderID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT"];
    }
    char *error;
    
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@%@)",tableName,frontStr,TableStr];
    if (sqlite3_exec(mySqlite,[createStr UTF8String], NULL,NULL, &error)!=SQLITE_OK) {
        sqlite3_close(mySqlite);
        free(error);
        return NO;
    }
    
	
	if (sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error)!= SQLITE_OK) {
		sqlite3_close(mySqlite);
		sqlite3_free(error);
        return NO;
	}
	sqlite3_close(mySqlite);
    
    return YES;
}
*/

//509
+ (int)insertOrderHeaderWithObj:(NSObject *)obj
{
    @synchronized(self){
        NSString *tableName =@"OrderHeader";
        Class cs = NSClassFromString(tableName);
        NSArray *a1 = [self getPropertyAndType_OC:cs];       //取得oc的类型
        
        NSString *fn;// = [NSString stringWithFormat:@""];         //属性名称
        NSString *ft;// = [NSString stringWithFormat:@""];         //属性type
        NSString *field_name = [NSString stringWithFormat:@""];
        NSString *field_value = [NSString stringWithFormat:@""];
        
        
        for (int i = 1; i < [[a1 objectAtIndex:0] count]; i++)  //从1开始，第0个字段xxxID 已经加了
        {
            fn = [[a1 objectAtIndex:0] objectAtIndex:i];        //NSLog(@"name:%@",fn);
            ft = [[a1 objectAtIndex:1] objectAtIndex:i];        //NSLog(@"type:%@",ft);
            
            //509
            //---新加的属性，在数据库中没有对应字段，如果是 HCQ 开头，就跳出循环
            NSString *preFix = [fn substringWithRange:NSMakeRange(0, 3)];
            if ([preFix isEqualToString:@"HCQ"] || [preFix isEqualToString:@"hcq"]) {
                break;
            }
            
            if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
            {
                int aa = [[obj valueForKey:fn] intValue];
                field_value = [field_value stringByAppendingFormat:@",%d",aa];
            }
            else if ([ft isEqualToString:@"double"]) {
                double bb = [[obj valueForKey:fn] doubleValue];
                
                field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
                
                
            }
            else if ([ft isEqualToString:@"NSString"]) {
                NSString *fv = [obj valueForKey:fn];
                //添加到 field_value 字符串中
                field_value = [field_value stringByAppendingFormat:@",'%@'",fv];
            }
            field_name = [field_name stringByAppendingFormat:@",%@",[[a1 objectAtIndex:0] objectAtIndex:i]];
        }
        
        field_name = [field_name substringFromIndex:1];                    //截掉，
        field_value = [field_value substringFromIndex:1];                  //截掉，
        field_value = [field_value  stringByAppendingFormat:@")"];         //加上)
        
        //生成sqlite
        NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@",tableName,field_name,field_value];
        
        sqlite3 *mySqlite;
        
        //getDOCpath
        NSString *appPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSString *sqlPath =[appPath stringByAppendingPathComponent:[[NSUserDefaults standardUserDefaults] objectForKey:keyDatabaseName]];
        
        if (sqlite3_open([sqlPath UTF8String], &mySqlite)!= SQLITE_OK) {
            NSLog(@"create sqlite failed");
            sqlite3_close(mySqlite);
            return NO;
        }
        
        
        for (int i = 0;i < 3;++i) {
            char *error = "";
            int result = sqlite3_exec(mySqlite, [insert_sql UTF8String], NULL, NULL, &error);
            if(result!=SQLITE_OK ) {
                NSString *stringError =[NSString stringWithUTF8String:error];
                if ([stringError isEqualToString:@"database is locked"]) {
                    sqlite3_free(error);
                    sleep(1);
                    continue;
                }
                else {
                    NSLog(@"%s",error);
                    sqlite3_free(error);
                    return NO;
                }
            }
            else {
                break;
            }
        }

        
        sqlite3_stmt *statement =nil;
        
        NSString * beginStr =[NSString stringWithFormat:@"SELECT last_insert_rowid()"];
        int count =0;
        if (sqlite3_prepare(mySqlite, [beginStr UTF8String], -1, &statement, nil)==SQLITE_OK) {
            while (sqlite3_step(statement)== SQLITE_ROW) {
                count =sqlite3_column_int(statement,0);
                //NSLog(@"插入的item其rowid为%d",count);
            }
        }
        
        //   statement =nil;
        //
        //    NSString *endStr  =[NSString stringWithFormat:@"SELECT * FROM OrderHeader WHERE rowid ==%d",count];
        //    if (sqlite3_prepare(mySqlite, [endStr UTF8String], -1, &statement, nil)==SQLITE_OK) {
        //        while (sqlite3_step(statement)== SQLITE_ROW) {
        //
        //            int nowcount =sqlite3_column_int(statement,0);
        //            
        //            NSString *name =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)];
        //            NSString *age =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)];
        //            
        //            NSLog(@"%d,,,%@,,,%@",nowcount,name,age);
        //        }
        //    }
        
        sqlite3_finalize(statement); // or multiple call this mehtod will cause the database locked
        sqlite3_close(mySqlite);
        
        return count;
    }
}

+ (BOOL)deleteRecordeWithID:(int)xid TableName:(NSString *)tableName DB:(FMDatabase *)db
{
    NSString *delete_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ID = %d ",tableName,tableName,xid];
    if ([tableName isEqualToString:@"OrderHeader"]) {
        delete_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE OrderID = %d ",tableName,xid];
    }
    //NSLog(@"delete_sql= %@",delete_sql);

    BOOL success = [db executeUpdate:delete_sql];
    return success;
}

+ (BOOL)deleteRecordeWithGUID:(NSString *)gid TableName:(NSString *)tableName DB:(FMDatabase *)db
{
    NSString *delete_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE GlobalID = '%@'",tableName,gid];
    BOOL success = [db executeUpdate:delete_sql]; //@"delete from ? where GlobalID = ?",tableName,gid];
    return success;
}

+ (BOOL)deleteRecordeWithSqlStr:(NSString *)string DB:(FMDatabase *)db
{
    BOOL success = [db executeUpdate:string];
    return success;
}

//509
+ (BOOL)updateRecordeWithID:(NSString *)xid TableName:(NSString *)tableName Obj:(NSObject *)obj DB:(FMDatabase *)db
{
    NSString *set_string = [NSString stringWithFormat:@""];    //列名 = 新值 ...
    
    Class cs = NSClassFromString(tableName);
    NSArray *a1 = [self getPropertyAndType_OC:cs];          //取得oc的类型
    
    NSString *fn;// = [NSString stringWithFormat:@""];            //属性名称
    NSString *ft;// = [NSString stringWithFormat:@""];            //属性type
    
    for (int i = 0; i < [[a1 objectAtIndex:0] count]; i++)     //从4开始，前3个字段不改
    { 
        fn = [[a1 objectAtIndex:0] objectAtIndex:i];   //NSLog(@"name:%@",fn);
        ft = [[a1 objectAtIndex:1] objectAtIndex:i];   //NSLog(@"type:%@",ft);
        

        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[obj valueForKey:fn] intValue]; 
            set_string = [set_string stringByAppendingFormat:@",%@=%d ",fn,aa];
        }
//        else if ([ft isEqualToString:@"float"])
//        {
//            float aa = [[obj valueForKey:fn] floatValue];
//            set_string = [set_string stringByAppendingFormat:@",%@=%.2f ",fn,aa];
//        }
        else if ([ft isEqualToString:@"double"]) 
        {
            double aa = [[obj valueForKey:fn] doubleValue]; //NSLog(@"aa = %2.2f",aa);
            set_string = [set_string stringByAppendingFormat:@",%@=%.6f ",fn,aa];
        }
        else if ([ft isEqualToString:@"NSString"]) 
        {
            NSString *fv = [obj valueForKey:fn];    //NSLog(@"string: %@",fv);
            set_string = [set_string stringByAppendingFormat:@",%@='%@' ",fn,fv];
        }

    }
    
    set_string = [set_string substringFromIndex:1];     //截掉，
    
//    NSString *update_sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ID = %@ ",tableName,set_string,tableName,xid];
    NSString *update_sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ID = '%@' ",tableName,set_string,tableName,xid];

    

    
    //NSLog(@"update_sql= %@",update_sql);
    BOOL success = [db executeUpdate:update_sql];
    
    return success;
}

//查询数据库中有多少条记录
+ (int)recordeCountInTable:(NSString *)tableName DB:(FMDatabase *)db
{    
    NSString *ss = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",tableName];
    return [db intForQuery:ss]; 
}

/*
+ (NSArray *)queryDataBase:(FMDatabase *)db Table:(NSString *)table QueryString:(NSString *)qs FieldType:(NSArray *)fieldtype FieldName:(NSArray *)fieldname
{ 
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];   //保存所有字段的值
    NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];  //SecurityRole对象--》数组
    
    FMResultSet *rs = [db executeQuery:qs];
    
    while ([rs next])  
    {
        //前3个字段固定
        NSString *a0 = [NSString stringWithFormat:@"%@ID",table];
        if ([table isEqualToString:@"OrderHeader"]) {
            a0 =[NSString stringWithFormat:@"OrderID"];
        }
        //NSLog(@"add orderid");
        //按字段顺序赋值(查询SecurityRoleObject)
        NSString *a1 = [NSString stringWithFormat:@"%d",[rs intForColumn:a0]];
        [tempArray addObject:a1];  //NSLog(@"a1 = %@",a1);
        
        [tempArray addObject:[rs stringForColumn:@"GlobalID"]];
        [tempArray addObject:[rs stringForColumn:@"RowTS"]];
        
        //从第4字段开始循环
        for (int i = 0; i < [fieldname count]; i++) 
        {
            if ([[fieldtype objectAtIndex:i] isEqualToString:@"int"] || [[fieldtype objectAtIndex:i] isEqualToString:@"bool"] || [[fieldtype objectAtIndex:i] isEqualToString:@"BOOL"]) 
            {
                NSString *fname = [fieldname objectAtIndex:i];
                NSString *aa = [NSString stringWithFormat:@"%d",[rs intForColumn:fname]];
                [tempArray addObject:aa];
            }
            else if ([[fieldtype objectAtIndex:i] isEqualToString:@"double"] || [[fieldtype objectAtIndex:i] isEqualToString:@"float"]) 
            {
                NSString *fname = [fieldname objectAtIndex:i];  ////没有floatForColumn
                NSString *aa = [NSString stringWithFormat:@"%f",[rs doubleForColumn:fname]]; 
                [tempArray addObject:aa];
            }
            //            else if ([[fieldtype objectAtIndex:i] isEqualToString:@"date"] || [[fieldtype objectAtIndex:i] isEqualToString:@"datetime"]) 
            //            {
            //                [tempArray addObject:[rs dateForColumn:[fieldname objectAtIndex:i]]]; 
            //            }
            else
            {
                [tempArray addObject:[rs stringForColumn:[fieldname objectAtIndex:i]]]; 
            }
            
        }
        
        Class c = NSClassFromString(table);  
        id obj = [[c alloc] initWithArray:tempArray];
        [tempArray2 addObject:obj];
        [tempArray removeAllObjects];  //这行很重要，不然数据会追加到后面，前几个值总不变
    } 
    
    [rs close];
    
    return tempArray2;
}
*/

+ (NSString*)getName:(NSString*)nameStr ByID:(NSString*)IDName IDValue:(int)value FromSql:(NSString*)sqlName
{
    NSString *returnStr =@"";
    
    FMDatabase *db = [DatabaseOperation openDataBase];
 	NSString *selectStr =[NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d",nameStr,sqlName,IDName,value];
    
    FMResultSet *rs = [db executeQuery:selectStr];
    while([rs next]) {
        NSString *NAME =[rs columnNameForIndex:0];
        returnStr =[rs stringForColumn:NAME];
    }
    [rs close];
    
    [DatabaseOperation closeDataBase:db];
    
    return returnStr;
}

//509
+ (NSArray *)queryTable:(NSString *)tableName QueryString:(NSString *)qs DB:(FMDatabase *)db
{
    return [self selfqueryTable:tableName QueryString:qs DB:db isall:false];
}

//509
//查询数据太多需耗时，如果查询的数量超过100个，先查100个。剩下的在子线程中完成
+ (NSArray *)queryTable100:(NSString *)tableName QueryString100:(NSString *)qs DB:(FMDatabase *)db
{
    return [self selfqueryTable:tableName QueryString:qs DB:db isall:true];
}

+ (NSArray *)selfqueryTable:(NSString *)tableName QueryString:(NSString *)qs DB:(FMDatabase *)db isall:(BOOL)is100
{
    Class cs = NSClassFromString(tableName);
    
    NSArray *octype = [self getPropertyAndType_OC:cs];        //取得oc的类型
    NSMutableArray *objArray = [[NSMutableArray alloc] init];    //对象-->数组
    
    FMResultSet *rs = [db executeQuery:qs];
    
    while ([rs next])
    {
        id obj = [[cs alloc] init];                              //创建对象
//        //前3个字段固定
//        NSString *a0 = [NSString stringWithFormat:@"%@ID",tableName];
//        if ([tableName isEqualToString:@"OrderHeader"]) {
//            a0 =[NSString stringWithFormat:@"OrderID"];
//            // NSLog(@"add orderid");
//        }
//        NSString *a1 = [NSString stringWithFormat:@"%d",[rs intForColumn:a0]];
//        //NSString *a2 = [NSString stringWithFormat:@"%.0f",[rs doubleForColumn:@"RowTS"]];
//        
//        [obj setValue:a1 forKey:a0];                                           //KVO 设置对象的属性值
//        [obj setValue:[rs stringForColumn:@"GlobalID"] forKey:@"GlobalID"];    //KVO 设置对象的属性值
//        [obj setValue:[rs stringForColumn:@"RowTS"] forKey:@"RowTS"];          //KVO 设置对象的属性值
        
        //从第4字段开始循环
//        for (int i = 3; i < [[octype objectAtIndex:0] count]; i++)
        for (int i = 0; i < [[octype objectAtIndex:0] count]; i++)
        {
            NSString *fname = [[octype objectAtIndex:0] objectAtIndex:i];
            NSString *ftype = [[octype objectAtIndex:1] objectAtIndex:i];
            //NSLog(@"fname:%@",fname); NSLog(@"ftype:%@",ftype);

            
            if ([ftype isEqualToString:@"int"] || [ftype isEqualToString:@"BOOL"])         //不再有bool了
            {
                NSNumber *aa = [NSNumber numberWithInt:[rs intForColumn:fname]];
                [obj setValue:aa forKey:fname];
                
            }
            else if ([ftype isEqualToString:@"double"] || [ftype isEqualToString:@"float"]) //不再有float了
            {
                //数据库中没有floatForColumn
                //NSString *aa = [NSString stringWithFormat:@"%.0f",[rs doubleForColumn:fname]];
                //NSLog(@"%f",[rs doubleForColumn:fname]);
                NSNumber *bb = [NSNumber numberWithDouble:[rs doubleForColumn:fname]];
                [obj setValue:bb forKey:fname];
            }
            else
            {
                //NSString *aa = [NSString stringWithFormat:@"%@",[rs stringForColumn:fname]];
                [obj setValue:[rs stringForColumn:fname] forKey:fname];
            }
        }
        [objArray addObject:obj];
        if (objArray.count > 100 && is100) {
            return objArray;
        }
    }
    [rs close];
    return objArray;
}


+ (NSSet *)getGUIDfromTable:(NSString *)tableName DB:(FMDatabase *)db
{ 
    NSMutableSet *objArray = [[NSMutableSet alloc] init]; 
    NSString *sql_string = [NSString stringWithFormat:@"select GlobalID from %@",tableName];
    FMResultSet *rs = [db executeQuery:sql_string];
    
    while ([rs next])  
    {
        NSString *ss = [rs stringForColumn:@"GlobalID"]; 
        if (ss) {
            [objArray addObject:ss];
        }
    } 
    [rs close];
    
    return objArray;
}

#pragma mark - Database File Methods
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


+ (void)copy_DB2Doc_Demo
{
    //get Doc directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *fn0 = [DOCPath stringByAppendingPathComponent:keyDBDemoFileName];
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fn0]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:keyDBDemoFileName ofType:nil];
        if (defaultStorePath) {
            NSLog(@"demo file not found, copying...");
            [fileManager copyItemAtPath:defaultStorePath toPath:fn0 error:NULL];
        }
    }
    
    //设置文件 Do Not Back Up (不备份到iCloud)
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:fn0]];
}

+ (void)copy_DB2Doc_Live
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *dbPath = [DOCPath stringByAppendingPathComponent:keyDBLiveFileName];
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath])
    {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:keyDBLiveFileName ofType:nil];
        if (defaultStorePath)
        {
            NSLog(@"live file not found, copying...");
            [fileManager copyItemAtPath:defaultStorePath toPath:dbPath error:NULL];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"live" forKey:@"livedb_inited"];//
    
    [[NSUserDefaults standardUserDefaults] setObject:keyDBLiveFileName forKey:keyDatabaseName];

    [[NSUserDefaults standardUserDefaults]synchronize];

    
    //设置文件 Do Not Back Up (不备份到iCloud)
//    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dbPath]];
}


+ (void)initLiveDatabase
{
    //get Doc directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *fn = [DOCPath stringByAppendingPathComponent:keyDBLiveFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"db path --> %@",fn);
    
    if ([fileManager fileExistsAtPath:fn]) {
        [fileManager removeItemAtPath:fn error:NULL];
    }
    
    [self copy_DB2Doc_Live];
}

+ (void)initDemoDatabase
{
    //1014
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *fn = [DOCPath stringByAppendingPathComponent:keyDBDemoFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fn]) {
        [fileManager removeItemAtPath:fn error:NULL];
    }
    [self copy_DB2Doc_Demo];
}

+ (void)createAllTables
{
    NSArray *tableNames_Group1 = @[@"DBVersion",
    @"CallerIDLog",
    @"StoreSetting",
    @"StoreZZ",
    @"LCDispense",
    @"Course",
    @"ReOrderPeriod",
    @"SecurityRole",
    @"SecurityObject",
    @"SecurityRoleObject",
    @"CostCenter",
    @"POSDevice"];
    
    NSArray *tableNames_Group2 = @[@"PrepLocation",
    @"PrepLocationReroute",
    @"PrepLocationFailOver",
    @"PrepRouting",
    @"ModifierTemplate",
    @"PrepType",
    @"PrepRoutingDetail"];
    
    NSArray *tableNames_Group3 = @[@"Surcharge",
    @"MixMatchGroup",
    @"Discount",
    @"DiscountAvailability",
    @"Menu",
    @"OrderType",
    @"OrderTypeDefaultMenu",
    @"OrderTypeSetting",
    @"DiscountOrderType",
    @"Terminal",
    @"TerminalSetting",
    @"TerminalPrepRouting"];
    
    NSArray *tableNames_Group4 = @[@"HRDepartment",
    @"JobTitle",
    @"JobType",
    @"JobTypeDetail",
    @"PostalCode",
    @"Pager",
    @"Employee",
    @"SecurityUserAccount",
    @"LaborLocation",
    @"LaborLocationJob",
    @"JobSkillRating",
    @"EmployeeJobTitle",
    @"LaborBudget",
    @"LaborBudgetDetail",
    @"EmployeeSchedule",
    @"EmployeeAvailability",
    @"EmployeePayroll",
    @"EmployeePayrollDetail",
    @"EmployeeTimeCard",
    @"EmployeeTimeCardAudit",
    @"EmployeeEmail"];
    
    
    NSArray *tableNames_Group5 = @[@"PriceLevel",
    @"PriceLevelTrigger",
    @"DiscountPriceLevel",
    @"DineInTableGroup",
    @"DineInTableStatus",
    @"DineInTable",
    @"PriceLevelDineInTable",
    @"DineInSection",
    @"DineInSectionAssignment",
    @"DineInSectionDetail",
    @"DineInTableAttach",
    @"DineInTableProperty",
    @"DineInTableAttribute",
    @"DineInTableProgress"];
    
    
    NSArray *tableNames_Group6 = @[@"ItemDepartment",
    @"ItemCategory",
    @"ItemSubCategory",
    @"InventoryItemGroup",
    @"ItemSize",
    @"UOM",
    @"Item",
    @"ItemKitDetail",
    @"ItemModifierTemplate",
    @"ItemPrice",
    @"Recipe",
    @"RecipeDetail",
    @"ItemRecipe",
    @"ItemSubstitution",
    @"ItemTagAlong",
    @"ItemUpsell"];
    
    NSArray *tableNames_Group7 = @[@"CustomerType",
    @"Customer",
    @"VoidReason",
    @"VendorType",
    @"VendorRating",
    @"Vendor",
    @"VendorDetail",
    @"VendorDetailPrice",
    @"VendorInvoice",
    @"Tax",
    @"OrderHeader"];
    
    NSArray *tableNames_Group8 = @[@"CustomerDeposit",
    @"CustomerDiscount",
    @"CustomerIncident",
    @"CustomReportCategory",
    @"CustomReportItem",
    @"WaitingList",
    @"CustomerCard",
    @"CustomerPurchase",
    @"Cashier",
    @"Tender",
    @"CashierDetail",
    @"BadDebtReason",
    @"BadDebtSource",
    @"BadDebt",
    @"ARDeposit",
    @"Payment",
    @"ModifierAction",
    @"ModifierGroup",
    @"ModifierGroupAction",
    @"PizzaPortion",
    @"ModifierGroupLevelPricing",
    @"ModifierGroupPizzaPortion",
    @"ModifierGroupSize",
    @"ModifierItem",
    @"ModifierTemplateDetail",
    @"ModifierTemplateGlobalPricing",
    @"Combo",
    @"ComboDetail",
    @"ComboOrderType",
    @"ComboPriceLevel",
    @"ComboSchedule",
    @"OrderDetail"];
    
    NSArray *tableNames_Group9 = @[@"FiscalInvoice",
    @"TipOut",
    @"GratuityActivity"];
    
    NSArray *tableNames_Group10 = @[@"PO",
    @"PODetail",
    @"POSDeviceSetting",
    @"InventoryLocation",
    @"InventoryLocationItem",
    @"InventoryItemLevel",
    @"InventoryDailyRecap",
    @"InventoryDepletionReason",
    @"PhysicalCount",
    @"PhysicalCountDetail",
    @"InventoryItemActivity"];
    
    NSArray *tableNames_Group11 = @[@"MatrixColumn",
    @"MatrixGroup",
    @"MatrixGroupColumn",
    @"MatrixDetail",
    @"MenuGlobalPricing",
    @"MenuGroup",
    @"MenuGroupTrigger",
    @"MenuDetail",
    @"MenuItem",
    @"MenuOrderType",
    @"MenuTrigger",
    @"MixMatchItem"];
    
    NSArray *tableNames_Group12 = @[@"ReservationOccasion",
    @"Reservation",
    @"ReservationAttribute",
    @"ReservationTable",
    @"StreetLookup",
    @"TipPool",
    @"TipPoolActivity",
    @"TipPoolContributor",
    @"TipPoolOrderType",
    @"TipPoolReceiver",
    @"TipPoolTableGroup",
    @"TipPoolTender"];
    
    
    NSMutableArray *allTables = [NSMutableArray array];
    [allTables addObjectsFromArray:tableNames_Group1];
    [allTables addObjectsFromArray:tableNames_Group2];
    [allTables addObjectsFromArray:tableNames_Group3];
    [allTables addObjectsFromArray:tableNames_Group4];
    [allTables addObjectsFromArray:tableNames_Group5];
    [allTables addObjectsFromArray:tableNames_Group6];
    [allTables addObjectsFromArray:tableNames_Group7];
    [allTables addObjectsFromArray:tableNames_Group8];
    [allTables addObjectsFromArray:tableNames_Group9];
    [allTables addObjectsFromArray:tableNames_Group10];
    [allTables addObjectsFromArray:tableNames_Group11];
    [allTables addObjectsFromArray:tableNames_Group12];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *fn = [DOCPath stringByAppendingPathComponent:keyDBLiveFileName];
    
    
    
    //open DB
    FMDatabase *database = [FMDatabase databaseWithPath:fn];  //dataBaseEntry
    if (![database open])
    {
        //NSLog(@"Could not open db");
//        [Utility showAlert:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"Cannot Open Database",nil)];
        database = nil;
        return;
    }
//    else
//    {
//        NSLog(@"open db OK!");
//    }
    
    
    for (NSString *tableName in allTables) {
        BOOL success = [DatabaseOperation createTable:tableName DB:database];
        NSLog(@"Create Table:%@ ---%@",tableName,success ? @"Success" : @"Failed");
    }
    [self closeDataBase:database];
}

#pragma mark -
#pragma mark TerminalSetting Methods


#pragma mark -
#pragma mark StoreSetting Methods
+ (NSString *)getStoreSettingValue:(int)value DB:(FMDatabase *)db
{
    NSString *ss3 = [NSString stringWithFormat:@"SELECT SettingValue FROM StoreSetting where SettingEnum = %d",value];
    NSString *aa = [db stringForQuery:ss3];
    return aa;
    
//    if (aa.length) {
//        return aa;
//    }
//    
//    return nil;
}

+ (NSArray *)getStoreSettingAmountValue
{
    NSMutableArray *aa = [NSMutableArray arrayWithCapacity:6];
    FMDatabase *db = [DatabaseOperation openDataBase];
    NSString *s2 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 302";
    NSString *s3 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 303";
    NSString *s4 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 304";
    NSString *s5 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 305";
    NSString *s6 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 306";
    NSString *s7 = @"SELECT SettingValue FROM StoreSetting where SettingEnum = 307";

    NSString *s302 = [db stringForQuery:s2];
    if (s302 && [s302 doubleValue] != 0.0) {
        [aa addObject:s302];
    }
    
    NSString *s303 = [db stringForQuery:s3];
    if (s303 && [s303 doubleValue] != 0.0) {
        [aa addObject:s303];
    }
    
    NSString *s304 = [db stringForQuery:s4];
    if (s304 && [s304 doubleValue] != 0.0) {
        [aa addObject:s304];
    }
    
    NSString *s305 = [db stringForQuery:s5];
    if (s305 && [s305 doubleValue] != 0.0) {
        [aa addObject:s305];
    }
    
    NSString *s306 = [db stringForQuery:s6];
    if (s306 && [s306 doubleValue] != 0.0) {
        [aa addObject:s306];
    }
    
    NSString *s307 = [db stringForQuery:s7];
    if (s307 && [s307 doubleValue] != 0.0) {
        [aa addObject:s307];
    }

    [DatabaseOperation closeDataBase:db];
    
    if (aa.count) {
        [aa addObject:@"Custom Amount"];  //如果有设置，那么就把custom加上去
    }
    else {
        return nil;
    }
    
    return aa;
}

+ (NSString *)getStoreSettingValue:(int)value
{
    FMDatabase *db = [DatabaseOperation openDataBase];
    NSString *ss3 = [NSString stringWithFormat:@"SELECT SettingValue FROM StoreSetting where SettingEnum = %d",value];
    NSString *aa = [db stringForQuery:ss3];
    [DatabaseOperation closeDataBase:db];
    return aa;
}

+ (NSString *)getItemReMakeCount:(NSString *)value DB:(FMDatabase *)db
{
    NSString *ss3 = [NSString stringWithFormat:@"SELECT ReMakeCount FROM OrderDetail where GlobalID = '%@'",value];
    NSString *aa = [db stringForQuery:ss3];
    return aa;
}

+ (NSString *)getItemLineVoided:(NSString *)value DB:(FMDatabase *)db
{
    NSString *ss3 = [NSString stringWithFormat:@"SELECT LineVoided FROM OrderDetail where GlobalID = '%@'",value];
    NSString *aa = [db stringForQuery:ss3]; 
    return aa;
}

+ (void)Update_StoreSettingValue:(NSString *)v withEnum:(int)num
{
    FMDatabase *db = [DatabaseOperation openDataBase];
    NSString *ss = [NSString stringWithFormat:@"UPDATE StoreSetting SET SettingValue = '%@' WHERE SettingEnum = %d",v,num];
    [db executeUpdate:ss];
    [DatabaseOperation closeDataBase:db];
}



+ (BOOL)deleteSecurityRoleID:(int)srid DB:(FMDatabase *)db
{
    BOOL success = [db executeUpdate:
                    [NSString stringWithFormat:@"DELETE FROM SecurityRole where SecurityRoleID = %d",srid]];
    return success;
}

//#pragma mark -
//#pragma mark SecurityRole Methods
//+ (BOOL)insertSecurityRole:(SecurityRole *)securityrole DB:(FMDatabase *)db
//{
//    //BOOL success =  [db executeUpdate:@"INSERT INTO customers (firstname,lastname) VALUES (?,?);",customer.firstName,customer.lastName, nil];
//    
//    BOOL success =  [db executeUpdate:@"INSERT INTO SecurityRole (GlobalID,RowTS,SecurityRoleName,SecurityRoleAltName,POSStartScreen,Memo,Hide) VALUES (?,?,?,?,?,?,?);",securityrole.GlobalID,securityrole.RowTS,securityrole.SecurityRoleName,securityrole.SecurityRoleAltName,securityrole.POSStartScreen,securityrole.Memo,securityrole.Hide,nil];
//    
//    return success;
//}
//
//+ (BOOL)updateSecurityRole:(SecurityRole *)securityrole DB:(FMDatabase *)db
//{
//    //BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE customers SET firstname = '%@', lastname = '%@' where id = %d",customer.firstName,customer.lastName,customer.customerId]];
//    
//    return YES;
//}
//
//+ (BOOL)deleteSecurityRole:(int)srid DB:(FMDatabase *)db
//{
//    return YES;
//}





#pragma mark -
#pragma mark check Security
+ (int)check_rightWithEmployeeID:(int)eid withSecurityObjectName:(NSString *)sname
{
    FMDatabase *db = [DatabaseOperation openDataBase];
    NSString *ss1 = [NSString stringWithFormat:@"SELECT SecurityRoleID FROM SecurityUserAccount where EmployeeID = %d",eid];
    int srid = [db intForQuery:ss1];  //SecurityRoleID
    
    NSString *ss2 = [NSString stringWithFormat:@"SELECT SecurityObjectID FROM SecurityObject where SecurityObjectName = '%@'",sname];
    int soid = [db intForQuery:ss2];  //SecurityObjectID
    
    NSString *ss3 = [NSString stringWithFormat:@"SELECT GrantAccess FROM SecurityRoleObject where SecurityRoleID = %d and SecurityObjectID = %d",srid,soid];
    int x = [db intForQuery:ss3];
    
    [DatabaseOperation closeDataBase:db];
    return x;   //1 or 0
}





#pragma  mark --- unity
+ (NSArray *)getPropertyAndType_SQLite:(Class)classname //按sqlite的类型返回
{
    NSString *p_type;
    u_int count;
    objc_property_t *p = class_copyPropertyList(classname, &count);
    NSMutableArray *pArrayName = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *pArrayType = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(p[i]);          //name
        const char *propertyType = property_getAttributes(p[i]);    //T@"NSString",&,N,Vname
        
        //--fix bug 检查第2个字母是否为@，是@说明是引用类型
        NSString *type_string = [NSString stringWithUTF8String:propertyType];
        NSString *type_flag = [type_string substringWithRange:NSMakeRange(1,1)];  //从第1个开始，长度为1
        //NSLog(@"第2个字符：%@",type_flag);   //@/i/f/d/c
        
        if ([type_flag isEqualToString:@"@"]) {
            //引用类型,按双引号截取,第2部分即为类型
            //NSArray *ptemp = [type_string componentsSeparatedByString:@"\""];   //按双引号截取\"
            //p_type = [ptemp objectAtIndex:1];                                   //截取后第2部分
            
            p_type = @"TEXT";   //引用类型都是text [取消 NSDate，用 double]
        }
        else if([type_flag isEqualToString:@"i"]) {
            //int
            p_type = @"INTEGER";
        }
        else if([type_flag isEqualToString:@"f"]) {
            //float
            p_type = @"REAL";
        }
        else if([type_flag isEqualToString:@"d"]) {
            //double
            p_type = @"REAL";
        }
        else if([type_flag isEqualToString:@"c"]) {
            //bool
            p_type = @"INTEGER";
        }
        else {
            p_type = @"int";
        }
        
        [pArrayName addObject:[NSString stringWithUTF8String:propertyName]];  //level
        [pArrayType addObject:p_type];                                        //Ti,N,Vlevel
    }
    
    free(p);
    
    NSArray *pArray = [NSArray arrayWithObjects:pArrayName,pArrayType,nil];
    return pArray;
}

#pragma mark - OC type
+ (NSArray *)getPropertyAndType_OC:(Class)classname      //按oc的类型返回
{
    NSString *p_type;
    u_int count;
    objc_property_t *p = class_copyPropertyList(classname, &count);
    NSMutableArray *pArrayName = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *pArrayType = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(p[i]);          //name
        const char *propertyType = property_getAttributes(p[i]);    //T@"NSString",&,N,Vname
        
        /*
         //属性有带*号的就没问题，不带*号的，比如有int型的属性就出错
         NSString *stemp = [NSString stringWithUTF8String:propertyType];
         NSArray *ptemp = [stemp componentsSeparatedByString:@"\""]; //按双引号截取\"
         
         [pArrayName addObject:[NSString stringWithUTF8String:propertyName]];
         [pArrayType addObject:[ptemp objectAtIndex:1]];             //截取后第2部分
         */
        
        //--fix bug 检查第2个字母是否为@，有@说明是引用类型
        NSString *type_string = [NSString stringWithUTF8String:propertyType];
        NSString *type_flag = [type_string substringWithRange:NSMakeRange(1,1)];  //从第1个开始，长度为1
        //NSLog(@"第2个字符：%@",type_flag);   //@/i/f/d/c
        
        
        if ([type_flag isEqualToString:@"@"]) {
            //引用类型,按双引号截取,第2部分即为类型
            NSArray *ptemp = [type_string componentsSeparatedByString:@"\""];     //按双引号截取\"
            p_type = [ptemp objectAtIndex:1];                                     //截取后第2部分
        }
        else if([type_flag isEqualToString:@"i"]) {
            //int
            p_type = @"int";
        }
        else if([type_flag isEqualToString:@"f"]) {
            //float
            p_type = @"float";
        }
        else if([type_flag isEqualToString:@"d"]) {
            //double
            p_type = @"double";
        }
        else if([type_flag isEqualToString:@"c"]) {
            //bool
            p_type = @"BOOL";
        }
        else {
            p_type = @"int";
        }
        
        [pArrayName addObject:[NSString stringWithUTF8String:propertyName]];  //level
        [pArrayType addObject:p_type];                                        //Ti,N,Vlevel
    }
    
    free(p);
    
    NSArray *pArray = [NSArray arrayWithObjects:pArrayName,pArrayType,nil];
    return pArray;
}

+ (NSString *)getSqliteTableStr:(Class)classname
{
    NSString *type=nil;
    NSString *rtrnStr =@"";
    u_int count;
    objc_property_t *p = class_copyPropertyList(classname, &count);
    
    for (int i = 0; i < count; i++) {
        if (!i) {
            continue;
        }
        
        const char *propertyName = property_getName(p[i]);
        const char *propertyType = property_getAttributes(p[i]);
        NSString *tstring = [NSString stringWithUTF8String:propertyType];
        NSString *tindex = [tstring substringWithRange:NSMakeRange(1,1)];
        if ([tindex isEqualToString:@"@"]) {
            type = @"TEXT";
        }
        else if ([tindex isEqualToString:@"i"]) {
            type = @"INTEGER";
        }
        else if ([tindex isEqualToString:@"f"]) {
            type = @"REAL";
        }
        else if ([tindex isEqualToString:@"d"]) {
            type = @"REAL";
        }
        else if ([tindex isEqualToString:@"c"]) {
            type = @"INTEGER";
        }
        NSString *name =(NSString*)[NSString stringWithUTF8String:propertyName];
        rtrnStr =[rtrnStr stringByAppendingFormat:@",%@ %@",name,type];
    }
    free(p);
    return rtrnStr;
}

@end





