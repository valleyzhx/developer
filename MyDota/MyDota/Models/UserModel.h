//
//  UserModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTLHALResource.h"

@interface UserModel : MTLHALResource

@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *userDescription;
@property (nonatomic,strong)NSString *link;

@property (nonatomic,strong)NSString *avatar;

@property (nonatomic,strong)NSString *avatar_large;

@property (nonatomic,strong)NSNumber *videos_count;

@property (nonatomic,strong)NSNumber *playlists_count;

@property (nonatomic,strong)NSNumber *favorites_count;

@property (nonatomic,strong)NSNumber *followers_count;
@property (nonatomic,strong)NSNumber *following_count;
@property (nonatomic,strong)NSNumber *statuses_count;
@property (nonatomic,strong)NSNumber *subscribe_count;
@property (nonatomic,strong)NSNumber *vv_count;
@property (nonatomic,strong)NSNumber *ytid;


/**
 *  Description
 *
 *  @param userIdOrUserName userId穿NSNumber类型
 *  @param finished
 */
+(void)getUserInfoBy:(id)userIdOrUserName complish:(void(^)(id))finished;

+(NSArray*)loadLocalGEOJsonData;

@end
