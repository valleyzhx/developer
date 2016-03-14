//
//  MTModel+GGRequest.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTModel+GGRequest.h"
#import "GGRequest.h"

@implementation MTLHALResource(GGRequest)
+(void)startRequestWithUrl:(NSString *)url complish:(void (^)(id))finished{
    [GGRequest requestWithUrl:url accepType:@"json" withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success:----- %@",operation.responseString);
        if (finished) {
            if ([NSJSONSerialization isValidJSONObject:responseObject]) {
                id objc = [self managerThereReponseObject:responseObject];
                finished(objc);
            }else{
                finished(nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (finished) {
            finished(nil);
        }
    }];
}


+(id)managerThereReponseObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      MTLHALResource *objc = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:responseObject error:nil];
        return objc;
    }else if ([responseObject isKindOfClass:[NSArray class]]){
        NSArray *objc = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:responseObject error:nil];
        return objc;
    }
    return nil;
}



@end



