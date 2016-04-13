//
//  UserManager.m
//  MyDota
//
//  Created by Xiang on 16/4/13.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "UserManager.h"

#define kPreferType @"preferType"

@implementation UserManager

+(NSString *)preferedVideoType{
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:kPreferType];
    if (value) {
        return value;
    }
    return @"mp4";
}

+(void)setPreferedVideoType:(NSString *)type{
    if (type) {
        [[NSUserDefaults standardUserDefaults]setObject:type forKey:kPreferType];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
