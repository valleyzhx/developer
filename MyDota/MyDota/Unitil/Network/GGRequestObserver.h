//
//  GGRequestObserver.h
//  MyDota
//
//  Created by Xiang on 15/10/16.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,GGRequestType) {
    GGRequestTypeError = -1,
    GGRequestTypeDotaJSFinished = 0,
    GGRequestTypeDota2JSFinished =1,
};
typedef void(^ObserverBlock)(GGRequestType type,id object);


@interface GGRequestObserver : NSObject
@property (nonatomic,copy,readonly)ObserverBlock successBlock;
/**
 *  构造Observer，需要强引用以便最后销毁
 *
 *  @param finished observer收到通知后执行的block
 *
 *  @return GGObserver的实例
 */
+(id)observerReqeust:(ObserverBlock)finished;

/**
 *  销毁方法，注意不在需要监听时一定要销毁
 */
-(void)remove;

@end
