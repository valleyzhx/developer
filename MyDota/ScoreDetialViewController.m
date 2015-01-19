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


@interface ScoreDetialViewController ()

@end

@implementation ScoreDetialViewController
{
    ScoreData *myData;
    TTTableViewController *ttTable;
    MJTableViewController *mjTable;
    TTTableViewController *jjcTable;
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
    
    if (myData.ttInfos) {
        ttTable = [[TTTableViewController alloc]initWithNibName:@"TTTableViewController" bundle:nil];
        ttTable.view.frame = CGRectMake(0, 0, screenWidth , screenHeight-64);
        ttTable.scoreInfoDic = self.ttScoreInfoDic;
        ttTable.totalDic = myData.ttInfos;
        [_myScroll addSubview:ttTable.view];
    }else{
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (screenHeight-64)/2-20, screenWidth, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"查无天梯信息";
        [_myScroll addSubview:lab];
    }
    
    if (myData.mjheroInfos.count) {
        mjTable = [[MJTableViewController alloc]initWithNibName:@"MJTableViewController" bundle:nil];
        mjTable.view.frame = CGRectMake(screenWidth, 0 , screenWidth , screenHeight-64);
        mjTable.data = myData;
        [_myScroll addSubview:mjTable.view];
    }else{
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth, (screenHeight-64)/2-20, screenWidth, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"查无名将信息";
        [_myScroll addSubview:lab];
    }
    
    
    if (myData.jjcInfos) {
        jjcTable = [[TTTableViewController alloc]initWithNibName:@"TTTableViewController" bundle:nil];
        jjcTable.view.frame = CGRectMake(screenWidth*2,0, screenWidth , screenHeight-64);
        jjcTable.scoreInfoDic = self.jjcScoreInfoDic;
        jjcTable.totalDic = myData.jjcInfos;
        [_myScroll addSubview:jjcTable.view];
    }else{
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth*2, (screenHeight-64)/2-20, screenWidth, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"查无竞技场信息";
        [_myScroll addSubview:lab];
    }
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelViewAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)detailScrollEnabled:(BOOL)isEnable{
    _myScroll.scrollEnabled = isEnable;
}

@end
