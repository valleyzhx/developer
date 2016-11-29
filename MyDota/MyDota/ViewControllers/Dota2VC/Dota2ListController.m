//
//  Dota2ListController.m
//  MyDota
//
//  Created by Xiang on 16/11/29.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "Dota2ListController.h"
#import "BaseViewController+NaviView.h"

@interface Dota2ListController ()

@end

@implementation Dota2ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeCustom];
    _naviBar.backgroundView.alpha = 1;

    self.title = @"DotA2";

}

-(NSString *)getKeyWord{
    return @"dota2";
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
