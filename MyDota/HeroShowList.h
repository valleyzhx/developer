//
//  HeroShowList.h
//  MyDota
//
//  Created by Simplan on 15/1/2.
//  Copyright (c) 2015年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol heroShowListDelegate <NSObject>

-(void)changeToVideo:(NSString*)youkuString;

@end

@interface HeroShowList : UIScrollView
@property(nonatomic,assign)id<heroShowListDelegate> heroDelegate;
-(id)initWithHeroVideosArray:(NSArray*)arr;

-(void)showInTheView:(UIView*)view;
@end
