//
//  cofig.pch
//  MyDota
//
//  Created by Simplan on 14-7-31.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

@interface UIImage (webImage)
+(void)imageWithUrl:(NSString*)urlStr complish:(void (^)(UIImage* image))finish;
@end

@implementation UIImage (webImage)

+(void)imageWithUrl:(NSString*)urlStr complish:(void (^)(UIImage* image))finish{
    ASIFormDataRequest *reque = [[ASIFormDataRequest alloc ]initWithURL:[NSURL URLWithString:urlStr]];
//    reque.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
    reque.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    [reque setDownloadCache:[ASIDownloadCache sharedCache]];
    
    [reque setCompletionBlock:^{
        UIImage *img = [UIImage imageWithData:reque.responseData];
        finish(img);
    }];
    [reque setFailedBlock:^{
        NSLog(@"fail image");
    }];
    [reque startAsynchronous];
}

@end



