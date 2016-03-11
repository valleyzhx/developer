//
//  TVViewController.m
//  MyDota
//
//  Created by Xiang on 16/3/10.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "TVViewController.h"
#import "MyDefines.h"
#import "UMOnlineConfig.h"
#import "TVListModel.h"
#import <UIImageView+AFNetworking.h>
#import "VideoListCell.h"
#import "BaseViewController+NaviView.h"
#import "LiveViewController.h"

@interface TVViewController ()

@end

@implementation TVViewController{
    UIWebView *_webView;
    TVListModel *_listModel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeCustom];
    _naviBar.backgroundView.alpha = 1;

    // Do any additional setup after loading the view.
    
//    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40)];
//    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:_webView];
    self.title = @"直播";
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        view.backgroundColor = viewBGColor;
        view;
    });
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadTheDataAction)];
    
    [self loadTVListData];
}

-(void)loadTVListData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *tvLiveUrl = [UMOnlineConfig getConfigParams:zqlist];
        [TVListModel loadTVList:tvLiveUrl complish:^(id objc) {
            _listModel = objc;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!_listModel||!_listModel.rooms.count) {
                
            }
            [self.tableView.mj_header endRefreshing];
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
    return _listModel.rooms.count;
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
        userLab.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:userLab];
    }
    
    TVModel *model = _listModel.rooms[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.bpic]];
    cell.titleLab.text = model.title;
    cell.publishLab.text = [NSString stringWithFormat:@"在线人数: %@",model.online];
    [ZXUnitil fitTheLabel:cell.titleLab];
    userLab.text = model.nickname;
    float y = cell.publishLab.frame.origin.y - CGRectGetMaxY(cell.titleLab.frame);
    userLab.center = CGPointMake(userLab.center.x, CGRectGetMaxY(cell.titleLab.frame)+y/2);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TVModel *model = _listModel.rooms[indexPath.row];
    LiveViewController *lvController = [[LiveViewController alloc]initWithTVModel:model];
    [self pushWithoutTabbar:lvController];
}

-(void)reloadTheDataAction{
    _listModel = nil;
    [self loadTVListData];
}


#pragma mark -- pushAction

-(void)pushWithoutTabbar:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
