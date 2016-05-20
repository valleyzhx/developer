//
//  GGRequest.m
//  MyDota
//
//  Created by Xiang on 15/10/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGRequest.h"
#import "AFNetworking/UIKit+AFNetworking/UIWebView+AFNetworking.h"

@implementation GGRequest

+(void)requestWithUrl:(NSString *)url accepType:(NSString *)type withSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([type isEqualToString:@"text"]||[type isEqualToString:@"html"]) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}



+(void)requestM3U8WithUrl:(NSString *)url withSuccess:(void (^)(NSString *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

+(void)requestHtmlWithUrl:(NSString *)url withSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
}

+(void)downLoadBanerJS{//
    
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURL *url1 = [NSURL URLWithString:@"http://dota.178.com/public/atcount/dota_v.js"];
    NSURL *url2 = [NSURL URLWithString:@"http://dota2.178.com/public/atcount/dota2_v.js"];

    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url1]];
    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url2]];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *doubi = responseObject;
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        [self saveTheJSString:shabi withDotaString:@"f_dota_v("];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [[GGRequestManager sharedManager]sendMessagewithType:GGRequestTypeError response:nil];
    }];
    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *doubi = responseObject;
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        
        [self saveTheJSString:shabi withDotaString:@"f_dota2_v("];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [[GGRequestManager sharedManager]sendMessagewithType:GGRequestTypeError response:nil];
    }];

    [manager setCompletionGroup:dispatch_group_create()];
    [manager.operationQueue addOperations:@[operation1,operation2] waitUntilFinished:NO];
    
}

+(void)saveTheJSString:(NSString*)string withDotaString:(NSString*)dotaStr{
    NSString *result = [string stringByReplacingOccurrencesOfString:dotaStr withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@");" withString:@""];
    GGRequestType type = [dotaStr containsString:@"dota2"]?GGRequestTypeDota2JSFinished:GGRequestTypeDotaJSFinished;
    if (result.length) {
        NSString *path = [self dotaJSPathWithType:type];
        [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    [[GGRequestManager sharedManager]sendMessagewithType:type response:result.jsonObject];
}

+(NSString*)dotaJSPathWithType:(GGRequestType)type{
    NSString *file;
    if (type == GGRequestTypeDota2JSFinished) {
        file = @"dota2";
    }else{
        file = @"dota";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr = [NSString stringWithFormat:@"%@/%@.txt",[paths objectAtIndex:0],file];
    
    return pathStr;
}

@end
