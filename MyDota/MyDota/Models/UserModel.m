//
//  UserModel.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "UserModel.h"
#import "MTModel+GGRequest.h"
#import "GGRequest.h"

@interface UserModel ()
@property (nonatomic,strong)NSString *backgroundImg;
@end

@implementation UserModel

+(void)getUserInfoBy:(id)userIdOrUserName complish:(void(^)(id))finished{
    NSString *url = @"https://openapi.youku.com/v2/users/show.json?client_id=%20e2306ead120d2e34&";
    if ([userIdOrUserName isKindOfClass:[NSNumber class]]) {
        url = [url stringByAppendingFormat:@"user_id=%@",userIdOrUserName];
    }else{
        url = [url stringByAppendingFormat:@"user_name=%@",userIdOrUserName];
    }
    [self startRequestWithUrl:url complish:finished];
}

+(NSArray *)loadLocalGEOJsonData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"AuthourData" ofType:@"geojson"];
    NSString *jsonStr = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *jsonArr = jsonStr.jsonObject[@"users"];
    if (jsonArr.count) {
        return [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:jsonArr error:nil];
    }
    return nil;
}



+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [keyPaths addEntriesFromDictionary:@{
                                         @"userId": @"id",
                                         @"userDescription":@"description"
                                         }];
    
    return keyPaths;
}

@end

