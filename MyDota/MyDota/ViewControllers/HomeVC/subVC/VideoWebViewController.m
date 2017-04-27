//
//  VideoWebViewController.m
//  MyDota
//
//  Created by Xiang on 16/4/13.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "VideoWebViewController.h"

@interface VideoWebViewController () <UIWebViewDelegate>

@end

@implementation VideoWebViewController{
    NSString *_videoId;
    UIWebView *_webView;
}

-(id)initWithVideoId:(NSString *)videoId{
    if (self = [super init]) {
        _videoId = videoId;
    }
    return self;
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
    
    NSString *bundle = [[NSBundle mainBundle]pathForResource:@"video" ofType:@"html"];
    bundle = [bundle stringByAppendingFormat:@"?videoid=%@",_videoId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:bundle]];
    [_webView loadRequest:request];
}

-(void)initView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    
}

-(void)clickedBackAction:(UIButton*)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
