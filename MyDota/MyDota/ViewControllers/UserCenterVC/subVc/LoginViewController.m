//
//  LoginViewController.m
//  MyDota
//
//  Created by Xiang on 16/3/3.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "LoginViewController.h"
#import "MyDefines.h"

@interface LoginViewController () <UIWebViewDelegate>

@end

@implementation LoginViewController{
    UIWebView *_webView;
    void (^myBlock)(NSString*);
}
-(id)initWithFinishBlock:(void (^)(NSString *token))successBlock{
    if (self = [super init]) {
        myBlock = successBlock;
    }
    return self;
}
- (void)viewDidLoad {
    self.noTable = YES;
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviBar.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(_naviBar.frame))];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSString *urlStr = @"https://openapi.youku.com/v2/oauth2/authorize?client_id=e2306ead120d2e34&response_type=token&redirect_uri=http://www.idreams.club&state=success";
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}


-(void)clickedBackAction:(UIButton*)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
    if ([url.absoluteString hasPrefix:@"http://www.idreams.club"]) {
       
        NSArray *arr = [url.absoluteString componentsSeparatedByString:@"#"];
        if (arr.count>1) {
            NSString *query = arr[1];
            NSDictionary *resultDic = [ZXUnitil urlQueryDicWithQueryString:query];
            
            NSString *access_token = resultDic[@"access_token"];
            long long expires_in = [resultDic[@"expires_in"]longLongValue];
            NSTimeInterval expireValue = [[NSDate date]timeIntervalSince1970] + expires_in;
            
            [[NSUserDefaults standardUserDefaults]setObject:access_token forKey:kToken];
            [[NSUserDefaults standardUserDefaults]setDouble:expireValue forKey:kTokenExpireValue];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (myBlock) {
                myBlock(access_token);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        //access_token=a0f8f59974f0aae6226a0b57ab4c9e06&state=success&token_type=bearer&expires_in=2592000&response_type=login
        return NO;
    }
    return YES;
}


-(void)dealloc{
    myBlock = nil;
}

@end
