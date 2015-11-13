//
//  HomeController.m
//  MyDota
//
//  Created by Xiang on 15/10/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "HomeController.h"
#import "GGRequest.h"
//#import "ImagePlayerView.h"
#import "UIImageView+AFNetworking.h"
#import "MyDefines.h"
#import "M3U8Tool.h"
#import "MBProgressHUD.h"
#import "BaseViewController+NaviView.h"
#import "VideoViewController.h"
#import "UserModel.h"
#import "AuthorVideoListController.h"
#import "VideoListController.h"
#import "SearchViewController.h"
#import "VideoListModel.h"
#import "WXApiManager.h"

#import "IntroControll.h"

#define rowAd (180*timesOf320)
#define  tail  10
#define btnWid ((SCREEN_WIDTH-5*tail)/4)

@interface HomeController ()<WXApiManagerDelegate,IntroControllDelegate>

@end

@implementation HomeController{
    GGRequestObserver *_reqeustObserver;
    VideoListModel *_dotaListModel;
    
    IntroControll *_introControl;
    
    NSMutableArray *_introModelArr;
    
    UIWebView *_webView;
    
    NSArray *_authourList;
    int minIntroNum;
}

- (void)viewDidLoad {
    [WXApiManager sharedManager].delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _naviBar = [self setUpNaviViewWithType:GGNavigationBarTypeCustom];
    _naviBar.alpha = 0;
    _naviBar.title = @"刀一把";
    _introModelArr = [NSMutableArray array];
    [self loadDotaVideos];
    
    
    _authourList = [UserModel loadLocalGEOJsonData];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    view.backgroundColor = viewBGColor;
//    self.tableView.tableHeaderView = view;
    UIView *footView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    footView.backgroundColor = viewBGColor;
    self.tableView.tableFooterView = footView;
    [self setSearchButton];
//    _authoList = @[@"2009",       @"情书",    @"小满",    @"牛蛙",   @"章鱼丸718", @"西瓦幽鬼",    @"舞ル灬",@"更多"];
//    _authorIdArr = @[@"79241663",@"106382808",@"64331608",@"90146406",@"75496314",@"109937062",@"80985046"];
//    
//    _authorUrlArr = @[];
    
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadDotaVideos];
//    }];
//    self.tableView.header.backgroundColor = JDLightOrange;


}

-(void)setSearchButton{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"--" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    _naviBar.rightView = btn;
}


-(void)loadDotaVideos{
    [VideoListModel getVideoListBy:@"https://api.youku.com/quality/video/by/category.json?client_id=e2306ead120d2e34&cate=10&count=10" complish:^(id object) {
        _dotaListModel = object;
        [self makeTheIntroModelList];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];
    
}

-(void)makeTheIntroModelList{
    minIntroNum = (int)MIN(_dotaListModel.videos.count, 5);
    for (int i=0; i<minIntroNum; i++) {
        VideoModel *vm = _dotaListModel.videos[i];
        IntroModel *model = [[IntroModel alloc]initWithTitle:vm.title description:nil image:vm.thumbnail];
        [_introModelArr addObject:model];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark Search Action
-(void)searchAction:(UIButton*)btn{
    SearchViewController *serchVC = [[SearchViewController alloc]init];
    [self pushWithoutTabbar:serchVC];
}



#pragma mark tableViewDataSource --- Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (_dotaListModel.videos.count < 4) {
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
        }
        if (_introControl == nil&&_introModelArr.count) {
            _introControl = [[IntroControll alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, rowAd) pages:_introModelArr];
            _introControl.delegate = self;
        }
        [cell.contentView addSubview:_introControl];
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
                if ([info.modelID isEqualToString:@"64331608"]) {
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
                
                NSInteger index = _dotaListModel.videos.count-(4-i);
                btn.tag = index;
                VideoModel *model = _dotaListModel.videos[index];
                
                [imgV setImageWithURL:[NSURL URLWithString:model.thumbnail]];
                nameLab.text = model.title;
                [ZXUnitil fitTheLabel:nameLab];
                
                UILabel *detialLab = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imgV.frame)+5, wid-10, 20)];
                detialLab.font = [UIFont systemFontOfSize:12];
                detialLab.textColor = TextLightColor;
                detialLab.textAlignment = NSTextAlignmentCenter;
                detialLab.text = model.published;
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
        VideoListController *vc = [[VideoListController alloc]init];
        [self pushWithoutTabbar:vc];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;
    if (y<0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    _naviBar.alpha = MIN(0.8, y/100);
}



-(void)clickedTheBtn:(UIButton*)btn{
    if (btn.tag == 7) {
        
    }else{
        UserModel *user = _authourList[btn.tag];
        AuthorVideoListController *vc = [[AuthorVideoListController alloc]initWithUser:user];
        [self pushWithoutTabbar:vc];
    }
}

-(void)clickedLargeBtn:(UIButton*)btn{
    VideoModel *model = _dotaListModel.videos[btn.tag];
    if (model.link) {
        VideoViewController *vc = [[VideoViewController alloc]initWithVideoModel:model];
        [self pushWithoutTabbar:vc];
    }
    
}


#pragma mark - introControlDelegate

-(void)introControlSelectedIndex:(int)index{
    VideoModel *model = _dotaListModel.videos[index];
    if (model.link) {
        VideoViewController *vc = [[VideoViewController alloc]initWithVideoModel:model];
        [self pushWithoutTabbar:vc];
    }else{
        
    }
}

//- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
//    
//    VideoModel *model = _dotaListModel.videos[index];
//    if (model.thumbnail) {
//        imageView.contentMode = UIViewContentModeScaleToFill;
//        [imageView setImageWithURL:[NSURL URLWithString:model.thumbnail]];
//    }
//    
//}
//- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
//    VideoModel *model = _dotaListModel.videos[index];
//    if (model.link) {
//        VideoViewController *vc = [[VideoViewController alloc]initWithVideoModel:model];
//        [self pushWithoutTabbar:vc];
//    }else{
//        
//    }
//}




#pragma mark -- pushAction

-(void)pushWithoutTabbar:(UIViewController*)vc{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark --- WXApiManagerDelegate

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"111"
                                                    message:@"----"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request{
    WXMediaMessage *message = request.message;
    if (message.messageExt.length) {
        if ([message.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
            WXAppExtendObject *objc = message.mediaObject;
            NSDictionary *dic = [objc.extInfo jsonObject];
            Class objClass = NSClassFromString(message.messageExt);
            id model = [MTLJSONAdapter modelOfClass:objClass fromJSONDictionary:dic error:nil];
            if ([model isKindOfClass:[VideoModel class]]) {
                VideoViewController *vc = [[VideoViewController alloc]initWithVideoModel:model];
                [self pushWithoutTabbar:vc];
            }
            
        }
    }
}

@end
