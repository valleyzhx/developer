//
//  MyXmlPraser.h
//  MyDota
//
//  Created by Simplan on 14-5-26.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyXmlData.h"
@protocol MyXmlPraserDelegate <NSObject>
@required
-(void)finishPraseWithResultArray:(NSArray*)array;
-(void)praseFailed;

@end

@interface MyXmlPraser : NSObject<NSXMLParserDelegate>
@property (nonatomic,assign)id<MyXmlPraserDelegate>delegate;
-(id)initWithXMLData:(NSData*)data;
-(void)startPrase;
@end
