//
//  BaseViewController+GGRequest.h
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (GGRequest)
-(void)loadDataWithUrl:(NSString*)url requestTag:(int)tag;


-(void)finishLoadWithTag:(int)tag data:(id)responseObject error:(NSError*)error;
@end
