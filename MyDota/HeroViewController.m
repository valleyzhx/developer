//
//  HeroViewController.m
//  MyDota
//
//  Created by Simplan on 14-6-12.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HeroViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "HTMLParser.h"
#import "DotaHeroBar.h"
#import "MyLoadingView.h"
#import "LoadingView.h"

#import "VideoViewController.h"
@interface HeroViewController ()

@end

@implementation HeroViewController
{
    NSMutableDictionary *dataArray;
    NSMutableArray *videoArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    dataArray = [[NSMutableDictionary alloc]init];
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
    [self performSelectorInBackground:@selector(parseHTML) withObject:nil];
    _myScroll.contentSize = CGSizeMake(_myScroll.frame.size.width, _secondView.frame.origin.y+_secondView.frame.size.height);
    _myScroll.delegate = self;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, screenHeight-80, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 101;
    [self.view addSubview:backBtn];
}
-(NSString*)getPath{
   return  [[NSBundle mainBundle]pathForResource:@"dota" ofType:@"html"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [NSString stringWithFormat:@"%@/dota.html",[paths objectAtIndex:0]];
}
- (void)parseHTML {
    NSError *error = nil;
    //HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    HTMLParser *parser = [[HTMLParser alloc]initWithString:[NSString stringWithContentsOfFile:[self getPath] encoding:NSUTF8StringEncoding error:nil] error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }

    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildrenOfClass:@"herolistbox"];
    NSArray *barNameArr = @[@"力量-",@"敏捷-",@"智力-"];
    int i = 0;
    for (HTMLNode *node in inputNodes) {
        HTMLNode *h4 = [node findChildTag:@"h3"];
        DotaHeroBar *bar = [[DotaHeroBar alloc]init];
        bar.barName = [NSString stringWithFormat:@"%@%@",barNameArr[i/4],[h4 contents]];//创建 酒馆
        i++;
        HTMLNode *ul = [node findChildOfClass:@"herocon cl"];
            for (HTMLNode *a in [ul children]) {
                if ([a.tagName isEqualToString:@"a"]) {
                    DotaHero *hero = [[DotaHero alloc]init];//创建英雄
                    hero.dataUrl = [a getAttributeNamed:@"href"];
                    hero.heroName = [[a findChildTag:@"img"] getAttributeNamed:@"title"];
                    hero.imgUrl = [[a findChildTag:@"img"] getAttributeNamed:@"src"];
                    [bar.heroArray addObject:hero];
                }
            }
        
        [dataArray setObject:bar forKey:bar.barName];
    }
    [self performSelectorOnMainThread:@selector(showTheView) withObject:nil waitUntilDone:NO];
}
-(void)showTheView {
    [[MyLoadingView shareLoadingView]stopWithFinished:^{
        self.view.hidden = NO;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickTheButton:(UIButton *)sender {
    DotaHeroBar *heroBar = [dataArray objectForKey:sender.titleLabel.text];
    
    HeroBarView *barView = [[HeroBarView alloc]initWithHeroArray:heroBar.heroArray withDelegate:self];
    [barView showInTheView:self.view];
    
}
-(void)changeToDetailView:(DotaHero*)hero{
    [videoArray removeAllObjects];
    if (videoArray==nil) {
        videoArray = [NSMutableArray array];
    }
    NSString *url = [NSString stringWithFormat:@"%@/Index.shtml",hero.dataUrl];
     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *req = request;
    [req setCompletionBlock:^{
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str = [[NSString alloc]initWithData:req.responseData encoding:enc];
        HTMLParser *parser = [[HTMLParser alloc]initWithString:str error:nil];
        HTMLNode *bodyNode = [parser body];
        NSArray *inputNodes = [bodyNode findChildrenOfClass:@"videolist3"];
        for (HTMLNode *node in inputNodes) {
            HTMLNode *a = [node findChildTag:@"a"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[a getAttributeNamed:@"href"] forKey:@"href"];
            [dic setObject:[a getAttributeNamed:@"title"] forKey:@"title"];
            [dic setObject:[[a findChildTag:@"img"] getAttributeNamed:@"src"] forKey:@"img"];
            [videoArray addObject:dic];
        }
        UIView *view = [[self.view subviews]lastObject];
        if ([view isKindOfClass:[HeroBarView class]]) {
            [(HeroBarView*)view closeSelf];
        }
        HeroShowList *list = [[HeroShowList alloc]initWithHeroVideosArray:videoArray];
        list.heroDelegate = self;
        [list showInTheView:self.view];
        
    }];

    [req startAsynchronous];
    
    
}
-(void)changeToVideo:(NSString*)youkuString{

    if ([youkuString hasPrefix:@"http"]) {
        
        LoadingView *view = [[LoadingView alloc]initWithString:@"iOS暂不支持此视频,请观看其他视频"];
        [view show];
        
//        VideoViewController *viewControl = [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewControl];
//        NSString *url = [[NSBundle mainBundle] pathForResource:@"flash" ofType:@"html"];
//        url = @"http://dota.uuu9.com/201310/103836.shtml";
//        [self presentViewController:nav animated:YES completion:^{
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//            [viewControl.webView loadRequest:request];
//        }];
    }else{
        VideoViewController *viewControl = [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil yukuPlayer:youkuString];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewControl];
        
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UIButton *btn = (UIButton*)[self.view viewWithTag:101];
    btn.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn = (UIButton*)[self.view viewWithTag:101];
    btn.hidden = NO;
}
-(void)backAction:(UIButton*)btn{
    btn.hidden = YES;
    float y = 0;
    if (!iOS7) {
        y = -20;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width*1.5, self.view.center.y+y);
        self.view.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}


@end
