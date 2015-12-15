//
//  MBProgressHUD+string.m
//  MyDota
//
//  Created by Xiang on 15/12/10.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MBProgressHUD+string.h"

@implementation MBProgressHUD (string)

+(void)showString:(NSString *)title inView:(UIView *)view font:(UIFont*)font{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.labelFont = font;
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+(void)showString:(NSString *)title inView:(UIView *)view{
    [self showString:title inView:view font:[UIFont systemFontOfSize:14]];
}


@end
