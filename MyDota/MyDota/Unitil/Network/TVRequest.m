//
//  TVRequest.m
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "TVRequest.h"
#import <AFNetworking.h>

@implementation TVRequest
+(void)loadTVList:(NSString*)url done:(void(^)(id result))success{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *serial = [AFHTTPRequestSerializer serializer];
    [serial setValue:@"application/json, text/javascript, */*; q=0.01" forHTTPHeaderField:@"Accept"];
    [serial setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13D15 Safari/601.1\n" forHTTPHeaderField:@"User-Agent"];
    [serial setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [serial setValue:@"http://m.zhanqi.tv/games" forHTTPHeaderField:@"Referer"];
    manager.requestSerializer = serial;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"--- %@",operation.responseString);
        if (responseObject&&success) {
            NSDictionary *dic = [operation.responseString jsonObject];
            success(dic);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];

}

@end
