//
//  BaseViewController+NaviView.m
//  MyDota
//
//  Created by Xiang on 15/10/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController+NaviView.h"
#import "MyDefines.h"

@implementation BaseViewController (NaviView)

-(GGNavigationBar *)setUpNaviViewWithType:(GGNavigationBarType)type{
    if (naviBar) {
        [naviBar removeFromSuperview];
        naviBar = nil;
    }
    
    GGNavigationBar *view = [[GGNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.title = self.title;
    view.backgroundView.backgroundColor = Nav_Color;
    view.backgroundView.alpha = 1;
    
    if (type == GGNavigationBarTypeNormal) {
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [backBtn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickedBackAction:) forControlEvents:UIControlEventTouchUpInside];
        view.leftView = backBtn;
    }
    
    [self.view addSubview:view];
    return view;
}

-(void)clickedBackAction:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end