//
//  ViewController.m
//  MyDota
//
//  Created by Simplan on 14-4-17.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "HeroViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    HomeViewController *homeView;
    HeroViewController *heroView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
}
-(void)pushAnimationView:(UIView*)view
{
    float y = 0;
    if (!iOS7) {
        y = -20;
    }
    view.center = CGPointMake(self.view.frame.size.width+view.center.x, view.center.y+y);
    view.alpha = 0.5;
    [self.view addSubview:view];
    [UIView animateWithDuration:0.5 animations:^{
        view.center = CGPointMake(self.view.frame.size.width/2, view.center.y+y);
        view.alpha = 0.8;
    } completion:^(BOOL finished) {
        view.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc{
    homeView = nil;
    heroView = nil;
}
- (IBAction)mainViewClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            homeView.view.frame = self.view.bounds;
            [self pushAnimationView:homeView.view];
        }
            break;
            case 1:
        {
            heroView = [[HeroViewController alloc]initWithNibName:@"HeroViewController" bundle:nil];
            heroView.view.frame = self.view.bounds;
            [self pushAnimationView:heroView.view];
        }
            break;
        default:
            break;
    }
}
@end
