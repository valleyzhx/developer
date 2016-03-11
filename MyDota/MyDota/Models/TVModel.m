//
//  TVModel.m
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "TVModel.h"

@implementation TVModel{
    NSString *_modelID;

}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [keyPaths addEntriesFromDictionary:@{
                                         @"modelID": @"id",
                                         }];
    
    return keyPaths;
}

#pragma mark MTLModelFMDBDelegate
-(void)setModelID:(NSString *)modelID{
    _modelID = modelID;
}
-(NSString *)modelID{
    return _modelID;
}


@end
