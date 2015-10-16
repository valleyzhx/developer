//
//  DeviceInfo.m
//  AFNetworking iOS Example
//
//  Created by Simplan on 15/3/25.
//  Copyright (c) 2015年 Gowalla. All rights reserved.
//

#import "DeviceInfo.h"
#import "sys/utsname.h"
#import "Reachability.h"

@implementation DeviceInfo

+(NSString*)iOSVersion{
    return [[UIDevice currentDevice]systemVersion];
}
+(NSString*)deviceUUID{
    return [SvUDIDTools UDID];
}
+(NSString*)deviceMode{
    //http: //theiphonewiki.com/wiki/Models
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    if ([deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iphone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iphone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"]||[deviceString isEqualToString:@"iphone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"]||[deviceString isEqualToString:@"iPad3,2"]||[deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"]||[deviceString isEqualToString:@"iPad3,5"]||[deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"]||[deviceString isEqualToString:@"iPad4,2"]||[deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"]||[deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad2,5"]||[deviceString isEqualToString:@"iPad2,6"]||[deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini 1G";
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3G";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

+(NSString *)screenResolution{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    return [NSString stringWithFormat:@"%.0f*%.0f",height,width];
}
+(NSString *)netWorkStatus{
    NSString *netMode;
    Reachability *netReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus netStatus = [netReachable currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
        {
            netMode = @"nonet";
        }
            break;
        case ReachableViaWiFi:
        {
            netMode = @"wifi";
        }
            break;
        case ReachableViaWWAN:
        {
            netMode = @"3g";
        }
            break;
        default:
            netMode=@"";
            break;
    }
    return netMode;
}



+(NSString*)appVersion{
   return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
}




@end
