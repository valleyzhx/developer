//
//  BaseViewController+GGRequest.m
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController+GGRequest.h"
#import "GGRequest.h"

@implementation BaseViewController (GGRequest)
-(void)loadDataWithUrl:(NSString*)url requestTag:(int)tag{
    [GGRequest requestWithUrl:url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self finishLoadWithTag:tag data:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self finishLoadWithTag:tag data:nil error:error];
    }];
}
-(void)finishLoadWithTag:(int)tag data:(id)responseObject error:(NSError *)error{
    
}
@end
