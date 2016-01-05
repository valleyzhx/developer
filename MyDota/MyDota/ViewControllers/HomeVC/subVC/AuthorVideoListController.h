//
//  AuthorVideoListController.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListBaseController.h"
#import "UserModel.h"
#import "VideoModel.h"

@interface AuthorVideoListController : VideoListBaseController
@property(nonatomic,assign) BOOL isFromVideo;
-(id)initWithUser:(UserModel*)user;
-(id)initWithUser:(UserModel*)user selectCallback:(void(^)(VideoModel*))block;
@end
