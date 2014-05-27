//
//  HomeViewController.m
//  MyDota
//
//  Created by Simplan on 14-4-30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HomeViewController.h"
#import "ASIHTTPRequest.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSArray *dataArray;
    int currentCount;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentCount = 0;
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:@"http://dota.uuu9.com/rss.xml"]];
    [request setDidFailSelector:@selector(failMethod:)];
    [request setDidFinishSelector:@selector(finishMethod:)];
    [request setDelegate:self];
    [request startSynchronous];
}
-(void)failMethod:(ASIHTTPRequest*)request
{
    NSLog(@"fail");
}
-(void)finishMethod:(ASIHTTPRequest*)request
{
    NSData *data = request.responseData;
    NSLog(@"---%@",request.responseString);
    MyXmlPraser *parser = [[MyXmlPraser alloc]initWithXMLData:data];
    parser.delegate = self;
    [parser startPrase];
}
#pragma myxmlpraserdelegate
-(void)finishPraseWithResultArray:(NSArray *)array
{
    dataArray = [[NSArray alloc]initWithArray:array];
    currentCount = MIN(15, dataArray.count);
    [_listTable reloadData];
}
#pragma tableviewdelegate And datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MyXmlData *data = dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",data.title,data.pubDate];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
