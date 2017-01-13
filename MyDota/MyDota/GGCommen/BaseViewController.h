//
//  BaseViewController.h
//  MyDota
//
//  Created by Xiang on 15/8/6.
//  Copyright (c) 2015年 iGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGNavigationBar.h"
#import "MJRefresh.h"
#import "MobClick.h"
#import "MBProgressHUD+string.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define orgX 16

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    int currentPage;
    int total;
    GGNavigationBar *_naviBar;
    
    UILabel *_emptyLabel;
}

@property (nonatomic,assign) BOOL noTable;
@property (nonatomic,strong) UITableView *tableView;


-(void)checkWIFI;

-(void)loadBottomADView;
-(void)loadFullADView;


-(void)setSearchButton;
-(void)searchAction:(UIButton*)btn;

-(void)showHudView;
-(void)hideHudView;
-(void)showMessage:(NSString*)message;


@end
