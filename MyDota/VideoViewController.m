//
//  VideoViewController.m
//  MyDota
//
//  Created by Simplan on 14-5-28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "VideoViewController.h"
#import "MobClick.h"
#import "DMTools.h"

#define DMPUBLISHERID        @"56OJwTgYuNHLIZLusJ"
#define DMPLCAEMENTID_BANNER @"16TLuz2aAprRkNUEAptG9las"
@interface VideoViewController ()

@end

@implementation VideoViewController
{
    NSString *urlString;
    DMAdView *_dmAdView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil yukuPlayer:(NSString*)string
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        urlString = [[NSString alloc]initWithString:string];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *leb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    leb.backgroundColor = [UIColor clearColor];
    leb.font = [UIFont systemFontOfSize:13];
    leb.text = self.navigationController.title;
    self.navigationItem.titleView = leb;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelViewAction)];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectTheViedo)];
    self.navigationItem.rightBarButtonItem = right;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"new_file" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"CNM" withString:urlString];
    [_webView loadHTMLString:htmlString baseURL:nil];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [MobClick event:watchVideoView];
    [self loadAdView];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
-(void)loadAdView
{
    _dmAdView = [[DMAdView alloc] initWithPublisherId:DMPUBLISHERID
                                          placementId:DMPLCAEMENTID_BANNER];
    
    // 设置广告视图的位置 宽与高设置为0即可 该广告视图默认是横竖屏自适应 但需要在旋转时调用orientationChanged 方法
    // Set the frame of advertisement view
    _dmAdView.frame = CGRectMake(0, self.view.frame.size.height-80, FLEXIBLE_SIZE.width,FLEXIBLE_SIZE.height);
    _dmAdView.delegate = self;
    _dmAdView.rootViewController = self; // set RootViewController
    [_webView addSubview:_dmAdView];
    [_dmAdView loadAd]; // start load advertisement
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // 检查评价提醒，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    // Check for rate please get your own ID from Domob website

    DMTools *_dmTools = [[DMTools alloc] initWithPublisherId:DMPUBLISHERID];
    [_dmTools checkRateInfo];

}
//针对Banner的横竖屏自适应方法
//method For multible orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [_dmAdView orientationChanged];
}

-(void)cancelViewAction
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)collectTheViedo
{
    NSLog(@"收藏");
}
- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
    _dmAdView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark DMAdView delegate

// 成功加载广告后，回调该方法
// This method will be used after load successfully
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] success to load ad.");
}

// 加载广告失败后，回调该方法
// This method will be used after load failed
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[Domob Sample] fail to load ad. %@", error);
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器
// When will be showing a Modal View, this method will be called. Such as open built-in browser
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will enter background.");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
