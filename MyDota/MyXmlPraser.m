//
//  MyXmlPraser.m
//  MyDota
//
//  Created by Simplan on 14-5-26.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "MyXmlPraser.h"

@implementation MyXmlPraser
{
    NSXMLParser *parsering;
    MyXmlData *myData;
    NSMutableArray *contentArray;
    BOOL canCreatData;
    NSString *tempString;
}
-(id)initWithXMLData:(NSData *)data{
    if (self =[super init]) {
         parsering= [[NSXMLParser alloc]initWithData:data];
        [parsering setShouldProcessNamespaces:NO];
        [parsering setShouldReportNamespacePrefixes:NO];
        [parsering setShouldResolveExternalEntities:NO];
        [parsering setDelegate:self];
        contentArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
-(void)startPrase{
    [parsering parse];
}
#define kItemKey  @"item"
#define kItemTitleKey  @"title"
#define kItemLinkKey  @"link"
#define kItemPubDate  @"pubDate"
#define kItemDescription @"description"
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:kItemKey]) {
        canCreatData = YES;
        myData = [[MyXmlData alloc]init];
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (canCreatData) {
        tempString = [NSString stringWithString:string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if (canCreatData == NO) {
        return;
    }
    if ([elementName isEqualToString:kItemTitleKey]) {
        
        myData.title = tempString;
    }
    if ([elementName isEqualToString:kItemLinkKey]) {
        myData.urlStr = tempString;
    }
    
    if ([elementName isEqualToString:kItemDescription]) {
        tempString = [tempString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([tempString hasPrefix:@"player = new YKU.Player"]) {
            myData.player = tempString;
        }
    }
    if ([elementName isEqualToString:kItemPubDate]) {
        myData.pubDate = tempString;
        int year = tempString.intValue;
        if (year<2014) {
            //[_delegate praseFailed];
            [parsering abortParsing];
        }
        canCreatData = NO;
        if (myData.player) {
            [contentArray addObject:myData];
        }
        
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_delegate finishPraseWithResultArray:contentArray];
}
@end
