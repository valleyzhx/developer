//
//  M3U8Tool.m
//  MyDota
//
//  Created by Xiang on 15/10/17.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "M3U8Tool.h"
#import "UMOnlineConfig.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@interface M3U8Tool ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *web;
@property (nonatomic,strong) NSString *type;

@end


@implementation M3U8Tool{
    void (^finished)(NSString*);
    NSString *_lHtml;
}

+(id)m3u8UrlWithUrl:(NSString *)htmlUrl type:(NSString *)type complised:(void (^)(NSString *))block{
    
    M3U8Tool *tool = [[M3U8Tool alloc]init];
    tool.type = type;
    [tool requesetUrl:htmlUrl complised:block];
    return tool;
}
-(instancetype)init{
    if (self = [super init]) {
        _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _web.delegate = self;
    }
    return self;
}

-(void)requesetUrl:(NSString*)url complised:(void (^)(NSString *))block{
    finished = nil;
    finished = block;
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:8]];
    [self performSelector:@selector(myDelayedMethod) withObject:nil afterDelay:7];
}

-(void)myDelayedMethod{
    
    if (_lHtml.length == 0) {
        if (finished) {
            finished(nil);
        }
    }
}

+(NSString *)typeNameOfM3U8:(NSString *)m3u8Str{
    NSArray *arr = [m3u8Str componentsSeparatedByString:@"type="];
    if (arr.count>1) {
        NSString *type = [arr[1]componentsSeparatedByString:@"&"][0];
        return type;
    }
    return nil;
}

-(void)removeDelayMethod{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector:@selector(myDelayedMethod) object: self];
}


#pragma mark --- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{

}




- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *videoJS = [UMOnlineConfig getConfigParams:kVideojs];
    NSString *lJs = [videoJS stringByAppendingFormat:@"getVideoM3u8('%@');",_type];
    _lHtml = [webView stringByEvaluatingJavaScriptFromString:lJs];
        if (finished) {
            finished(_lHtml);
            finished = nil;
        }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == -999) {
        return;
    }
    if (finished) {
        finished(nil);
        finished = nil;
    }
}
-(void)dealloc{
    [self removeDelayMethod];
}









#pragma mark - base64
+(NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;
    
    char *characters = malloc(data.length * 3 / 2);
    
    if (characters == NULL)
        return nil;
    
    int end = (int)data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
    
}

+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = (int)data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

@end
