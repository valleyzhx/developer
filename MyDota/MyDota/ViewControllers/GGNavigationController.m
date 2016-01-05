//
//  GGNavigationController.m
//  MyDota
//
//  Created by Xiang on 15/11/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGNavigationController.h"

@interface GGNavigationController ()

@end

@implementation GGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//- (UIViewController *)childViewControllerForStatusBarHidden
//{
//    return nil;
//}
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

@end
