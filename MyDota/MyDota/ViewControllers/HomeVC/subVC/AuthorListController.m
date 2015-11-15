//
//  AuthorListController.m
//  MyDota
//
//  Created by Xiang on 15/11/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "AuthorListController.h"
#import "UserListModel.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "AuthorVideoListController.h"

@interface AuthorListController ()
@property (nonatomic,strong) NSMutableArray <UserModel *>*listArr;

@end

@implementation AuthorListController{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [NSMutableArray array];
    self.title = @"Dota热门作者";
    _naviBar.backgroundView.alpha = 1;
    self.showGDTADView = YES;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 48)];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self loadAuthorList:1];

}
-(void)loadMoreData{
    [self loadAuthorList:currentPage+1];
}

-(void)loadAuthorList:(int)page{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/users/friendship/followings.json?client_id=e2306ead120d2e34&user_id=811232081&page=%d",page];
    [UserListModel getUserListBy:url complish:^(id objc) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (objc == nil) {
            return ;
        }
        UserListModel *model = objc;
        if (model.users.count) {
            NSArray *arr = [self getSortedListArr:model.users];
            [self.listArr addObjectsFromArray:arr];
            currentPage ++;
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


-(NSArray*)getSortedListArr:(NSArray*)array{
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:array];
    NSComparator cmptr = ^(UserModel *obj1, UserModel *obj2){
        if (obj1.followers_count < obj2.followers_count) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.followers_count > obj2.followers_count) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    [newArr sortUsingComparator:cmptr];
    return newArr;
}

#pragma mark --- tableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:11];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(orgX, 2, 40, 40)];
        imgView.tag = 11;
        [cell.contentView addSubview:imgView];
    }
    UserModel *model = _listArr[indexPath.row];
    [imgView setImageWithURL:[NSURL URLWithString:model.avatar_large]];
    cell.textLabel.text = [NSString stringWithFormat:@"             %@",model.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserModel *model = _listArr[indexPath.row];
    
    AuthorVideoListController *avlControl = [[AuthorVideoListController alloc]initWithUser:model];
    [self.navigationController pushViewController:avlControl animated:YES];
}



@end
