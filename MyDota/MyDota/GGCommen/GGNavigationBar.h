//
//  GGNavigationBar.h
//  MyDota
//
//  Created by Xiang on 15/10/15.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GGNavigationBarType){
    GGNavigationBarTypeNormal = 0,
    GGNavigationBarTypeCustom = 1,
};
@interface GGNavigationBar : UIView


@property (nonatomic,strong,readonly) UIImageView *backgroundView;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;


@end
