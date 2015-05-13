//
//  VideoViewController.h
//  MyDota
//
//  Created by Simplan on 14-5-28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"


@interface VideoViewController : UIViewController<UIWebViewDelegate,AdMoGoDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)AdMoGoView *adView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil yukuPlayer:(NSString*)string;
@end


