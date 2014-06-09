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


@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *dataArray;
    int currentCount;
    BOOL _reloading;
    VideoViewController *videoVC;
    LoadMoreTableFooterView *_loadMoreFooterView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:_listTable];
    currentCount = 0;
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:@"http://dota.uuu9.com/rss.xml"]];
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    request.cachePolicy = ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy;
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setDidFailSelector:@selector(failMethod:)];
    [request setDidFinishSelector:@selector(finishMethod:)];
    [request setDelegate:self];
    [request startAsynchronous];
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
    if (_loadMoreFooterView == nil) {
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, _listTable.contentSize.height, _listTable.frame.size.width, _listTable.bounds.size.height)];
		view.delegate = self;
		[_listTable addSubview:view];
		_loadMoreFooterView = view;
	}

    
}
-(void)failMethod:(ASIHTTPRequest*)request
{
    
}
-(void)finishMethod:(ASIHTTPRequest*)request
{
    NSData *data = request.responseData;
    MyXmlPraser *parser = [[MyXmlPraser alloc]initWithXMLData:data];
    parser.delegate = self;
    [parser startPrase];
}
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:_listTable];
}
#pragma  mark myxmlpraserdelegate
-(void)finishPraseWithResultArray:(NSArray *)array
{
    [[MyLoadingView shareLoadingView]stopWithFinished:^{
        dataArray = [[NSArray alloc]initWithArray:array];
        currentCount = MIN(15, dataArray.count);
        [_listTable reloadData];
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
    videoVC = [[VideoViewController alloc]initWithNibName:nil bundle:nil linkUrlString:data.urlStr];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
    nav.title = data.title;
    [self presentModalViewController:nav animated:YES];
    
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	
}
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view
{
    [self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return _reloading;
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
    _loadMoreFooterView = nil;
}

@end
