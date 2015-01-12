//
//  HeroViewController.h
//  MyDota
//
//  Created by Simplan on 14-6-12.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroBarView.h"
#import "HeroShowList.h"

@interface HeroViewController : UIViewController<heroViewDelegate,heroShowListDelegate,UIScrollViewDelegate>
- (IBAction)clickTheButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@end




