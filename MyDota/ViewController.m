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
#import "ScoreViewController.h"
#import "ASIHTTPRequest.h"
#import "UMFeedback.h"

@interface ViewController ()

@end

@implementation ViewController
{
    HomeViewController *homeView;
    HeroViewController *heroView;
    ScoreViewController *scoreView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _backgroundView.image = [UIImage imageNamed:@"3.png"];
    
    NSString *ver = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    _versionLab.text = [NSString stringWithFormat:@"刀一把:V%@",ver];
    
    
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
    homeView = nil;
    heroView = nil;
    scoreView = nil;
    
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
        case 2:{
            scoreView = [[ScoreViewController alloc]initWithNibName:@"ScoreViewController" bundle:nil];
            scoreView.view.frame = self.view.bounds;
            [self pushAnimationView:scoreView.view];
        }
            break;
        case 3:{
            [self presentViewController:[UMFeedback feedbackModalViewController]  animated:YES completion:nil];
            
        }
        default:
            break;
    }
}
@end
