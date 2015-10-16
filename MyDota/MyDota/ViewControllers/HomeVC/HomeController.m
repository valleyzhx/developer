//
//  HomeController.m
//  MyDota
//
//  Created by Xiang on 15/10/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "HomeController.h"
#import "GGRequest.h"
#import "ImagePlayerView.h"
#import "UIImageView+AFNetworking.h"
#import "MyDefines.h"

#define rowAd 180

@interface HomeController ()<ImagePlayerViewDelegate>

@end

@implementation HomeController{
    GGRequestObserver *_reqeustObserver;
    NSDictionary *_dotaDic;
    NSDictionary *_dota2Dic;
    
    ImagePlayerView *_imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    naviBar.title = @"DotA";
    _reqeustObserver = [GGRequestObserver observerReqeust:^(GGRequestType type, id object) {
        if (object == nil) {
            [self loadDownLoadJSData:type];
            [self.tableView reloadData];
            return ;
        }
        if (type == GGRequestTypeDotaJSFinished) {
            _dotaDic = object;
        }else if (type == GGRequestTypeDota2JSFinished){
            _dota2Dic = object;
        }
        [self.tableView reloadData];
    }];
    self.tableView.footer = nil;
}
-(void)loadDownLoadJSData:(GGRequestType)type{
    NSString *path = [GGRequest dotaJSPathWithType:type];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (type == GGRequestTypeDota2JSFinished) {
        _dota2Dic = str.jsonObject;
    }else{
        _dotaDic = str.jsonObject;
    }
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark tableViewDataSource --- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return rowAd;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {//ad
        cell = [tableView dequeueReusableCellWithIdentifier:@"ADCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADCell"];
            _imgView = [[ImagePlayerView alloc]initWithFrame:cell.contentView.bounds];
            _imgView.imagePlayerViewDelegate = self;
            _imgView.scrollInterval = 3;
            [cell.contentView addSubview:_imgView];
        }
        _imgView.frame = CGRectMake(0, naviBar.frame.size.height, SCREEN_WIDTH, cell.contentView.bounds.size.height-naviBar.frame.size.height);
        [_imgView reloadData];
    }
    return cell;
}














#pragma mark - ImagePlayerViewDelegate

- (NSInteger)numberOfItems{
    if (_dotaDic[@"day"]) {
        return [_dotaDic[@"day"]count];
    }
    return 0;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    NSDictionary *dic = _dotaDic[@"day"][index];
    if (dic[@"picurl"]) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:dic[@"picurl"]]];
    }
    
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    
}




@end
