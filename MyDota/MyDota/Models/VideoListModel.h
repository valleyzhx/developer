//
//  VideoListModel.h
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "MTModel+GGRequest.h"
#import "VideoModel.h"


@interface VideoListModel : MTLHALResource  

@property (nonatomic,assign)int total;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)NSArray <VideoModel*>*videos;
@property (nonatomic,strong)NSString *last_item;

+(void)getVideoListBy:(NSString*)url complish:(void(^)(id))finished;


@end
