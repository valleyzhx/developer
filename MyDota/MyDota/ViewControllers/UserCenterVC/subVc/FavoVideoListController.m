//
//  FavoVideoListController.m
//  MyDota
//
//  Created by Xiang on 15/10/29.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "FavoVideoListController.h"
#import "FMDBManager.h"

@interface FavoVideoListController ()

@end

@implementation FavoVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    NSArray *arr = [[FMDBManager shareManager]queryTable:[VideoModel class] QueryString:@"select * from VideoModel;"];
    self.listArr = [NSMutableArray arrayWithArray:arr];
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
