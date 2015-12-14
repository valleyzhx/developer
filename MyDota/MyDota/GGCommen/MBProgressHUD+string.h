//
//  MBProgressHUD+string.h
//  MyDota
//
//  Created by Xiang on 15/12/10.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (string)

+(void)showString:(NSString*)title inView:(UIView*)view;
+(void)showString:(NSString *)title inView:(UIView *)view font:(UIFont*)font;

@end
