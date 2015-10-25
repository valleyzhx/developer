//
//  MTLHALResource+SaveData.h
//  auto-jd
//
//  Created by lsx on 15/4/2.
//  Copyright (c) 2015年 lsx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLHALResource.h"
#import "FMDatabase.h"

@interface MTLHALResource (Helper)

- (BOOL)saveDataWithDB:(FMDatabase *)db;

- (BOOL)deleteDataWithDB:(FMDatabase *)db;

+ (BOOL)haveDataWithID:(NSString*)modelID;

@end
