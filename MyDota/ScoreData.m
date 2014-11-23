//
//  ScoreData.m
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ScoreData.h"

@implementation ScoreData
-(id)initWith11Dic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        if (dic[@"mjInfos"]) {
            _mjInfos = [[NSDictionary alloc]initWithDictionary:dic[@"mjInfos"]];
        }
        if (dic[@"ttInfos"]) {
            _ttInfos = [[NSDictionary alloc]initWithDictionary:dic[@"ttInfos"]];
        }
    
        if ([dic[@"jjcInfos"] isKindOfClass:[NSDictionary class]]) {
            _jjcInfos = [[NSDictionary alloc]initWithDictionary:dic[@"jjcInfos"]];
        }
        if ([dic[@"mjheroInfos"] isKindOfClass:[NSArray class]]) {
            _mjheroInfos = [[NSArray alloc]initWithArray:dic[@"mjheroInfos"]];
        }
        if ([dic[@"rankInfos"] isKindOfClass:[NSArray class]]) {
            _rankInfos = [[NSArray alloc]initWithArray:dic[@"rankInfos"]];
        }
        if (dic[@"rating"]) {
            _rating = [NSString stringWithFormat:@"%@",dic[@"rating"]];
        }
        if (dic[@"rank"]) {
            _rank = [NSString stringWithFormat:@"%@",dic[@"rank"]];
        }
        if (dic[@"jjcRating"]) {
            _rating = [NSString stringWithFormat:@"%@",dic[@"jjcRating"]];
        }
        
        
        
        
        
    }
    return self;
}
@end
