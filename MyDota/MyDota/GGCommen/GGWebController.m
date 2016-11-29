//
//  GGWebController.m
//  MyDota
//
//  Created by Xiang on 15/12/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGWebController.h"
#import "BaseViewController+NaviView.h"

@interface GGWebController ()<UIWebViewDelegate>

@end

@implementation GGWebController{
    UIWebView *_webView;
    UIButton *_closeBtn;
}

- (void)viewDidLoad {
    self.noTable = YES;
    [super viewDidLoad];
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, 20, 44, 44)];
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeTheWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:_closeBtn];
    _closeBtn.hidden = YES;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviBar.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(_naviBar.frame))];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)clickedBackAction:(UIButton*)btn{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeTheWebView:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _closeBtn.hidden = ![webView canGoBack];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    
}


@end
