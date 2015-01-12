//
//  HeroShowList.m
//  MyDota
//
//  Created by Simplan on 15/1/2.
//  Copyright (c) 2015年 Simplan. All rights reserved.
//

#import "HeroShowList.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#define frameWithd ([UIScreen mainScreen].bounds.size.width-20)
#define btnWidth 100

@implementation HeroShowList{
    NSArray *dataArr;
    BOOL isLoading;
}

-(id)initWithHeroVideosArray:(NSArray *)arr{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        dataArr = [[NSArray alloc]initWithArray:arr];
        float origin = 10+ (frameWithd - btnWidth*3)/4;
        for (int i=0; i<arr.count; i++) {
            NSDictionary *hero = [arr objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:193.0/225 green:229.0/255 blue:195.0/255 alpha:1];
            [btn setFrame:CGRectMake(origin+(i%3)*(frameWithd/3), 20+(i/3)*(btnWidth+5), btnWidth, btnWidth)];
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
            [view sd_setImageWithURL:[NSURL URLWithString:hero[@"img"]]];
            [btn addSubview:view];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, btnWidth, 30)];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:8];
            lab.text = hero[@"title"];
            [btn addSubview:lab];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickToDetailView:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i==arr.count-1) {
                self.contentSize = CGSizeMake(screenWidth, btn.frame.origin.y+btn.frame.size.height);
            }
            
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setFrame:CGRectMake(0, 20, 30, 40 )];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 5, 15, 20)];
        imgView.image = [UIImage imageNamed:@"close.png"];
        [btn addSubview:imgView];
        [btn addTarget:self action:@selector(closeTheView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    return self;
}
-(void)closeTheView:(UIButton*)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)clickToDetailView:(UIButton*)btn{
    if (isLoading) {
        return;
    }
    isLoading = YES;
    NSInteger tag = btn.tag;
    NSDictionary *hero = [dataArr objectAtIndex:tag];
    NSString *url = hero[@"href"];
   __weak ASIHTTPRequest *requset = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [requset setCompletionBlock:^{
        NSString *str = requset.responseString;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\bhttp://player.youku.com\\b.*\\bswf\\b" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *array = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        NSString *youkuStr;
        for (NSTextCheckingResult* b in array)
        {
            youkuStr = [str substringWithRange:b.range];
        }
        if (array.count==0) {
            NSArray *arr = [str componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">"];
            if (arr.count==1) {
                if (_heroDelegate) {
                    [_heroDelegate changeToVideo:@"http"];
                    return ;
                }
            }
            NSArray *secArr = [[arr objectAtIndex:1]componentsSeparatedByString:@"<"];
            youkuStr = secArr[0];
        }
        isLoading = NO;
        if (_heroDelegate) {
            [_heroDelegate changeToVideo:youkuStr];
        }
    }];
    [requset startAsynchronous];
//    if (heroDelegate) {
//        [heroDelegate changeToDetailView:hero];
//    }
    
}
-(void)showInTheView:(UIView*)view{
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}
@end
