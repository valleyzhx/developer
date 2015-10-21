//
//  VideoListModel.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel

+(void)getVideoListBy:(NSString *)url complish:(void (^)(id))finished{
    [self startRequestWithUrl:url complish:finished];
}



@end


