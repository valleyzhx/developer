//
//  MyLoadingView.h
//  MyDota
//
//  Created by Simplan on 14/6/7.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLoadingView : UIView
+(id)shareLoadingView;
-(void)showLoadingIn:(UIView*)view;
-(void)stopWithFinished:(void (^)(void))finish;
@end
