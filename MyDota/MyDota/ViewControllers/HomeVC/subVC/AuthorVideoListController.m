//
//  AuthorVideoListController.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "AuthorVideoListController.h"
#import "VideoListModel.h"
#import "VideoListCell.h"
#import <UIImageView+AFNetworking.h>
#import "MyDefines.h"
#import "VideoViewController.h"

@interface AuthorVideoListController ()

@end

@implementation AuthorVideoListController{
    UserModel *_user;
    int total;
    int currentPage;
    NSMutableArray *_listArr;
    void (^finished)(NSDictionary*);
}

-(id)initWithUser:(UserModel *)user{
    if (self = [super init]) {
        _user = user;
    }
    return self;
}


-(id)initWithUser:(UserModel *)user selectCallback:(void (^)(NSDictionary *))block{
    if (self = [self initWithUser:user]) {
        finished = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _user.name;
    _listArr = [NSMutableArray array];
    naviBar.backgroundView.alpha = 1;
    [self loadVideoList:1];
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
    
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/videos/by_user.json?client_id=e2306ead120d2e34&user_id=%@&page=%d",_user.userId,page];
    [VideoListModel getVideoListBy:url complish:^(id object) {
        VideoListModel *model = object;
        [_listArr addObject:model];
        total = model.total.intValue;
        currentPage = model.page.intValue;
        [self.tableView reloadData];
        if (total==_listArr.count) {
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


#pragma mark --- tableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    VideoListModel *model = _listArr[section];
    return model.videos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VideoListCell" owner:self options:nil]firstObject];
    }
    
    VideoListModel *listInfo = _listArr[indexPath.section];
    NSDictionary *dataDic = listInfo.videos[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:dataDic[@"thumbnail"]]];
    cell.titleLab.text = dataDic[@"title"];
    cell.publishLab.text = dataDic[@"published"];
    [ZXUnitil fitTheLabel:cell.titleLab];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoListModel *listInfo = _listArr[indexPath.section];
    NSDictionary *dataDic = listInfo.videos[indexPath.row];
    if (_isFromVideo) {//back
        if (finished) {
            [self.navigationController popViewControllerAnimated:YES];
            finished(dataDic);
        }
    }else{
        self.hidesBottomBarWhenPushed = YES;
        VideoViewController *controller = [[VideoViewController alloc]initWithVideoDiction:dataDic];
        controller.userId = _user.userId.integerValue;
        controller.isFromAuthorList = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)dealloc{
    finished = nil;
   _listArr =nil;
    _user = nil;
}

@end