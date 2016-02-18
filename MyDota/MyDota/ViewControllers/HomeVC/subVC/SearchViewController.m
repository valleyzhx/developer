//
//  SearchViewController.m
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "SearchViewController.h"
#import "MyDefines.h"
#import "VideoListModel.h"



@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController{
    UISearchBar *_searchBar;
    UIButton *_backGroundBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _naviBar.backgroundView.alpha = 1;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 22, (SCREEN_WIDTH - 50) , 40)] ;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setTranslucent:YES];
    
    [_naviBar addSubview:_searchBar];
    _searchBar.delegate = self;// 设置代理
    _searchBar.text = @"dota";
    _backGroundBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
    _backGroundBtn.backgroundColor = [UIColor blackColor];
    _backGroundBtn.alpha = 0;
    [_backGroundBtn addTarget:self action:@selector(clickedTheBackGround:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_backGroundBtn belowSubview:_naviBar];
    
    
    
   
    [_searchBar becomeFirstResponder];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}



-(void)loadMoreData{
    [self loadVideoList:currentPage+1];
}



-(void)loadVideoList:(int)page{
    NSString *text = _searchBar.text;
    NSString *searchUrl = [NSString stringWithFormat:@"https://openapi.youku.com/v2/searches/video/by_keyword.json?client_id=e2306ead120d2e34&keyword=%@&category=游戏&page=%d",text,page];
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [VideoListModel getVideoListBy:searchUrl complish:^(id objc) {
        VideoListModel *model = objc;
        if (model.videos) {
            [self.listArr addObjectsFromArray:model.videos];
            total = model.total;
            [self.tableView reloadData];
        }
        if (total==self.listArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            if (currentPage == 1) {
                [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
            }
            currentPage++;
        }
        [self clickedTheBackGround:nil];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)clickedTheBackGround:(UIButton*)btn{
    [_searchBar resignFirstResponder];
    [self animationWithBackgroundBtn:YES];
}


#pragma mark ---- UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self animationWithBackgroundBtn:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *text = searchBar.text;
    
    if ([text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.listArr removeAllObjects];
    currentPage = 1;
    [self loadVideoList:1];
    //[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma BackgroundBtn Animate
-(void)animationWithBackgroundBtn:(BOOL)shouldHidden{
    float alpha = shouldHidden?0:0.5;
    [UIView animateWithDuration:0.6 animations:^{
        _backGroundBtn.alpha = alpha;
    }];
}









-(void)dealloc{
    [_searchBar removeFromSuperview];
    _searchBar = nil;
    _backGroundBtn = nil;
}

@end
