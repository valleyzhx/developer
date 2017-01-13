//
//  VideoListBaseController.m
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListBaseController.h"
#import "VideoListCell.h"
#import <UIImageView+AFNetworking.h>
#import "VideoViewController.h"
#import "MyDefines.h"


@interface VideoListBaseController ()

@end

@implementation VideoListBaseController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [NSMutableArray array];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        view.backgroundColor = viewBGColor;
        view;
    });
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
    
    VideoModel *model = _listArr[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    cell.titleLab.text = model.title;
    cell.publishLab.text = model.published;
    [ZXUnitil fitTheLabel:cell.titleLab];
    //userLab.text = dataDic[@""];
    float y = cell.publishLab.frame.origin.y - CGRectGetMaxY(cell.imgView.frame);
    userLab.center = CGPointMake(userLab.center.x, CGRectGetMaxY(cell.imgView.frame)+y/2);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoModel *model = _listArr[indexPath.row];
    VideoViewController *controller = [[VideoViewController alloc]initWithVideoModel:model];
    [self.navigationController pushViewController:controller animated:YES];
    
}





@end
