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
    TTTableViewController *ttTable;
    MJTableViewController *mjTable;
    JJCTableViewController *jjcTable;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(ScoreData*)scoreData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myData = scoreData;
    }
    return self;
}
-(void)dealloc{
    myData = nil;
    ttTable = nil;
    mjTable = nil;
    jjcTable = nil;
}
- (void)viewDidLoad {
    if (iOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    [super viewDidLoad];
    
    UILabel *leb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    leb.backgroundColor = [UIColor clearColor];
    leb.font = [UIFont systemFontOfSize:13];
    leb.text = self.navigationController.title;
    self.navigationItem.titleView = leb;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelViewAction)];
    self.navigationItem.leftBarButtonItem = left;
    
    _myScroll.frame = self.view.bounds;
    _myScroll.contentSize = CGSizeMake(screenWidth *3, _myScroll.bounds.size.height);
    
    ttTable = [[TTTableViewController alloc]initWithNibName:@"TTTableViewController" bundle:nil];
    ttTable.view.frame = CGRectMake(0, 0, screenWidth , screenHeight-64);
    ttTable.scoreInfoDic = self.ttScoreInfoDic;
    ttTable.totalDic = myData.ttInfos;
    
    ttTable.scoreDelegate = self;
    ttTable.userId = self.userId;
    [_myScroll addSubview:ttTable.view];
    
    mjTable = [[MJTableViewController alloc]initWithNibName:@"MJTableViewController" bundle:nil];
    mjTable.view.frame = CGRectMake(0, screenWidth, screenWidth , screenHeight-64);
    mjTable.scoreDelegate = self;
    [_myScroll addSubview:mjTable.view];
    
    jjcTable = [[JJCTableViewController alloc]initWithNibName:@"JJCTableViewController" bundle:nil];
    mjTable.view.frame = CGRectMake(0, screenWidth*2, screenWidth , screenHeight-64);
    mjTable.scoreDelegate = self;
    [_myScroll addSubview:mjTable.view];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancelViewAction{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)detailScrollEnabled:(BOOL)isEnable{
    _myScroll.scrollEnabled = isEnable;
}

@end
