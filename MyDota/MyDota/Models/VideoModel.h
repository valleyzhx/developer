//
//  VideoModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTModel+GGRequest.h"
#import "MTModelFMDBDelegate.h"

@interface VideoModel : MTLHALResource<MTModelFMDBDelegate>

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *link;
@property (nonatomic,strong)NSString *thumbnail;
@property (nonatomic,strong)NSString *duration;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *published;
@property (nonatomic,strong)NSString *public_type;
@property (nonatomic,assign)int view_count;
@property (nonatomic,assign)int favorite_count;
@property (nonatomic,assign)int comment_count;
@property (nonatomic,assign)int up_count;
@property (nonatomic,assign)int down_count;
//@property (nonatomic,assign)BOOL isinteract;

//@property (nonatomic,strong)NSArray *streamtypes;
//@property (nonatomic,strong)NSArray *operation_limit;

@property (nonatomic,strong)NSString *userid;

@property (nonatomic,strong)NSString *userDicId;
@property (nonatomic,strong)NSString *userDicName;

@end
