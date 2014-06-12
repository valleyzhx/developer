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
    NSXMLParser *parser;
    MyXmlData *myData;
    NSMutableArray *contentArray;
    BOOL canCreatData;
    NSString *tempString;
}
-(id)initWithXMLData:(NSData *)data{
    if (self =[super init]) {
         parser= [[NSXMLParser alloc]initWithData:data];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        [parser setDelegate:self];
        contentArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}
-(void)startPrase{
    [parser parse];
}
static NSString * const kItemKey = @"item";
static NSString * const kItemTitleKey = @"title";
static NSString * const kItemLinkKey = @"link";
static NSString * const kItemPubDate = @"pubDate";
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
    if ([elementName isEqualToString:kItemPubDate]) {
        myData.pubDate = tempString;
        canCreatData = NO;
        [contentArray addObject:myData];
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_delegate finishPraseWithResultArray:contentArray];
}
@end
