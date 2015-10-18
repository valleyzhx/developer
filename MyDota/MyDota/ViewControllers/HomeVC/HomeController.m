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
#import "M3U8Tool.h"
#import "MBProgressHUD.h"
#import "BaseViewController+NaviView.h"
#import "VideoViewController.h"
#import "UserModel.h"
#import "AuthorVideoListController.h"
#import "VideoListController.h"


#define rowAd (180*timesOf320)
#define  tail  10
#define btnWid ((SCREEN_WIDTH-5*tail)/4)

@interface HomeController ()<ImagePlayerViewDelegate>

@end

@implementation HomeController{
    GGRequestObserver *_reqeustObserver;
    NSMutableArray *_dotaArr;
    
    ImagePlayerView *_imgView;
    UIWebView *_webView;
    
    NSArray *_authourList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeCustom];
    naviBar.title = @"刀一把";
    self.tableView.footer = nil;
    [self loadDotaVideos];
    
    
    _authourList = [UserModel loadLocalGEOJsonData];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.backgroundColor = viewBGColor;
    self.tableView.tableHeaderView = view;
    UIView *footView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 320, 48+5)];
    footView.backgroundColor = viewBGColor;
    self.tableView.tableFooterView = footView;
    
//    _authoList = @[@"2009",       @"情书",    @"小满",    @"牛蛙",   @"章鱼丸718", @"西瓦幽鬼",    @"舞ル灬",@"更多"];
//    _authorIdArr = @[@"79241663",@"106382808",@"64331608",@"90146406",@"75496314",@"109937062",@"80985046"];
//    
//    _authorUrlArr = @[];
    
}

-(void)loadDotaVideos{
    
    [GGRequest requestWithUrl:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10" withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            _dotaArr = responseObject[@"videos"];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark tableViewDataSource --- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (_dotaArr.count<4) {
            return 0;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==3) {
        return 0;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return rowAd;
    }
    if (indexPath.section == 1) {
        return btnWid*2+3*tail;
    }
    if (indexPath.section == 2) {
        return SCREEN_WIDTH;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {//ad
        cell = [tableView dequeueReusableCellWithIdentifier:@"ADCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADCell"];
            _imgView = [[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, rowAd)];
            _imgView.imagePlayerViewDelegate = self;
            _imgView.scrollInterval = 4;
//            _imgView.pageControl.currentPageIndicatorTintColor = JDDarkOrange;
//            _imgView.pageControl.pageIndicatorTintColor = TextLightColor;
            [_imgView setPageControlPosition:ICPageControlPosition_BottomCenter];
            [cell.contentView addSubview:_imgView];
        }
        [_imgView reloadData];
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"AuthourCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AuthourCell"];
            for (int i=0; i<_authourList.count+1; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(tail+(i%4)*(btnWid+tail), tail+(btnWid+tail)*(i/4), btnWid, btnWid)];
                btn.tag = i;
                [btn addTarget:self action:@selector(clickedTheBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = viewBGColor;
                UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40*timesOf320, 40*timesOf320)];
                imgV.center = CGPointMake(btnWid/2, btnWid/2-10);
                
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnWid, 20)];
                nameLab.font = [UIFont systemFontOfSize:12];
                nameLab.textColor = TextDarkColor;
                nameLab.center = CGPointMake(btnWid/2, btnWid-20/2);
                nameLab.textAlignment = NSTextAlignmentCenter;
                
                btn.layer.cornerRadius = 10;
                [btn addSubview:imgV];
                [btn addSubview:nameLab];
                [cell.contentView addSubview:btn];
                if (i==7) {
                    nameLab.text = @"更多";
                    break;
                }
                UserModel *info = _authourList[i];
                nameLab.text = info.name;
                if ([info.userId isEqualToString:@"64331608"]) {
                    nameLab.text = @"小满";
                }

                [imgV setImageWithURL:[NSURL URLWithString:info.avatar_large]];
                
            }
        }
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
            float wid = (SCREEN_WIDTH-3*tail)/2;
            for (int i=0; i<4; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(tail+(i%2)*(wid+tail), tail+(wid+tail)*(i/2), wid, wid)];
                
                [btn addTarget:self action:@selector(clickedLargeBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [UIColor whiteColor];
                UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120*timesOf320, 70*timesOf320)];
                imgV.center = CGPointMake(wid/2, wid/2+5);
                
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, wid-10, 30)];
                nameLab.numberOfLines = 2;
                nameLab.font = [UIFont systemFontOfSize:12];
                nameLab.textColor = TextDarkColor;
                nameLab.textAlignment = NSTextAlignmentCenter;
                
                btn.layer.cornerRadius = 10;
                [btn addSubview:imgV];
                [btn addSubview:nameLab];
                
                cell.contentView.backgroundColor = viewBGColor;
                
                NSInteger index = _dotaArr.count-(4-i);
                btn.tag = index;
                NSDictionary *dic = _dotaArr[index];
                
                [imgV setImageWithURL:[NSURL URLWithString:dic[@"thumbnail"]]];
                nameLab.text = dic[@"title"];
                [ZXUnitil fitTheLabel:nameLab];
                
                UILabel *detialLab = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imgV.frame)+5, wid-10, 20)];
                detialLab.font = [UIFont systemFontOfSize:12];
                detialLab.textColor = TextLightColor;
                detialLab.textAlignment = NSTextAlignmentCenter;
                detialLab.text = dic[@"published"];
                [btn addSubview:detialLab];
                
                [cell.contentView addSubview:btn];
            }
            
        }
    }else if (indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"moreVideoCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreVideoCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"查看更多视频";
    }
    cell.selectionStyle = indexPath.section == 3? UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        self.hidesBottomBarWhenPushed = YES;
        VideoListController *vc = [[VideoListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}





-(void)clickedTheBtn:(UIButton*)btn{
    if (btn.tag == 7) {
        
    }else{
        UserModel *user = _authourList[btn.tag];
        self.hidesBottomBarWhenPushed = YES;
        AuthorVideoListController *vc = [[AuthorVideoListController alloc]initWithUser:user];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(void)clickedLargeBtn:(UIButton*)btn{
    NSDictionary *dic = _dotaArr[btn.tag];
    if (dic[@"link"]) {
        self.hidesBottomBarWhenPushed = YES;
        VideoViewController *vc = [[VideoViewController alloc]initWithVideoDiction:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - ImagePlayerViewDelegate

- (NSInteger)numberOfItems{
    
    return MIN(_dotaArr.count, 6);
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    NSDictionary *dic = _dotaArr[index];
    if (dic[@"thumbnail"]) {
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView setImageWithURL:[NSURL URLWithString:dic[@"thumbnail"]]];
    }
    
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    NSDictionary *dic = _dotaArr[index];
    if (dic[@"link"]) {
        self.hidesBottomBarWhenPushed = YES;
        VideoViewController *vc = [[VideoViewController alloc]initWithVideoDiction:dic];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}




@end
