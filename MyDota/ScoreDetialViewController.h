//
//  ScoreDetialViewController.h
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreData.h"
#import "ScoreTableScollDelegate.h"

@interface ScoreDetialViewController : UIViewController<ScoreTableScollDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (strong,nonatomic)NSNumber *userId;
@property (strong,nonatomic)NSDictionary *ttScoreInfoDic;
@property (strong,nonatomic)NSDictionary *jjcScoreInfoDic;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(ScoreData*)scoreData;
@end
