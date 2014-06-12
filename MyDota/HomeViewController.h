//
//  HomeViewController.h
//  MyDota
//
//  Created by Simplan on 14-4-30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyXmlPraser.h"
@interface HomeViewController : UIViewController<MyXmlPraserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listTable;

@end
