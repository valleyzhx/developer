//
//  BaseViewController+NaviView.h
//  MyDota
//
//  Created by Xiang on 15/10/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGNavigationBar.h"
#import "BaseViewController.h"

@interface BaseViewController (NaviView)

-(GGNavigationBar*)setUpNaviViewWithType:(GGNavigationBarType)type;

@end

