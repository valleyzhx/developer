//
//  CommentListModel.h
//  MyDota
//
//  Created by Xiang on 16/1/18.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import <Mantle-HAL/Mantle-HAL.h>
#import "MTModelFMDBDelegate.h"

@interface CommentModel :MTLHALResource <MTModelFMDBDelegate>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *published;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userLink;

@end






@interface CommentListModel : MTLHALResource

@property (nonatomic,assign)int total;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)NSString *video_id;
@property (nonatomic,strong)NSArray <CommentModel*>*comments;


+(void)getHotCommentsWithVideoId:(NSString*)videoId page:(int)page complish:(void(^)(id))finished;

+(void)getCommentsWithVideoId:(NSString *)videoId page:(int)page complish:(void (^)(id))finished;

@end
