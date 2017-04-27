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
#import "Reachability.h"


#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface BaseViewController ()<GADInterstitialDelegate>

@end

@implementation BaseViewController{
    BOOL isLoading;
    GADBannerView *_adView;
    GADInterstitial *_interstitial;
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
    [self initEmptyLabel];
}

-(void)initEmptyLabel{
    _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    _emptyLabel.textColor = TextDarkColor;
    _emptyLabel.font = [UIFont systemFontOfSize:16];
    _emptyLabel.text = @"暂无数据，稍后重试!";
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.view addSubview:_emptyLabel];
    _emptyLabel.hidden = YES;
}


#pragma mark- CheckWifi
-(void)checkWIFI{
    Reachability *ability = [Reachability reachabilityForLocalWiFi];
    if ([ability isReachableViaWiFi] == NO) { // 流量
        [self showMessage:@"土豪，您在使用流量哦"];
    }
}


#pragma mark- AD

-(void)loadBottomADView{
    _adView = [[GADBannerView alloc]
               initWithFrame:CGRectMake((SCREEN_WIDTH-320)/2,50,320,50)];
    _adView.adUnitID = @"ca-app-pub-7534063156170955/2929947627";//调用id
    
    _adView.rootViewController = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [view addSubview:_adView];
    self.tableView.tableFooterView = view;
    GADRequest *req = [GADRequest request];
#if DEBUG
    req.testDevices = @[@"5610fbd8aa463fcd021f9f235d9f6ba1"];
#endif
    [_adView loadRequest:req];
}

-(void)loadFullADView{
    if (_interstitial) {
        _interstitial.delegate = nil;
        _interstitial = nil;
    }
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7534063156170955/1210676429"];
    _interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
#if DEBUG
    request.testDevices = @[ @"5610fbd8aa463fcd021f9f235d9f6ba1" ];
#endif
    [_interstitial loadRequest:request];
}



-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    _naviBar.title = title;
}

-(void)setSearchButton{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"searchBarBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    _naviBar.rightView = btn;
    btn.center = CGPointMake(btn.center.x-10, btn.center.y);
}


#pragma mark Search Action
-(void)searchAction:(UIButton*)btn{
    
}


-(void)showHudView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view bringSubviewToFront:_naviBar];
}

-(void)hideHudView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)showMessage:(NSString*)message{
    [MBProgressHUD showString:message inView:KeyWindow];
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


#pragma mark -
#pragma mark AdMoGoDelegate delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [self checkWIFI];
}



-(void)dealloc{
    _tableView = nil;
    _interstitial.delegate = nil;
    _adView.rootViewController = nil;
    _adView.delegate = nil;
}

@end
