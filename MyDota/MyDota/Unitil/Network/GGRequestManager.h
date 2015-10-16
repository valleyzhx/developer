//
//  GGRequestManager.h
//  MyDota
//
//  Created by Xiang on 15/10/16.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRequestObserver.h"



@interface GGRequestManager : NSObject

+(id)sharedManager;
-(void)addRequestObserver:(GGRequestObserver*)observer;
-(void)sendMessagewithType:(GGRequestType)type response:(id)object;

-(void)removeAllObserver;
-(void)removeRequestObser:(GGRequestObserver*)observer;

@end
