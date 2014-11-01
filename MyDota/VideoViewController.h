//
//  VideoViewController.h
//  MyDota
//
//  Created by Simplan on 14-5-28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdView.h"

@interface VideoViewController : UIViewController<DMAdViewDelegate,UIWebViewDelegate>
@property (nonatomic,retain)UIWebView *webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil linkUrlString:(NSString*)string;

@end
