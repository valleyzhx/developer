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
-(void)startLoadHtml{
    if (urlString) {
        [_webView loadHTMLString:urlString baseURL:nil];
    }
    
}
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
