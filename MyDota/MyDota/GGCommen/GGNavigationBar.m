//
//  GGNavigationBar.m
//  MyDota
//
//  Created by Xiang on 15/10/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGNavigationBar.h"
#define navOrgY 20
#define naviHeight 48

@implementation GGNavigationBar{
    UILabel *_titleLab;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, navOrgY, 100, naviHeight)];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self refrshTheTitleFrame];
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _titleLab.textColor = titleColor;
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    _titleLab.font = titleFont;

}
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}

-(void)refrshTheTitleFrame{
    CGSize size = [_titleLab.text sizeWithAttributes:@{NSFontAttributeName:_titleLab.font}];
    _titleLab.frame = CGRectMake(0, 0, size.width+5, _titleLab.frame.size.height);
    _titleLab.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+navOrgY/2);
}

-(void)setRightView:(UIView *)rightView{
    if (_rightView) {
        [_rightView removeFromSuperview];
    }
    _rightView = nil;
    _rightView = rightView;
    if (_rightView) {
        _rightView.center = CGPointMake(self.frame.size.width-_rightView.frame.size.width/2-5, self.frame.size.height/2+navOrgY/2);
        [self addSubview:_rightView];
    }
}
-(void)setLeftView:(UIView *)leftView{
    if (_leftView) {
        [_leftView removeFromSuperview];
    }
    _leftView = nil;
    _leftView = leftView;
    if (_leftView) {
        _leftView.center = CGPointMake(_leftView.frame.size.width/2+10, self.frame.size.height/2+navOrgY/2);
        [self addSubview:_leftView];
    }
}



-(void)dealloc{
    _titleLab = nil;
}

@end
