//
//  HeroBarView.h
//  MyDota
//
//  Created by Simplan on 14/11/1.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DotaHeroBar.h"

@protocol heroViewDelegate <NSObject>

-(void)changeToDetailView:(DotaHero*)hero;

@end

@interface HeroBarView : UIView
@property(nonatomic,assign)BOOL isLoading;
-(id)initWithHeroArray:(NSArray*)heroArr withDelegate:(id)delegate;
-(void)showInTheView:(UIView*)view;
-(void)closeSelf;
@end
