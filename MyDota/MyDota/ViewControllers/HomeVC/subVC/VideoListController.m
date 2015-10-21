//
//  VideoListController.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListController.h"
#import "MyDefines.h"
#import "GGRequest.h"


@interface VideoListController ()

@end

@implementation VideoListController{
    NSDictionary *_inputDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部视频";
    naviBar.backgroundView.alpha = 1;
    [self loadVideoList:2];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadVideoList:currentPage+1];
    }];
}

-(void)loadVideoList:(int)page{
    NSString *url = [NSString stringWithFormat:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10&page=%d",page];
    [GGRequest requestWithUrl:url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (responseObject&&responseObject[@"videos"]) {
                [self.listArr addObjectsFromArray:responseObject[@"videos"]];
                [self.tableView reloadData];
               currentPage = [responseObject[@"page"]intValue];
                total = [responseObject[@"total"]intValue];
            }
            if (total==self.listArr.count) {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
