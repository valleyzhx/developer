//
//  TVRequest.h
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVRequest : NSObject
+(void)loadTVList:(NSString*)url done:(void(^)(id result))success;
@end
