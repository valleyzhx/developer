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
    void (^finished)(VideoModel*);
}

-(id)initWithUser:(UserModel *)user{
    if (self = [super init]) {
        _user = user;
    }
    return self;
}


-(id)initWithUser:(UserModel*)user selectCallback:(void(^)(VideoModel*))block{
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
    _naviBar.backgroundView.alpha = 1;
    [self loadVideoList:1];
   
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}
-(void)loadMoreData{
    [self loadVideoList:currentPage+1];
}

-(void)loadVideoList:(int)page{
    
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/videos/by_user.json?client_id=e2306ead120d2e34&user_id=%@&page=%d",_user.modelID,page];
    [self showHudView];
    [VideoListModel getVideoListBy:url complish:^(id object) {
        [self hideHudView];
        if (object == nil) {
            return ;
        }
        VideoListModel *model = object;
        [_listArr addObject:model];
        total = model.total;
        currentPage = model.page;
        [self.tableView reloadData];
        if (total==_listArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    VideoModel *model = listInfo.videos[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    cell.titleLab.text = model.title;
    cell.publishLab.text = model.published;
    [ZXUnitil fitTheLabel:cell.titleLab];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoListModel *listInfo = _listArr[indexPath.section];
    VideoModel *model = listInfo.videos[indexPath.row];
    model.userid = _user.modelID;
    if (_isFromVideo) {//back
        if (finished) {
            [self.navigationController popViewControllerAnimated:YES];
            finished(model);
        }
    }else{
        VideoViewController *controller = [[VideoViewController alloc]initWithVideoModel:model];
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
