//
//  ScoreViewController.h
//  MyDota
//
//  Created by Simplan on 14/11/6.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;

- (IBAction)checkAction:(id)sender;

@end
