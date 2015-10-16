//
//  GGRequest.h
//  MyDota
//
//  Created by Xiang on 15/10/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GGRequestManager.h"


@interface GGRequest : NSObject

+(NSString*)dotaJSPathWithType:(GGRequestType)type;

+(void)downLoadBanerJS;
+(void)requestWithUrl:(NSString*)url withSuccess:(void (^)(AFHTTPRequestOperation *operation,id
                                                           responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))failure;

@end
