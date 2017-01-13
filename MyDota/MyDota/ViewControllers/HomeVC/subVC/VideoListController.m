//
//  VideoListController.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListController.h"
#import "MyDefines.h"
#import "VideoListModel.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@implementation VideoListController{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"最新视频";
    _naviBar.backgroundView.alpha = 1;
    currentPage = 1;
    [self loadVideoList:currentPage];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadTheDataAction)];

}

-(NSString *)getKeyWord{
    return @"dota";
}


-(void)reloadTheDataAction{
    currentPage = 1;
    [self.listArr removeAllObjects];
    [self loadVideoList:currentPage];
}

-(void)loadMoreData{
    currentPage++;
    [self loadVideoList:currentPage];
}

-(void)loadVideoList:(int)page{
    
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/searches/video/by_keyword.json?client_id=e2306ead120d2e34&keyword=%@&orderby=published&page=%d",[self getKeyWord],page];//category=游戏
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSString *url = [NSString stringWithFormat:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10&page=%d",page];
    [self showHudView];
    
    [VideoListModel getVideoListBy:url complish:^(id objc) {
        [self hideHudView];
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
        }
    }];
    
    
//    [VideoListModel getVideoListBy:url complish:^(id objc) {
//        [self hideHudView];
//        if (objc == nil) {
//            return ;
//        }
//        VideoListModel *model = objc;
//        if (model.videos) {
//            [self.listArr addObjectsFromArray:model.videos];
//            currentPage = model.page;
//            total = model.total;
//            [self.tableView reloadData];
//        }
//        if (total==self.listArr.count) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [self.tableView.mj_footer endRefreshing];
//        }
//    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}


@end
