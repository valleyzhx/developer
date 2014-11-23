//
//  HomeViewController.m
//  MyDota
//
//  Created by Simplan on 14-4-30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HomeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "VideoViewController.h"
#import "MyLoadingView.h"
#import "MJRefresh.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *dataArray;
    int currentCount;
    VideoViewController *videoVC;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(NSString*)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"%@",paths);
    return [NSString stringWithFormat:@"%@/rss.xml",[paths objectAtIndex:0]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:_listTable];
    currentCount = 0;
    [self loadXmlFile];
    [_listTable addFooterWithTarget:self action:@selector(refreshTheTable)];
    //[_listTable addHeaderWithTarget:self action:@selector(loadXmlFile)];
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
}

-(void)loadXmlFile
{
    NSString *s = [[NSBundle mainBundle]pathForResource:@"rss" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:s];
    MyXmlPraser *parser = [[MyXmlPraser alloc]initWithXMLData:data];
    parser.delegate = self;
    [parser startPrase];
    
}
-(void)refreshTheTable
{
    if (currentCount<dataArray.count) {
        currentCount = MIN((int)dataArray.count, currentCount+10);
    }else{
        [_listTable footerEndRefreshing];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_listTable reloadData];
        [_listTable footerEndRefreshing];
    });
}
#pragma  mark myxmlpraserdelegate
-(void)finishPraseWithResultArray:(NSArray *)array
{
    [[MyLoadingView shareLoadingView]stopWithFinished:^{
        dataArray = [[NSArray alloc]initWithArray:array];
        currentCount = MIN(15, (int)dataArray.count);
        [_listTable reloadData];
        [_listTable headerEndRefreshing];
    }];
    
}
#pragma mark tableviewdelegate And datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MyXmlData *data = dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",data.title,data.pubDate];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyXmlData *data = dataArray[indexPath.row];
    videoVC = [[VideoViewController alloc]initWithNibName:nil bundle:nil yukuPlayer:data.player];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
    nav.title = data.title;
    [self presentModalViewController:nav animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)dealloc
{
    dataArray = nil;
    videoVC = nil;
}

@end
