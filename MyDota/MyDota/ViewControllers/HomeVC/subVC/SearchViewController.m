//
//  SearchViewController.m
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "SearchViewController.h"
#import "BaseViewController+GGRequest.h"
#import "MyDefines.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController{
    UISearchBar *_searchBar;
    UIButton *_backGroundBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    naviBar.backgroundView.alpha = 1;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 22, (SCREEN_WIDTH - 50) , 40)] ;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setTranslucent:YES];
    
    [naviBar addSubview:_searchBar];
    _searchBar.delegate = self;// 设置代理
    _backGroundBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
    _backGroundBtn.backgroundColor = [UIColor blackColor];
    _backGroundBtn.alpha = 0;
    [_backGroundBtn addTarget:self action:@selector(clickedTheBackGround:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_backGroundBtn belowSubview:naviBar];
    [_searchBar becomeFirstResponder];
//    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadVideoList:currentPage+1];
//    }];
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
    NSString *searchUrl = [NSString stringWithFormat:@"https://openapi.youku.com/v2/searches/video/by_keyword.json?client_id=e2306ead120d2e34&keyword=%@",text];
    [self loadDataWithUrl:searchUrl requestTag:0];
    [self animationWithBackgroundBtn:YES];
}

#pragma BackgroundBtn Animate
-(void)animationWithBackgroundBtn:(BOOL)shouldHidden{
    float alpha = shouldHidden?0:0.5;
    [UIView animateWithDuration:0.6 animations:^{
        _backGroundBtn.alpha = alpha;
    }];
}



#pragma mark --- BaseVC + GGRequest
-(void)finishLoadWithTag:(int)tag data:(id)responseObject error:(NSError *)error{
    if (responseObject&&responseObject[@"videos"]) {
        total = [responseObject[@"total"]intValue];
        [self.listArr addObjectsFromArray:responseObject[@"videos"]];
        [self.tableView reloadData];
    }
}





-(void)dealloc{
    [_searchBar removeFromSuperview];
    _searchBar = nil;
    _backGroundBtn = nil;
}

@end
