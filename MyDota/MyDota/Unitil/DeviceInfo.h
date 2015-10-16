//
//  DeviceInfo.h
//  AFNetworking iOS Example
//
//  Created by Simplan on 15/3/25.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SvUDIDTools.h"

@interface DeviceInfo : NSObject

+(NSString*)deviceUUID;
+(NSString*)deviceMode;
+(NSString*)iOSVersion;
+(NSString*)screenResolution;
+(NSString*)netWorkStatus;
+(NSString*)appVersion;
@end
