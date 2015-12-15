//
//  UserListModel.h
//  MyDota
//
//  Created by Xiang on 15/11/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Mantle-HAL/Mantle-HAL.h>
#import "UserModel.h"

@interface UserListModel : MTLHALResource

@property (nonatomic,strong) NSArray<UserModel*> *users;
@property (nonatomic,assign) int total;

+(void)getUserListBy:(NSString*)url complish:(void(^)(id))finished;

@end
