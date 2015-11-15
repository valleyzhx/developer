//
//  VideoListBaseController.h
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoModel.h"
#import "MBProgressHUD.h"

@interface VideoListBaseController : BaseViewController
@property (nonatomic,strong) NSMutableArray <VideoModel *>*listArr;


@end
