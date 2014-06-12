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
@interface HeroViewController ()

@end

@implementation HeroViewController
{
    NSMutableArray *dataArray;
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
    dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self parseHTML];
}
- (void)parseHTML {
    NSError *error = nil;
    //HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    HTMLParser *parser = [[HTMLParser alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://dota.db.766.com"] error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
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
        [dataArray addObject:bar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
