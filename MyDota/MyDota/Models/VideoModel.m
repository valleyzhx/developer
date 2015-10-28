//
//  VideoModel.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel{
    NSString *_modelID;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"modelID": @"id"
                                         }];
    
    return keyPaths;
}





-(void)setModelID:(NSString *)modelID{
    _modelID = modelID;
}
-(NSString *)modelID{
    return _modelID;
}


@end
