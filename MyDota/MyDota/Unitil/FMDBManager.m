//
//  FMDBManager.m
//  MyDota
//
//  Created by Xiang on 15/10/26.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDB.h"
#import "UserModel.h"
#import "VideoModel.h"
#import "objc/runtime.h"


@implementation FMDBManager{
    FMDatabaseQueue *_operation;
}



static FMDBManager *_shareManager;
+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[FMDBManager alloc]init];
    });
    return _shareManager;
}
-(instancetype)init{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *DOCPath = [paths objectAtIndex:0];
        NSString *fn = [DOCPath stringByAppendingPathComponent:@"data.sqlite"];
        _operation = [FMDatabaseQueue databaseQueueWithPath:fn];
        [_operation inDatabase:^(FMDatabase *db) {
            [self createTable:db];
        }];
    }
    return self;
}

-(void)createTable:(FMDatabase*)db{
    NSArray *arr = @[@"UserModel",@"VideoModel"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self createTableWithClassString:obj dataBase:db];
    }];
}

-(BOOL)createTableWithClassString:(NSString*)classStr dataBase:(FMDatabase*)db{
    NSString *tableName = classStr;
    //建表
    NSString *TableStr =[self getSqliteTableStr:NSClassFromString(classStr)];
    NSString *createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(modelID TEXT NOT NULL PRIMARY KEY %@)",tableName,TableStr];
    if ([db executeUpdate:createStr] == NO){
        return NO;
    }
    return YES;
}


- (NSArray *)getPropertyAndType_OC:(Class)classname      //按oc的类型返回
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

- (NSString *)getSqliteTableStr:(Class)classname
{
    NSString *type=nil;
    NSString *rtrnStr =@"";
    u_int count;
    objc_property_t *p = class_copyPropertyList(classname, &count);
    
    for (int i = 0; i < count; i++) {
        
        const char *propertyName = property_getName(p[i]);
        NSString *name =(NSString*)[NSString stringWithUTF8String:propertyName];
        if ([name isEqualToString:@"modelID"]) {
            continue;
        }
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
        
        rtrnStr =[rtrnStr stringByAppendingFormat:@",%@ %@",name,type];
    }
    free(p);
    return rtrnStr;
}





#pragma mark --- sql action 
-(BOOL)saveDataWithModel:(MTLModel<MTModelFMDBDelegate> *)model{
    
    __block BOOL success = YES;
    [_operation inDatabase:^(FMDatabase *db) {
        NSString *sql = [self getInserSqlWithModel:model];
        success = [db executeUpdate:sql];
        
    }];
    
    return success;
}

-(BOOL)saveDataWithModelArray:(NSArray<MTLModel<MTModelFMDBDelegate> *> *)modelList{
    [_operation inDatabase:^(FMDatabase *db) {
        for (MTLModel *model in modelList) {
            NSString *sql = [self getInserSqlWithModel:model];
            [db executeUpdate:sql];
        }
    }];
    return YES;
}



-(NSString*)getInserSqlWithModel:(MTLModel*)model{
    NSArray *a1 = [self getPropertyAndType_OC:[model class]];       //取得oc的类型
    NSString *tableName = NSStringFromClass([model class]);
    
    NSString *fn;// = [NSString stringWithFormat:@""];         //属性名称
    NSString *ft;// = [NSString stringWithFormat:@""];         //属性type
    NSString *field_name = @"";
    NSString *field_value = @"";
    
    NSArray *nameArr = a1[0];
    NSArray *typeArr = a1[1];
    for (int i = 0; i < nameArr.count; i++)  //从0开始
    {
        fn = nameArr[i];        //NSLog(@"name:%@",fn);
        ft = typeArr[i];        //NSLog(@"type:%@",ft);
        
        
        if ([ft isEqualToString:@"int"] || [ft isEqualToString:@"bool"] || [ft isEqualToString:@"BOOL"])
        {
            int aa = [[model valueForKey:fn] intValue];
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
            double bb = [[model valueForKey:fn] doubleValue];
            field_value = [field_value stringByAppendingFormat:@",%.6f",bb];
        }
        else if ([ft isEqualToString:@"NSString"])
        {
            NSString *fv = [model valueForKey:fn];     //NSLog(@"string: %@",fv);
            
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
    //生成sqlite
    NSString *insert_sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(%@)",tableName,field_name,field_value];
    return insert_sql;
}


-(BOOL)deleteDataWithModel:(MTLModel<MTModelFMDBDelegate> *)model{
    __block BOOL success = YES;
    [_operation inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(model.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where modelID = '%@'",tableName,model.modelID];
        success = [db executeUpdate:sql];
    }];
    return success;
}
-(BOOL)deleteDataWithModelArray:(NSArray<MTLModel<MTModelFMDBDelegate> *> *)modelList{
    
    [_operation inDatabase:^(FMDatabase *db) {
        for (MTLModel<MTModelFMDBDelegate> *model in modelList) {
            NSString *tableName = NSStringFromClass(model.class);
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where modelID = '%@'",tableName,model.modelID];
            [db executeUpdate:sql];
        }
    }];
    
    
    
    return YES;
}






-(BOOL)hasTheModel:(MTLModel<MTModelFMDBDelegate> *)model{
    NSString *tableName = NSStringFromClass(model.class);
    NSString *modelIDValue = [model valueForKey:@"modelID"];
    __block int count = 0;
    if (modelIDValue) {
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) %@ where modelID ='%@'",tableName,modelIDValue];
        [_operation inSavePoint:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *set = [db executeQuery:sql];
            if ([set next]) {
                count = [set intForColumnIndex:0];
            }
        }];
    }
    return count;
}


@end
