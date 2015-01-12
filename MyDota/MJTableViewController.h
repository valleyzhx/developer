//
//  MJTableViewController.h
//  MyDota
//
//  Created by Simplan on 14/11/22.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTableScollDelegate.h"
#import "ScoreData.h"

@interface MJTableViewController : UITableViewController
@property(nonatomic,strong)ScoreData *data;
@end
