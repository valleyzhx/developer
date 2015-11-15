//
//  FavoVideoListController.m
//  MyDota
//
//  Created by Xiang on 15/10/29.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "FavoVideoListController.h"
#import "FMDBManager.h"
#import "MyDefines.h"

@interface FavoVideoListController ()

@end

@implementation FavoVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    NSArray *arr = [[FMDBManager shareManager]queryTable:[VideoModel class] QueryString:@"select * from VideoModel;"];
    self.listArr = [NSMutableArray arrayWithArray:arr];
    if (arr.count == 0) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        lab.textColor = TextDarkColor;
        lab.font = [UIFont systemFontOfSize:16];
        lab.text = @"您还没有收藏过视频!";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [self.view addSubview:lab];
    }
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
