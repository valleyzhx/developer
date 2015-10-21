//
//  AuthorVideoListController.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface AuthorVideoListController : BaseViewController
@property(nonatomic,assign) BOOL isFromVideo;
-(id)initWithUser:(UserModel*)user;
-(id)initWithUser:(UserModel*)user selectCallback:(void(^)(NSDictionary*))block;
@end
