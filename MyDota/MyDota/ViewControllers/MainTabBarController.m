//
//  MainTabBarController.m
//  MyDota
//
//  Created by Xiang on 15/8/5.
//  Copyright (c) 2015年 iGG. All rights reserved.
//

#import "MainTabBarController.h"
#import "MyDefines.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAppearanceUI];
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    
    tabBarItem0.selectedImage = [[UIImage imageNamed:@"home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.image = [[UIImage imageNamed:@"home_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem0 setTitle:@"首页"];
    tabBarItem0.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    tabBarItem0.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"profile_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem1 setTitle:@"我的"];
    tabBarItem1.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    tabBarItem1.titlePositionAdjustment = UIOffsetMake(0, -2);
}

-(void)setAppearanceUI{
    [[UITabBar appearance] setTintColor:Nav_Color];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end