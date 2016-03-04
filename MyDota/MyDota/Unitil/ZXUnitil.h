//
//  ZXUnitil.h
//  auto-jd
//
//  Created by Xiang on 15/4/27.
//  Copyright (c) 2015年 lsx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXUnitil : NSObject
+ (BOOL)isIPAddress:(NSString*)ipString;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL) isIdentityCard: (NSString *)identityCard;
+ (void)fitTheLabel:(UILabel*)label;
+ (float)heightOfStringWithString:(NSString*)str font:(UIFont*)font width:(float)width;
+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height;
+ (BOOL)version:(NSString *)oldver lessthan:(NSString *)newver;
+ (NSString*)abNameWithProvince:(NSString*)province;
+ (NSString*)halfWithStringFromFullString:(NSString*)string;
+(void)startAnimation:(UIView*)view delay:(float)delay finised:(void (^)(void))finishedBlock;

+(NSDictionary*)urlQueryDicWithQueryString:(NSString*)query;

@end

@interface UIView (virtualLine)
-(void)changeVirLineColor:(UIColor*)color;
-(void)addVirLineWithColor:(UIColor *)color;
@end

@interface UITableView (HiddenExtraCellLine)

-(void)setHiddenExtrLine:(BOOL)shouldHidden;
@end

@interface NSString (json)
-(id)jsonObject;
@end

@interface NSData (json)
-(id)jsonObject;
@end

@interface NSObject (json)
-(NSString*)jsonString;
@end





