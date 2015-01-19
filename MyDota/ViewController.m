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
    NSLog(@"aaaaa");
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    int num = dateStr.intValue;
    _backgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",num%4+1]];
    NSString *ver = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    _versionLab.text = [NSString stringWithFormat:@"Dota助手:V%@",ver];
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:[NSString stringWithFormat:@"%@/dota.html",[self getPath]]]) {
        [fileMan copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"dota" ofType:@"html"]  toPath:[NSString stringWithFormat:@"%@/dota.html",[self getPath]] error:nil];
    }
        [self performSelectorInBackground:@selector(downloadHtml:) withObject:@"http://dota.uuu9.com/v/"];
}
-(NSString*)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [paths objectAtIndex:0];
}
-(void)downloadHtml:(NSString*)url{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *req = request;
    __weak NSString* path = [self getPath];
    [req setCompletionBlock:^{
        if (req.responseStatusCode == 200) {
            if ([url isEqualToString:@"http://dota.uuu9.com/v/"]) {
                
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                NSString *str = [[NSString alloc]initWithData:req.responseData encoding:enc];
                [[str dataUsingEncoding:NSUTF8StringEncoding] writeToFile:[NSString stringWithFormat:@"%@/dota.html",path] atomically:YES];
            }
        }
        [req clearDelegatesAndCancel];
    }];
    [req setFailedBlock:^{
        
    }];

    [req startAsynchronous];
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
