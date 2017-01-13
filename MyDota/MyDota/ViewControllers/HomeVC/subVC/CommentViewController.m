//
//  CommentViewController.m
//  MyDota
//
//  Created by Xiang on 16/2/18.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "CommentViewController.h"
#import "MyDefines.h"
#import "AuthorVideoListController.h"
#import "GGWebController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface CommentViewController ()

@end

@implementation CommentViewController{
    NSString *_videoId;
    NSMutableArray *_hotListModelArr;
    NSMutableArray *_listModelArr;
}


-(id)initWithVideoId:(NSString *)videoId{
    if (self = [super init]) {
        _videoId = videoId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部评论";
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        view.backgroundColor = viewBGColor;
        view;
    });
    _listModelArr = [NSMutableArray array];
    _hotListModelArr = [NSMutableArray array];

    //comments
    [self showHudView];
    [CommentListModel getHotCommentsWithVideoId:_videoId page:1 complish:^(id objc) {
        if (objc) {
            [_hotListModelArr addObject:objc];
            [self.tableView reloadData];
        }
        if (_listModelArr.count) {
            [self hideHudView];
        }
        
    }];
    currentPage = 1;
    [self getCommentDataWithPage:currentPage];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)getCommentDataWithPage:(int)page{
    [CommentListModel getCommentsWithVideoId:_videoId page:page complish:^(id objc) {
        if (objc) {
            [_listModelArr addObject:objc];
            CommentListModel *model = objc;
            currentPage = model.page;
            total += model.comments.count;
            if (total == model.total) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }
        if (_hotListModelArr.count) {
            [self hideHudView];
        }
    }];
}

-(void)loadMoreData{
    currentPage++;
    [self getCommentDataWithPage:currentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --- tableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _hotListModelArr.count + _listModelArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CommentListModel *model;
    if (section < _hotListModelArr.count) {
        model = _hotListModelArr[section];
    }else{
        model = _listModelArr[section - _hotListModelArr.count];
    }
    return model.comments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentListModel *listModel;
    if (indexPath.section < _hotListModelArr.count) {
        listModel = _hotListModelArr[indexPath.section];
    }else{
        listModel = _listModelArr[indexPath.section - _hotListModelArr.count];
    }
    
    CommentModel *model = listModel.comments[indexPath.row];
    float titleHeight = [ZXUnitil heightOfStringWithString:model.content font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-orgX*2];
    
    return orgX + titleHeight + 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *contentLab = (UILabel*)[cell.contentView viewWithTag:11];
    UIButton *userBtn = (UIButton*)[cell.contentView viewWithTag:12];
    UILabel *publishLab = (UILabel*)[cell.contentView viewWithTag:13];
    UIImageView *hotView = [cell.contentView viewWithTag:14];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        contentLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, orgX, SCREEN_WIDTH-2*orgX, 40)];
        contentLab.tag = 11;
        contentLab.textColor = TextDarkColor;
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.numberOfLines = 0;
        [cell.contentView addSubview:contentLab];
        
        userBtn = [[UIButton alloc]initWithFrame:CGRectMake(orgX, 40, 100, 40)];
        userBtn.tag = 12;
        [userBtn setTitleColor:JDDarkOrange forState:UIControlStateNormal];
        userBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        userBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [userBtn addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:userBtn];
        
        publishLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orgX-150, 40, 150, 20)];
        publishLab.tag = 13;
        publishLab.textColor = TextLightColor;
        publishLab.font = [UIFont systemFontOfSize:12];
        publishLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:publishLab];
        
        hotView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        hotView.image = [UIImage imageNamed:@"hot"];
        hotView.tag = 14;
        [cell.contentView addSubview:hotView];
    }
    CommentListModel *listModel;
    if (indexPath.section < _hotListModelArr.count) {
        listModel = _hotListModelArr[indexPath.section];
        hotView.hidden = NO;
    }else{
        listModel = _listModelArr[indexPath.section - _hotListModelArr.count];
        hotView.hidden = YES;
    }
    
    CommentModel *model = listModel.comments[indexPath.row];
    contentLab.text = model.content;
    [ZXUnitil fitTheLabel:contentLab];
    
    CGRect r = publishLab.frame;
    r.origin.y = CGRectGetMaxY(contentLab.frame)+10;
    publishLab.frame = r;
    publishLab.text = model.published;
    
    userBtn.center = CGPointMake(userBtn.center.x, publishLab.center.y);
    [userBtn setTitle:model.userName forState:UIControlStateNormal];
    [userBtn setTitle:model.userLink forState:UIControlStateDisabled];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)userButtonClicked:(UIButton*)btn{
    GGWebController *vc = [[GGWebController alloc]init];
    vc.urlString = [btn titleForState:UIControlStateDisabled];
    [self.navigationController pushViewController:vc animated:YES];
}






@end
