//
//  MTLHALResource+SaveData.m
//  auto-jd
//
//  Created by lsx on 15/4/2.
//  Copyright (c) 2015年 lsx. All rights reserved.
//

#import "MTLHALResource+Helper.h"
#import "DatabaseOperation.h"

@implementation MTLHALResource (Helper)

- (BOOL)saveDataWithDB:(FMDatabase *)db{
    
    return [DatabaseOperation saveDataWithDB:db errorMessage:nil nsobject:self];

}

- (BOOL)deleteDataWithDB:(FMDatabase *)db   {
    @synchronized (self) {

    NSString *tablename = NSStringFromClass(self.class);
    
        BOOL success = [db executeUpdate:
                        [NSString stringWithFormat:@"DELETE FROM %@ where %@ID = %@",tablename,tablename,[self valueForKey:[NSString stringWithFormat:@"%@ID",tablename]]]];
        
        
        return success;
    }
}

+(BOOL)haveDataWithID:(NSString *)modelID{
    FMDatabase *dataDB = [DatabaseOperation openDataBase];
    NSString *classStr = NSStringFromClass(self.class);
    NSString *IDStr = [classStr stringByAppendingFormat:@"ID"];
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where %@ ='%@'",classStr,IDStr,modelID];
    
    int count = [dataDB intForQuery:sql];
    [DatabaseOperation closeDataBase:dataDB];
    return count;
}

@end
