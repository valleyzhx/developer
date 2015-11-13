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


@implementation VideoListController{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部视频";
    _naviBar.backgroundView.alpha = 1;
    [self loadVideoList:2];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
-(void)loadMoreData{
    [self loadVideoList:currentPage+1];
}

-(void)loadVideoList:(int)page{
    NSString *url = [NSString stringWithFormat:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10&page=%d",page];
    
    [VideoListModel getVideoListBy:url complish:^(id objc) {
        if (objc == nil) {
            return ;
        }
        VideoListModel *model = objc;
        if (model.videos) {
            [self.listArr addObjectsFromArray:model.videos];
            currentPage = model.page;
            total = model.total;
            [self.tableView reloadData];
        }
        if (total==self.listArr.count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}


@end
