//
//  TVListModel.m
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "TVListModel.h"
#import "MTModel+GGRequest.h"
#import "TVRequest.h"

@implementation TVListModel

+(void)loadTVList:(NSString *)url complish:(void (^)(id))finished{
    [TVRequest loadTVList:url done:^(id result) {
       NSObject *objc = [self managerThereReponseObject:result[@"data"]];
        finished(objc);
    }];
    
}



+ (NSValueTransformer *)roomsJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TVModel class]];
}


@end
