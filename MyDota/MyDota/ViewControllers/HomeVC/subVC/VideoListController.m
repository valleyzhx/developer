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
#import "VideoListCell.h"
#import <UIImageView+AFNetworking.h>
#import "VideoViewController.h"

@interface VideoListController ()

@end

@implementation VideoListController{
    NSMutableArray *_listArr;
    NSDictionary *_inputDic;
    int currentPage;
    int total;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部视频";
    _listArr = [NSMutableArray array];
    naviBar.backgroundView.alpha = 1;
    [self loadVideoList:2];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 48)];
        view.backgroundColor = viewBGColor;
        view;
    });
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadVideoList:currentPage+1];
    }];
}

-(void)loadVideoList:(int)page{
    NSString *url = [NSString stringWithFormat:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10&page=%d",page];
    [GGRequest requestWithUrl:url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (responseObject&&responseObject[@"videos"]) {
                [_listArr addObjectsFromArray:responseObject[@"videos"]];
                [self.tableView reloadData];
               currentPage = [responseObject[@"page"]intValue];
                total = [responseObject[@"total"]intValue];
            }
            if (total==_listArr.count) {
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


#pragma mark --- tableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"];
    UILabel *userLab = (UILabel*)[cell.contentView viewWithTag:77];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VideoListCell" owner:self options:nil]firstObject];
        userLab = [[UILabel alloc]initWithFrame:CGRectMake(cell.publishLab.frame.origin.x, cell.publishLab.frame.origin.y-25, 150, 14)];
        userLab.tag = 77;
        [cell.contentView addSubview:userLab];
        
    }
    
    NSDictionary *dataDic = _listArr[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:dataDic[@"thumbnail"]]];
    cell.titleLab.text = dataDic[@"title"];
    cell.publishLab.text = dataDic[@"published"];
    [ZXUnitil fitTheLabel:cell.titleLab];
    //userLab.text = dataDic[@""];
    float y = cell.publishLab.frame.origin.y - CGRectGetMaxY(cell.imgView.frame);
    userLab.center = CGPointMake(userLab.center.x, CGRectGetMaxY(cell.imgView.frame)+y/2);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDic = _listArr[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    VideoViewController *controller = [[VideoViewController alloc]initWithVideoDiction:dataDic];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
