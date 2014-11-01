//
//  DotaHeroBar.h
//  TestParseHTML
//
//  Created by Simplan on 14-6-12.
//  Copyright (c) 2014年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DotaHeroBar : NSObject
@property (nonatomic,strong)NSString *barName;
@property (nonatomic,strong)NSMutableArray *heroArray;
@end

@interface DotaHero : NSObject
@property (nonatomic,strong)NSString *heroName;
@property (nonatomic,strong)NSString *dataUrl;
@property (nonatomic,strong)NSString *imgUrl;
@end

@interface UIImage (webImage)
+(id)imageWithUrl:(NSString*)urlStr;
@end

