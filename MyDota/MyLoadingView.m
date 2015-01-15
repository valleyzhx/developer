//
//  MyLoadingView.m
//  MyDota
//
//  Created by Simplan on 14/6/7.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "MyLoadingView.h"
#import "SCGIFImageView.h"
@implementation MyLoadingView
static MyLoadingView* shareLoading;
+(id)shareLoadingView
{
    if (shareLoading == nil) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"sf.gif" ofType:nil];
        SCGIFImageView* gifImageView = [[SCGIFImageView alloc] initWithGIFFile:filePath];
        gifImageView.frame = CGRectMake(0, 0, gifImageView.image.size.width/4, gifImageView.image.size.height/4);
        shareLoading = [[MyLoadingView alloc]initWithFrame:gifImageView.frame];
        [shareLoading addSubview:gifImageView];
        shareLoading.layer.cornerRadius = 15;
        shareLoading.layer.masksToBounds = YES;
        shareLoading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    return shareLoading;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}
-(void)showLoadingIn:(UIView *)view
{
    shareLoading.center = view.center;
    
    [view addSubview:shareLoading];
}
-(void)stopWithFinished:(void (^)(void))finish
{
    [UIView animateWithDuration:1 animations:^{
        shareLoading.alpha = 0.2;
        
    } completion:^(BOOL finished) {
        shareLoading.alpha = 1;
        [shareLoading removeFromSuperview];
        finish();
    }];
    
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
