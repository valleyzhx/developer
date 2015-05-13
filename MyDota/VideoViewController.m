//
//  VideoViewController.m
//  MyDota
//
//  Created by Simplan on 14-5-28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "VideoViewController.h"
#import "MobClick.h"


@interface VideoViewController ()

@end

@implementation VideoViewController
{
    NSString *urlString;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil yukuPlayer:(NSString*)string
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"new_file" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        urlString = [htmlString stringByReplacingOccurrencesOfString:@"CNM" withString:string];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowVisible:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowHidden:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window];
    UILabel *leb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    leb.backgroundColor = [UIColor clearColor];
    leb.font = [UIFont systemFontOfSize:13];
    leb.text = self.navigationController.title;
    self.navigationItem.titleView = leb;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAct:)];
    self.navigationItem.leftBarButtonItem = left;
    //UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectTheViedo)];
    //self.navigationItem.rightBarButtonItem = right;
    
    _webView.scalesPageToFit = YES;
    [MobClick event:watchVideoView];
    
    _adView = [[AdMoGoView alloc]initWithAppKey:@"b54208fc718045ada08654e52d010b0e" adType:AdViewTypeNormalBanner adMoGoViewDelegate:self autoScale:YES];
    _adView.frame = CGRectZero;
    [_adView setViewPointType:AdMoGoViewPointTypeDown_middle];
    [self.view addSubview:_adView];
}
-(UIViewController*)viewControllerForPresentingModalView{
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startLoadHtml];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    
}

-(void)startLoadHtml{
    if (urlString) {
        [_webView loadHTMLString:urlString baseURL:nil];
    }
    
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    if ([request.URL.scheme isEqualToString:@"videohandler"]) {
//      //  NSLog(@"%@", request.URL.resourceSpecifier);//在这里可以获得事件
//        if ([request.URL.resourceSpecifier isEqualToString:@"//video-beginfullscreen"]) {//视频播放
//            
//        }else if ([request.URL.resourceSpecifier isEqualToString:@"//video-endfullscreen"]){
//            
//        }
//        
//        return NO;
//    }
//    return YES;
//}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

-(void)cancelAct:(id*)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)collectTheViedo
{
    NSLog(@"收藏");
}
- (void)dealloc
{
    urlString = nil;
    _adView = nil;
    _webView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)windowVisible:(NSNotification *)notification
{
   //视频隐藏
    
}

- (void)windowHidden:(NSNotification *)notification
{
    
    //视频播放
    //强制横屏
    //http://player.youku.com/player.php/sid/XOTMwNjU4OTgw/partnerid/c9bb14f8593c7a8b/v.swf
    //http://v.youku.com/player/getRealM3U8/vid/XOTMwNjU4OTgw/type/video.m3u8
//file:///Users/simplan/Desktop/30%E5%A4%A9/%E3%80%90%E6%83%85%E4%B9%A6dota%E8%A7%A3%E8%AF%B4%E3%80%91%E8%BE%89%E8%80%80%E5%86%B0%E9%9B%B7%E5%8D%A1,%E7%96%AF%E7%8B%8227%E6%9D%80![%E9%AB%98%E6%B8%85%E7%89%88].m3u
    //[self preferredInterfaceOrientationForPresentation];
}
//-(BOOL)shouldAutorotate{
//    return YES;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}

@end





