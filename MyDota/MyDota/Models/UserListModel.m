//
//  UserListModel.m
//  MyDota
//
//  Created by Xiang on 15/11/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "UserListModel.h"
#import "MTModel+GGRequest.h"

@implementation UserListModel

+(void)getUserListBy:(NSString*)url complish:(void(^)(id))finished{
    [self startRequestWithUrl:url complish:finished];
}

+ (NSValueTransformer *)usersJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UserModel class]];
}

@end
