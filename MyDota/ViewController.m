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
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if (![fileMan fileExistsAtPath:[NSString stringWithFormat:@"%@/dota.html",[self getPath]]]) {
        [fileMan copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"dota" ofType:@"html"]  toPath:[NSString stringWithFormat:@"%@/dota.html",[self getPath]] error:nil];
    }
    if (![fileMan fileExistsAtPath:[NSString stringWithFormat:@"%@/rss.xml",[self getPath]]]) {
        [fileMan copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"rss" ofType:@"xml"]  toPath:[NSString stringWithFormat:@"%@/rss.xml",[self getPath]] error:nil];
    }
    [self performSelectorInBackground:@selector(downloadHtml:) withObject:@"http://dota.db.766.com"];
}
-(NSString*)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [paths objectAtIndex:0];
}
-(void)downloadHtml:(NSString*)url{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 200) {
            if ([url isEqualToString:@"http://dota.db.766.com"]) {
                [request.responseData writeToFile:[NSString stringWithFormat:@"%@/dota.html",[self getPath]] atomically:YES];
                [self downloadHtml:@"http://dota.uuu9.com/rss.xml"];
            }else{
                NSString *str = request.responseString;
                NSArray *array = [str componentsSeparatedByString:@"http://dota.uuu9.com/2013"];
                if (array.count) {
                    [request cancel];
                    [self downloadHtml:url];
                }else{
                  [request.responseData writeToFile:[NSString stringWithFormat:@"%@/rss.xml",[self getPath]] atomically:YES];
                }
            }
        }
    }];
    [request setFailedBlock:^{
        
    }];

    [request startAsynchronous];
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
        default:
            break;
    }
}
@end
