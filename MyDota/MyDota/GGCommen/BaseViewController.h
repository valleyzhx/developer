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
#import "GDTMobBannerView.h"

#define orgX 16

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    int currentPage;
    int total;
    GGNavigationBar *_naviBar;
    
    GDTMobBannerView *_bannerView;
    UILabel *_emptyLabel;
}

@property (nonatomic,assign) BOOL noTable;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) BOOL showGDTADView;


-(void)showHudView;
-(void)hideHudView;

@end
