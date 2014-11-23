//
//  ScoreDetialViewController.m
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ScoreDetialViewController.h"
#import "TTTableViewController.h"
#import "MJTableViewController.h"
#import "JJCTableViewController.h"

@interface ScoreDetialViewController ()

@end

@implementation ScoreDetialViewController
{
    ScoreData *myData;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(ScoreData*)scoreData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myData = scoreData;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _myScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *3, [UIScreen mainScreen].bounds.size.height);
    TTTableViewController *ttTable = [[TTTableViewController alloc]initWithNibName:@"TTTableViewController" bundle:nil];
    [_myScroll addSubview:ttTable.view];
    // Do any additional setup after loading the view from its nib.
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
