//
//  VideoViewController.h
//  MyDota
//
//  Created by Xiang on 15/10/17.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoModel.h"

@interface VideoViewController : BaseViewController
@property (nonatomic,assign)BOOL isFromAuthorList;
-(id)initWithVideoModel:(VideoModel*)model;



@end
