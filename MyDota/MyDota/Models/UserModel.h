//
//  UserModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTLHALResource.h"
#import "MTModelFMDBDelegate.h"

@interface UserModel : MTLHALResource<MTModelFMDBDelegate>

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *userDescription;
@property (nonatomic,strong)NSString *link;

@property (nonatomic,strong)NSString *avatar;

@property (nonatomic,strong)NSString *avatar_large;

@property (nonatomic,assign)int videos_count;

@property (nonatomic,assign)int playlists_count;

@property (nonatomic,assign)int favorites_count;

@property (nonatomic,assign)int followers_count;
@property (nonatomic,assign)int following_count;
@property (nonatomic,assign)int statuses_count;
@property (nonatomic,assign)int subscribe_count;
@property (nonatomic,assign)int vv_count;
@property (nonatomic,assign)int ytid;

/**
 *  Description
 *
 *  @param userIdOrUserName userId穿NSNumber类型
 *  @param finished
 */
+(void)getUserInfoBy:(id)userIdOrUserName complish:(void(^)(id))finished;

+(NSArray*)loadLocalGEOJsonData;

@end
