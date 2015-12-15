//
//  BaseViewController.m
//  MyDota
//
//  Created by Xiang on 15/8/6.
//  Copyright (c) 2015年 iGG. All rights reserved.
//

#import "BaseViewController.h"
#import "MyDefines.h"
#import "BaseViewController+NaviView.h"


#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface BaseViewController ()<GDTMobBannerViewDelegate>

@end

@implementation BaseViewController{
    BOOL isLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_noTable == NO) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorColor = viewBGColor;
        self.tableView.backgroundColor = viewBGColor;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView setHiddenExtrLine:YES];
        
        [self.view addSubview:_tableView];
    }
    _naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeNormal];
    
    
}
-(void)setGDTAdUI{
    float x = (SCREEN_WIDTH-320)/2;
    _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(x, 0,320,50)
                                                   appkey:@"1104096526"
                                              placementId:@"8050900171935450"];
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 20; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    //    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
}

-(void)setShowGDTADView:(BOOL)showGDTADView{
    _showGDTADView = showGDTADView;
    if (_showGDTADView) {
        [self setGDTAdUI];
    }else{
        [_bannerView removeFromSuperview];
        _bannerView.delegate = nil;
        _bannerView = nil;
    }
}


-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    _naviBar.title = title;
}

-(void)showHudView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view bringSubviewToFront:_naviBar];
}

-(void)hideHudView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = viewBGColor;
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.textColor = TextDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


#pragma mark GDT Degetate
- (void)bannerViewDidReceived{
    self.tableView.tableFooterView = _bannerView;
}

- (void)bannerViewFailToReceived:(NSError *)error{
    NSLog(@"--%@",error);
    [_bannerView loadAdAndShow];
}


-(void)dealloc{
    _tableView = nil;
    _bannerView.delegate = nil;
    _bannerView = nil;
}

@end
