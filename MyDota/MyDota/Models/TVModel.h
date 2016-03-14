//
//  TVModel.h
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import <Mantle-HAL/Mantle-HAL.h>
#import "MTModelFMDBDelegate.h"

@interface TVModel : MTLHALResource <MTModelFMDBDelegate>

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *gameId;
@property (nonatomic,strong) NSString *spic;
@property (nonatomic,strong) NSString *bpic;
@property (nonatomic,strong) NSString *online;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *liveTime;
@property (nonatomic,strong) NSString *hotsLevel;
@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *positionType;
@property (nonatomic,strong) NSString *gameName;
@property (nonatomic,strong) NSString *gameUrl;
@property (nonatomic,strong) NSString *gameIcon;

@property (nonatomic,assign) int follows;
@property (nonatomic,assign) int highlight;
@property (nonatomic,assign) int guddesslight;




@end
