//
//  VideoModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTModel+GGRequest.h"

@interface VideoModel : MTLHALResource

@property (nonatomic,strong)NSString *VideoModelID;

@property (nonatomic,strong)NSString *videoId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *link;
@property (nonatomic,strong)NSString *thumbnail;
@property (nonatomic,strong)NSString *duration;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *published;
@property (nonatomic,strong)NSString *public_type;
@property (nonatomic,strong)NSNumber *view_count;
@property (nonatomic,strong)NSNumber *favorite_count;
@property (nonatomic,strong)NSNumber *comment_count;
@property (nonatomic,strong)NSNumber *up_count;
@property (nonatomic,strong)NSNumber *down_count;
@property (nonatomic,assign)BOOL isinteract;

@property (nonatomic,strong)NSArray *streamtypes;
@property (nonatomic,strong)NSArray *operation_limit;


@end
