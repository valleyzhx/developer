//
//  GGRequestObserver.m
//  MyDota
//
//  Created by Xiang on 15/10/16.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "GGRequestObserver.h"
#import "GGRequestManager.h"

@interface GGRequestObserver ()
@end


@implementation GGRequestObserver
+(id)observerReqeust:(ObserverBlock)finished{
    GGRequestObserver *obser = [[GGRequestObserver alloc]initWithBlock:finished];
    [[GGRequestManager sharedManager]addRequestObserver:obser];
    return obser;
}

-(id)initWithBlock:(ObserverBlock)finished{
    if (self = [super init]) {
        _successBlock = finished;
    }
    return self;
}

-(void)remove{
    [[GGRequestManager sharedManager]removeRequestObser:self];
}

-(void)dealloc{
    _successBlock = nil;
}

@end
