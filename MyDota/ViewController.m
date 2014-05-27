//
//  ViewController.m
//  MyDota
//
//  Created by Simplan on 14-4-17.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    HomeViewController *homeView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self.view addSubview:homeView.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
