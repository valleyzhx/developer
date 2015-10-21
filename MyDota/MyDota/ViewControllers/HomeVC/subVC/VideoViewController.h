//
//  VideoViewController.h
//  MyDota
//
//  Created by Xiang on 15/10/17.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoViewController : BaseViewController
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,assign)BOOL isFromAuthorList;
-(id)initWithVideoDiction:(NSDictionary*)dic;



@end
