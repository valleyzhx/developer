//
//  HomeViewController.m
//  MyDota
//
//  Created by Simplan on 14-4-30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HomeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "VideoViewController.h"
#import "MyLoadingView.h"
#import "MJRefresh.h"
#import "LoadingView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    //NSArray *dataArray;
    int currentCount;
    NSMutableArray *dicsArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dicsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSString*)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [NSString stringWithFormat:@"%@/dota.html",[paths objectAtIndex:0]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:_listTable];
    currentCount = 0;
    //[self loadXmlFile];
    [self loadHtml];
    [_listTable addFooterWithTarget:self action:@selector(refreshTheTable)];
    //[_listTable addHeaderWithTarget:self action:@selector(loadXmlFile)];
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, screenHeight-80, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = 101;
    [self.view addSubview:backBtn];
}
-(void)loadHtml{
    
    NSString *string = [[NSString alloc]initWithContentsOfFile:[self getPath] encoding:NSUTF8StringEncoding error:nil];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"href=\"http://dota.uuu9.com/\\d+(.*)\" title=.*>(.*)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *strArr = [NSMutableArray array];
    for (NSTextCheckingResult *st in array) {
        NSString *s = [string substringWithRange:st.range];
        NSArray *contentArr = [s componentsSeparatedByString:@"\""];
        NSString *href = contentArr[1];
        NSString *title = contentArr[3];
        if ([strArr containsObject:href]){
            continue;
        }
        [strArr addObject:href];
        NSDictionary *dic = @{@"href":href,@"title":title};
        [dicsArray addObject:dic];
        
    }
    [[MyLoadingView shareLoadingView]stopWithFinished:^{
                //dataArray = [[NSArray alloc]initWithArray:array];
                currentCount = MIN(15, (int)dicsArray.count);
                [_listTable reloadData];
                [_listTable headerEndRefreshing];
            }];
    
}

//-(void)loadXmlFile
//{
//    NSData *data = [NSData dataWithContentsOfFile:[self getPath]];
//    MyXmlPraser *parser = [[MyXmlPraser alloc]initWithXMLData:data];
//    parser.delegate = self;
//    [parser startPrase];
//    
//}
-(void)refreshTheTable
{
    if (currentCount<dicsArray.count) {
        currentCount = MIN((int)dicsArray.count, currentCount+10);
    }else{
        [_listTable footerEndRefreshing];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_listTable reloadData];
        [_listTable footerEndRefreshing];
    });
}
//#pragma  mark myxmlpraserdelegate
//-(void)finishPraseWithResultArray:(NSArray *)array
//{
//    [[MyLoadingView shareLoadingView]stopWithFinished:^{
//        dataArray = [[NSArray alloc]initWithArray:array];
//        currentCount = MIN(15, (int)dataArray.count);
//        [_listTable reloadData];
//        [_listTable headerEndRefreshing];
//    }];
//    
//}
//-(void)praseFailed{
//    
//}
#pragma mark tableviewdelegate And datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *dateLab;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        dateLab = [[UILabel alloc]initWithFrame:CGRectMake(16, cell.contentView.frame.size.height-10, 100, 10)];
        dateLab.font = [UIFont systemFontOfSize:10];
        dateLab.textColor = [UIColor grayColor];
        //[cell.contentView addSubview:dateLab];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *data = dicsArray[indexPath.row];
    if (screenWidth>320) {
      cell.textLabel.font = [UIFont systemFontOfSize:13];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    
      cell.textLabel.text = [NSString stringWithFormat:@" %@",data[@"title"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *data = dicsArray[indexPath.row];
    
    NSString *url = data[@"href"];
    ASIHTTPRequest* requset = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *req = requset;
    __weak HomeViewController *selContrl = self;
    [req setCompletionBlock:^{
        NSString *str = req.responseString;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\bhttp://player.youku.com\\b.*\\bswf\\b" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *array = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        NSString *youkuStr;
        for (NSTextCheckingResult* b in array)
        {
            youkuStr = [str substringWithRange:b.range];
        }
        if (array.count==0) {
            NSArray *arr = [str componentsSeparatedByString:@"<script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">"];
            if (arr.count==1) {
                LoadingView *view = [[LoadingView alloc]initWithString:@"iOS暂不支持此视频,请观看其他视频"];
                [view show];
                return ;
            }
            NSArray *secArr = [[arr objectAtIndex:1]componentsSeparatedByString:@"<"];
            youkuStr = secArr[0];
            VideoViewController *videoVC = [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil yukuPlayer:youkuStr];
            videoVC.title = data[@"title"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
            [selContrl presentViewController:nav animated:YES completion:^{
                
            }];
            return ;
        }
        LoadingView *view = [[LoadingView alloc]initWithString:@"iOS暂不支持此视频,请观看其他视频"];
        [view show];
//        videoVC = [[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
//        videoVC.title = data[@"title"];
//        [self presentViewController:nav animated:YES completion:^{
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"flash" ofType:@"html"]]];
//            [videoVC.webView loadRequest:request];
//        }];
        
    }];
    [req setFailedBlock:^{
        
    }];
    [req startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UIButton *btn = (UIButton*)[self.view viewWithTag:101];
    btn.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn = (UIButton*)[self.view viewWithTag:101];
    btn.hidden = NO;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)dealloc
{
    //dataArray = nil;
    dicsArray = nil;
}
-(void)backAction:(UIButton*)btn{
    
    btn.hidden = YES;
    float y = 0;
    if (!iOS7) {
        y = -20;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width*1.5, self.view.center.y+y);
        self.view.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}
@end
