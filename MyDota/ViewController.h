//
//  ViewController.h
//  MyDota
//
//  Created by Simplan on 14-4-17.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
- (IBAction)mainViewClicked:(UIButton *)sender;

@end
