//
//  TVListModel.h
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import <Mantle-HAL/Mantle-HAL.h>
#import "TVModel.h"

@interface TVListModel : MTLHALResource

@property (nonatomic,assign) int cnt;
@property (nonatomic,strong) NSArray<TVModel *>* rooms;


+(void)loadTVList:(NSString*)url complish:(void (^)(id))finished;



@end
