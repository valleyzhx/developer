//
//  CommentListModel.m
//  MyDota
//
//  Created by Xiang on 16/1/18.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "CommentListModel.h"
#import "MTModel+GGRequest.h"

@implementation CommentModel{
    NSString *_modelID;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [super JSONKeyPathsByPropertyKey].mutableCopy;
    
    [keyPaths addEntriesFromDictionary:@{
                                         @"modelID": @"id",
                                         @"userId": @"user.id",
                                         @"userName":@"user.name",
                                         @"userLink": @"user.link",
                                         }];
    
    return keyPaths;
}

#pragma mark MTLModelFMDBDelegate
-(void)setModelID:(NSString *)modelID{
    _modelID = modelID;
}
-(NSString *)modelID{
    return _modelID;
}

@end




@implementation CommentListModel

+ (NSValueTransformer *)commentsJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CommentModel class]];
}


+(void)getHotCommentsWithVideoId:(NSString *)videoId page:(int)page complish:(void (^)(id))finished{
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/comments/hot/by_video.json?client_id=e2306ead120d2e34&video_id=%@&page=%d",videoId,page];
    [self startRequestWithUrl:url complish:finished];
}

+(void)getCommentsWithVideoId:(NSString *)videoId page:(int)page complish:(void (^)(id))finished{
    NSString *url = [NSString stringWithFormat:@"https://openapi.youku.com/v2/comments/by_video.json?client_id=e2306ead120d2e34&video_id=%@&page=%d",videoId,page];
    [self startRequestWithUrl:url complish:finished];
}

@end
