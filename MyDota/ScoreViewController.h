//
//  ScoreViewController.h
//  MyDota
//
//  Created by Simplan on 14/11/6.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"

@interface ScoreViewController : UIViewController<AdMoGoDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (nonatomic,strong)AdMoGoView *adView;

- (IBAction)checkAction:(id)sender;
- (IBAction)returnTheKeyBoard:(id)sender;

@end
