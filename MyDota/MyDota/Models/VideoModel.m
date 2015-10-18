//
//  VideoModel.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"videoId": @"id"
                                         }];
    
    return keyPaths;
}

@end
