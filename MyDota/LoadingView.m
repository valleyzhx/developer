//
//  LoadingView.m
//  Map
//
//  Created by yiwugou on 13-3-20.
//  Copyright (c) 2013年 LEEMO. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 70, 60)];
    if (self)
    {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        UIActivityIndicatorView*  activew = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activew.center = self.center;
        [activew startAnimating];
        [self addSubview:activew];
        
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;

        // Initialization code
    }
    return self;

}


-(void)startLoading
{
    UIWindow* window =  [UIApplication sharedApplication].keyWindow;
    self.center = CGPointMake(window.center.x, window.center.y-10);
   NSLog(@"center is %@",NSStringFromCGPoint(self.center));
    [window addSubview:self];

}

-(id)initWithFailView
{
    self = [super initWithFrame:CGRectMake(0, 0, 250, 60)];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;

        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"未能连接到服务器";
        [self addSubview:label];

    }
    return self;
}

-(void)show
{
    UIWindow* window =  [UIApplication sharedApplication].keyWindow;
    self.center = CGPointMake(window.center.x, window.center.y-20);
    [window addSubview:self];
    
    [UIView animateWithDuration:2.6 animations:^{
        self.alpha = 0.99;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
       // [self release];
    }];
    
}

-(id)initWithString:(NSString*)str
{
    CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:24]];
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height+15)];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        UILabel* label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = str;
        [self addSubview:label];
        
    }
    return self;


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
