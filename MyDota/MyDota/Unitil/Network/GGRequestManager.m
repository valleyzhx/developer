//
//  GGRequestManager.m
//  MyDota
//
//  Created by Xiang on 15/10/16.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGRequestManager.h"

@implementation GGRequestManager{
    NSMutableArray *_observArr;
}
static GGRequestManager *_manger = nil;

+(id)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _manger = [[GGRequestManager alloc]init];
    });
    return _manger;
}

-(void)addRequestObserver:(GGRequestObserver *)observer{
    if (_observArr == nil) {
        _observArr = [NSMutableArray array];
    }
    [_observArr addObject:observer];
}

-(void)sendMessagewithType:(GGRequestType)type response:(id)object{
    for (GGRequestObserver *obser in _observArr) {
        if (obser.successBlock) {
            obser.successBlock(type,object);
        }
    }
}
-(void)removeAllObserver{
    [_observArr removeAllObjects];
}

-(void)removeRequestObser:(GGRequestObserver *)observer{
    if (observer&&[_observArr containsObject:observer]) {
        [_observArr removeObject:observer];
    }
}

-(void)dealloc{
    _observArr = nil;
}



@end
