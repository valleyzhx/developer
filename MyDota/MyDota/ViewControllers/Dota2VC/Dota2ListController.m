//
//  Dota2ListController.m
//  MyDota
//
//  Created by Xiang on 16/11/29.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "Dota2ListController.h"
#import "BaseViewController+NaviView.h"
#import "SearchViewController.h"
@interface Dota2ListController ()

@end

@implementation Dota2ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeCustom];
    _naviBar.backgroundView.alpha = 1;
    [self setSearchButton];
    self.title = @"DotA2";
}

-(NSString *)getKeyWord{
    return @"DotA2";
}




#pragma mark Search Action
-(void)searchAction:(UIButton*)btn{
    SearchViewController *serchVC = [[SearchViewController alloc]init];
    serchVC.searchKey = @"DotA2";
    [self pushWithoutTabbar:serchVC];
}

#pragma mark -- pushAction

-(void)pushWithoutTabbar:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
