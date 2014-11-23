//
//  ScoreData.h
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreData : NSObject
@property (nonatomic,strong)NSString *rating;
@property (nonatomic,strong)NSString *rank;
@property (nonatomic,strong)NSString *jjcRating;
@property (nonatomic,strong)NSArray *rankInfos;
@property (nonatomic,strong)NSDictionary *ttInfos;
@property (nonatomic,strong)NSDictionary *mjInfos;
@property (nonatomic,strong)NSArray *mjheroInfos;
@property (nonatomic,strong)NSDictionary *jjcInfos;
-(id)initWith11Dic:(NSDictionary*)dic;
@end
