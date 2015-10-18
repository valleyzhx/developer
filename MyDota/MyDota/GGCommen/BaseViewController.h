//
//  BaseViewController.h
//  MyDota
//
//  Created by Xiang on 15/8/6.
//  Copyright (c) 2015年 iGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGNavigationBar.h"
#import "MJRefresh.h"
#define orgX 16

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    int pageIndex;
    int totalPage;
    GGNavigationBar *naviBar;
}

@property (nonatomic,assign) BOOL noTable;
@property (nonatomic,strong) UITableView *tableView;



@end
