//
//  M3U8Tool.h
//  MyDota
//
//  Created by Xiang on 15/10/17.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M3U8Tool : NSObject
+(void)m3u8UrlWithUrl:(NSString*)htmlUrl complised:(void(^)(NSString* m3u8Url))block;
+(NSString*)typeNameOfM3U8:(NSString*)m3u8Str;
+(NSString *)encode:(NSData *)data;
+(NSData *)decode:(NSString *)data;
@end



