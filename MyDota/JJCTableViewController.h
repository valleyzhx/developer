//
//  JJCTableViewController.h
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTableScollDelegate.h"

@interface JJCTableViewController : UITableViewController
@property(nonatomic,assign)id<ScoreTableScollDelegate>scoreDelegate;
@end
