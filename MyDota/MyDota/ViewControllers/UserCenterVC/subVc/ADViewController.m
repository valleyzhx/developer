//
//  ADViewController.m
//  MyDota
//
//  Created by Xiang on 15/11/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "ADViewController.h"
#import "MyDefines.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GGRequest.h"
#import "UIImageView+AFNetworking.h"


@interface ADViewController ()<GADInterstitialDelegate>

@end

@implementation ADViewController{
    GADBannerView *_adView;
    GADInterstitial *_interstitial;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"每日一句";
    self.view.backgroundColor = viewBGColor;
    _naviBar.backgroundView.alpha = 0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/5)];
    [self.view addSubview:imgView];
    [self.view bringSubviewToFront:_naviBar];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, SCREEN_WIDTH-20, 180)];
    lab.numberOfLines = 0;
    //lab.text = @"这里是广告,谢谢点进来^_^";
//    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheAction:)];
    [lab addGestureRecognizer:tap];
    lab.userInteractionEnabled = YES;
    
    [GGRequest requestWithUrl:@"http://open.iciba.com/dsapi/" accepType:@"html" withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        NSDictionary *dic = [operation.responseData jsonObject];
        if (dic) {
            NSString *content = dic[@"content"];
            NSString *note = dic[@"note"];
            NSString *dateline = dic[@"dateline"];
            NSString *url = dic[@"picture2"];
            if (note && content) {
                lab.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",content,note,dateline];
            }
            if (url.length) {
                [imgView setImageWithURL:[NSURL URLWithString:url]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    _adView = [[GADBannerView alloc]
               initWithFrame:CGRectMake((SCREEN_WIDTH-320)/2,self.view.frame.size.height -50,320,50)];
    _adView.adUnitID = @"ca-app-pub-7534063156170955/2929947627";//调用id
    
    _adView.rootViewController = self;
    [self.view addSubview:_adView];
    
    [_adView loadRequest:[GADRequest request]];
    
}


-(void)tapTheAction:(UITapGestureRecognizer*)tap{
    if (_interstitial) {
        _interstitial.delegate = nil;
        _interstitial = nil;
    }
    _interstitial = [[GADInterstitial alloc] init];
    _interstitial.delegate = self;
    _interstitial.adUnitID = @"ca-app-pub-7534063156170955/1210676429";
    GADRequest *request = [GADRequest request];
    [_interstitial loadRequest:request];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    
    return self;
}


-(void)dealloc{
    _adView.rootViewController = nil;
    _adView.delegate = nil;
    _interstitial.delegate = nil;
}

#pragma mark -
#pragma mark AdMoGoDelegate delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}

@end
