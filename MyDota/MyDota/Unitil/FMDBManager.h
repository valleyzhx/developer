//
//  FMDBManager.h
//  MyDota
//
//  Created by Xiang on 15/10/26.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLHALResource.h"
#import "MTModelFMDBDelegate.h"



@interface FMDBManager : NSObject

+(id)shareManager;

-(NSArray*)queryTable:(Class)modelClass QueryString:(NSString *)sql;

-(BOOL)saveDataWithModel:(MTLModel<MTModelFMDBDelegate>*)model;
-(BOOL)saveDataWithModelArray:(NSArray<MTLModel<MTModelFMDBDelegate>*>*)modelList;

-(BOOL)deleteDataWithModel:(MTLModel<MTModelFMDBDelegate>*)model;
-(BOOL)deleteDataWithModelArray:(NSArray<MTLModel<MTModelFMDBDelegate>*>*)modelList;

-(BOOL)hasTheModel:(MTLModel<MTModelFMDBDelegate>*)model;

@end
