//
//  UrlManager.m
//  MyDota
//
//  Created by Xiang on 16/4/13.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "UrlManager.h"

@implementation UrlManager

+(NSString *)getHomeCateUrl{
    
    NSString *url = @"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10";

    return url;
}


@end
