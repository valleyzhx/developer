//
//  HeroBarView.m
//  MyDota
//
//  Created by Simplan on 14/11/1.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HeroBarView.h"


#define frameWithd ([UIScreen mainScreen].bounds.size.width-20)
#define btnWidth 64

@implementation HeroBarView{
    UIView *contentView;
    NSArray *dataArr;
    id heroDelegate;
}

-(id)initWithHeroArray:(NSArray*)heroArr withDelegate:(id)delegate{
    NSInteger row = (heroArr.count-1)/4 + 1;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        heroDelegate = delegate;
        dataArr = [[NSArray alloc]initWithArray:heroArr];
        UIView *backView = [[UIView alloc]initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        [self addSubview:backView];
        contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frameWithd, row*(btnWidth+5)+5)];
        contentView.backgroundColor = [UIColor lightGrayColor];
        contentView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:contentView];
        
        for (int i=0; i<heroArr.count; i++) {
            DotaHero *hero = [heroArr objectAtIndex:i];
            int origin = (frameWithd/4 - btnWidth)/2;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(origin+(i%4)*(frameWithd/4), 5+(i/4)*(btnWidth+5), btnWidth, btnWidth)];
            [btn sd_setImageWithURL:[NSURL URLWithString:hero.imgUrl] forState:UIControlStateNormal];
            
            btn.tag = i;
            [btn addTarget:self action:@selector(clickToDetailView:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btn];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheBackground:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}
-(void)clickToDetailView:(UIButton*)btn{
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    NSInteger tag = btn.tag;
    DotaHero *hero = [dataArr objectAtIndex:tag];
    if (heroDelegate) {
        [heroDelegate changeToDetailView:hero];
    }
    
}
-(void)showInTheView:(UIView*)view{
    self.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)tapTheBackground:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)closeSelf{
    [self tapTheBackground:nil];
}
@end
