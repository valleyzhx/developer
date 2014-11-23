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
#import "HeroBarView.h"
@interface HeroViewController ()

@end

@implementation HeroViewController
{
    NSMutableDictionary *dataArray;
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
    self.view.hidden = YES;
    dataArray = [[NSMutableDictionary alloc]init];
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
    [self performSelectorInBackground:@selector(parseHTML) withObject:nil];
    _myScroll.contentSize = CGSizeMake(_myScroll.frame.size.width, _secondView.frame.origin.y+_secondView.frame.size.height);
}
-(NSString*)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"%@",paths);
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
    NSLog(@"%@",bodyNode.contents);
    NSArray *inputNodes = [bodyNode findChildrenOfClass:@"picbox"];
    for (HTMLNode *node in inputNodes) {
        HTMLNode *h4 = [node findChildTag:@"h4"];
        DotaHeroBar *bar = [[DotaHeroBar alloc]init];
        bar.barName = [h4 contents];//创建 酒馆
        HTMLNode *ul = [node findChildOfClass:@"piclist"];
        for (HTMLNode *li in [ul children]) {
            for (HTMLNode *a in [li children]) {
                DotaHero *hero = [[DotaHero alloc]init];//创建英雄
                hero.heroName = [a getAttributeNamed:@"title"];
                hero.dataUrl = [a getAttributeNamed:@"href"];
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
    NSString *name = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    DotaHeroBar *heroBar = [dataArray objectForKey:name];
    
    HeroBarView *barView = [[HeroBarView alloc]initWithHeroArray:heroBar.heroArray withDelegate:self];
    [barView showInTheView:self.view];
    
}
-(void)changeToDetailView:(DotaHero*)hero{
    NSString *url = hero.dataUrl;
    NSLog(@"%@",url);
}




@end
