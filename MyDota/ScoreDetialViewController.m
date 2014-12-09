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
    
    UILabel *leb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    leb.backgroundColor = [UIColor clearColor];
    leb.font = [UIFont systemFontOfSize:13];
    leb.text = self.navigationController.title;
    self.navigationItem.titleView = leb;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelViewAction)];
    self.navigationItem.leftBarButtonItem = left;
    
    
    
    _myScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *3, [UIScreen mainScreen].bounds.size.height);
    TTTableViewController *ttTable = [[TTTableViewController alloc]initWithNibName:@"TTTableViewController" bundle:nil];
    
    ttTable.scoreDelegate = self;
    [_myScroll addSubview:ttTable.view];
    // Do any additional setup after loading the view from its nib.
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
