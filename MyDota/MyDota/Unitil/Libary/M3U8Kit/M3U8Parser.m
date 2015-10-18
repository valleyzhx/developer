//
//  M3U8Parser.m
//  M3U8Kit
//
//  Created by Oneday on 13-1-11.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "M3U8Parser.h"
#import "M3U8SegmentInfoList.h"
#import "NSString+m3u8.h"

@implementation M3U8Parser

+ (M3U8SegmentInfoList *)m3u8SegmentInfoListFromPlanString:(NSString *)m3u8String {
    return [m3u8String m3u8SegementInfoListValue];
}

+ (M3U8SegmentInfoList *)m3u8SegmentInfoListFromData:(NSData *)m3u8Data {
    NSString *m3u8String = [[[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding] autorelease];
    return [self m3u8SegmentInfoListFromPlanString:m3u8String];
}

@end
