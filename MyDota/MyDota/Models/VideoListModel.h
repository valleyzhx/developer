//
//  VideoListModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTModel+GGRequest.h"


@interface VideoListModel : MTLHALResource
@property (nonatomic,strong)NSNumber *total;
@property (nonatomic,strong)NSNumber *page;
@property (nonatomic,strong)NSNumber *count;
@property (nonatomic,strong)NSArray *videos;
@property (nonatomic,strong)NSString *last_item;

+(void)getVideoListBy:(NSString*)url complish:(void(^)(id))finished;


@end
