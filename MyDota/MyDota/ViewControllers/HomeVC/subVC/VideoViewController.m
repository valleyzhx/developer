//
//  VideoViewController.m
//  MyDota
//
//  Created by Xiang on 15/10/17.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoViewController.h"
#import "BaseViewController+NaviView.h"
#import "MyDefines.h"
#import "VKVideoPlayer.h"
#import "M3U8Tool.h"
#import "UserModel.h"
#import "UIKit+AFNetworking.h"
#import "AuthorVideoListController.h"
#import "FMDBManager.h"
#import "WXApiRequestHandler.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface ChooseView : UIView

-(id)initWithTitleArr:(NSArray*)arr action:(void(^)(NSString*))clickedBlock;

@end



@interface VideoViewController ()<VKVideoPlayerDelegate>
@property (nonatomic,strong)VKVideoPlayer *player;

@end

@implementation VideoViewController{
    VideoModel *_videoObject;
    NSString *_m3u8Url;
    //NSMutableDictionary *_typeDic;
    NSString *_selectKey;
    ChooseView *_choosV;
    UserModel *_user;
    BOOL _isFav;
    
    GADBannerView *_adView;

}

-(id)initWithVideoModel:(VideoModel *)model{
    if (self = [super init]) {
        _videoObject = model;
    }
    return self;
}



-(void)loadAddView{
    _adView = [[GADBannerView alloc]
               initWithFrame:CGRectMake((SCREEN_WIDTH-320)/2,50,320,50)];
    _adView.adUnitID = @"ca-app-pub-7534063156170955/2929947627";//调用id
    
    _adView.rootViewController = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [view addSubview:_adView];
    self.tableView.tableFooterView = view;
    GADRequest *req = [GADRequest request];
#if DEBUG
    req.testDevices = @[@"5610fbd8aa463fcd021f9f235d9f6ba1"];
#endif
    [_adView loadRequest:req];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _naviBar.backgroundView.alpha = 0;
    [self setVideoView];
    [self startLoadRequest:_videoObject.link];
    //[self loadTheVidList];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(_player.view.frame))];
        view.backgroundColor = viewBGColor;
        view;
    });
    [self loadAddView];
    
    NSInteger userId = _videoObject.userid.integerValue;
    if (userId==0) {
        userId = _videoObject.userDicId.integerValue;
    }
    [UserModel getUserInfoBy:@(userId) complish:^(id objc) {
        _user = objc;
        [MobClick event:@"videoViewController" label:_user.name];
        [self.tableView reloadData];
    }];
    _isFav = [[FMDBManager shareManager]hasTheModel:_videoObject];
}

-(void)startLoadRequest:(NSString*)htmlUrl{
    [self showHudView];
    [M3U8Tool m3u8UrlWithUrl:htmlUrl complised:^(NSString *m3u8Url) {
        [self hideHudView];
        if (m3u8Url) {
            _m3u8Url = m3u8Url;
//            if (_typeDic[@"高清"]) {
//                [self loadVideoWithKey:@"高清"];
//            }
            [self.player loadVideoWithStreamURL:[NSURL URLWithString:_m3u8Url]];
        }
    }];
}

//-(void)loadVideoWithKey:(NSString*)key{
//    _selectKey = key;
//    NSString *type = [M3U8Tool typeNameOfM3U8:_m3u8Url];
//    _m3u8Url = [_m3u8Url stringByReplacingOccurrencesOfString:type withString:_typeDic[key]];
//    
//    [self.player loadVideoWithStreamURL:[NSURL URLWithString:_m3u8Url]];
//    [self.player.view.videoQualityButton setTitle:_selectKey forState:UIControlStateNormal];
//}

//-(void)loadTheVidList{
//    NSString *url = [NSString stringWithFormat:@"http://v.youku.com/player/getPlayList/VideoIDS/%@/Pf/4/ctype/12/ev/1",_inputDic[@"id"]];
//    [GGRequest requestWithUrl:url withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (responseObject&&responseObject[@"data"]) {
//           NSArray *segsArr = [responseObject[@"data"][0][@"segs"]allKeys];
//            [self setTheTypeDiction:segsArr];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}

//-(void)setTheTypeDiction:(NSArray*)segsArr{
//    _typeDic = [NSMutableDictionary dictionary];
//    [segsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        /*“segs”,”type”,”清晰度”
//         "hd3", "flv", "1080P"
//         "hd2", "flv", "超清"
//         "mp4", "mp4", "高清"
//         "flvhd", "flv", "高清"
//         "flv", "flv", "标清"
//         "3gphd", "3gp", "高清"*/
//        NSString *str = obj;
//        if ([str isEqualToString:@"hd3"]) {
//            [_typeDic setValue:str forKey:@"1080P"];
//        }
//        if ([str isEqualToString:@"hd2"]) {
//            [_typeDic setValue:str forKey:@"超清"];
//        }
//        if ([str isEqualToString:@"flvhd"]) {
//            [_typeDic setValue:str forKey:@"高清"];
//        }
//        if ([str isEqualToString:@"3gphd"]||[str isEqualToString:@"mp4"]) {
//            if ([_typeDic.allKeys containsObject:@"高清"]==NO) {
//                [_typeDic setValue:str forKey:@"高清"];
//            }
//        }
//        if ([str isEqualToString:@"flv"]) {
//            [_typeDic setValue:str forKey:@"标清"];
//        }
//    }];
//}



-(void)setVideoView{
   VKVideoPlayerView *playerView = [[VKVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    _player = [[VKVideoPlayer alloc] initWithVideoPlayerView:playerView];
    _player.portraitFrame = playerView.bounds;
    _player.forceRotate = YES;
    _player.delegate = self;
    playerView.previousButton.hidden = YES;
    playerView.nextButton.hidden = YES;
    playerView.topPortraitCloseButton.alpha = 0;
    playerView.topControlOverlay.alpha = 0;
    [self.view addSubview:playerView];
}
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willStartVideo:(id<VKVideoPlayerTrackProtocol>)track{
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event{
    if (event == VKVideoPlayerControlEventTapFullScreen) {
        _naviBar.hidden = videoPlayer.isFullScreen;
    }
//    if (event == VKVideoPlayerControlEventTapVideoQuality) {
//        if (_choosV) {
//            [_choosV removeFromSuperview];
//            _choosV = nil;
//        }else{
//            NSMutableArray *arr = [NSMutableArray arrayWithArray:_typeDic.allKeys];
//            [arr removeObject:_selectKey];
//            _choosV = [[ChooseView alloc]initWithTitleArr:arr action:^(NSString *str) {
//                [self loadVideoWithKey:str];
//                [_choosV removeFromSuperview];
//                _choosV = nil;
//            }];
//           CGPoint point = [self.player.view.bottomControlOverlay convertPoint:self.player.view.videoQualityButton.frame.origin toView:self.player.view];
//            CGRect r = _choosV.frame;
//            r.origin = CGPointMake(point.x, point.y-r.size.height);
//            _choosV.frame = r;
//            [self.player.view addSubview:_choosV];
//        }
//    }
//    if (event == VKVideoPlayerControlEventTapPlayerView) {
//        if (_choosV) {
//            [_choosV removeFromSuperview];
//            _choosV = nil;
//        }
//    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.player isPlayingVideo]) {
        [self.player pauseContent];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3+1;//增加分享
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 55;
    }
    if (indexPath.row == 1) {
      float desHeight = [ZXUnitil heightOfStringWithString:_user.userDescription font:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH-2*orgX];
        return 44+ desHeight +20;
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = viewBGColor;
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        UILabel *titleLab = (UILabel*)[cell.contentView viewWithTag:10];
        UILabel *detialLab = (UILabel*)[cell.contentView viewWithTag:11];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
            titleLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, 5, SCREEN_WIDTH-2*orgX, 20)];
            titleLab.tag = 10;
            titleLab.textColor = TextDarkColor;
            titleLab.font = [UIFont systemFontOfSize:15];
            
            detialLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, 30, titleLab.frame.size.width, 20)];
            detialLab.tag = 11;
            detialLab.font = [UIFont systemFontOfSize:12];
            detialLab.textColor = TextLightColor;
            
            [cell.contentView addSubview:titleLab];
            [cell.contentView addSubview:detialLab];
            
            UIButton *favarBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44, 0, 44, 55)];
            favarBtn.titleLabel.font = [UIFont systemFontOfSize:19];
            [favarBtn setTitle:@"☆" forState:UIControlStateNormal];
            [favarBtn setTitle:@"★" forState:UIControlStateSelected];
            [favarBtn setTitleColor:JDDarkOrange forState:UIControlStateNormal];
            [favarBtn addTarget:self action:@selector(favarateAction:) forControlEvents:UIControlEventTouchUpInside];
            favarBtn.selected = _isFav;
            [cell.contentView addSubview:favarBtn];
        }
        titleLab.text = _videoObject.title;
        detialLab.text = [NSString stringWithFormat:@"发布时间: %@",_videoObject.published];
    }else if (indexPath.row == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:10];
        UILabel *nameLab = (UILabel*)[cell.contentView viewWithTag:11];
        UILabel *descLab = (UILabel*)[cell.contentView viewWithTag:12];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondCell"];
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(orgX, 5, 44, 44)];
            imgView.layer.cornerRadius = imgView.frame.size.width/2;
            imgView.layer.masksToBounds = YES;
            imgView.tag = 10;
            
            nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, 12+5, SCREEN_WIDTH-CGRectGetMaxX(imgView.frame)-orgX-15, 20)];
            nameLab.font = [UIFont systemFontOfSize:14];
            nameLab.textColor = TextDarkColor;
            nameLab.tag = 11;
            
            descLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, 44+13, SCREEN_WIDTH-2*orgX, 30)];
            descLab.font = [UIFont systemFontOfSize:12];
            descLab.numberOfLines = 0;
            descLab.textColor = TextLightColor;
            descLab.tag = 12;
            
            
            [cell.contentView addSubview:imgView];
            [cell.contentView addSubview:nameLab];
            [cell.contentView addSubview:descLab];
        }
        [imgView setImageWithURL:[NSURL URLWithString:_user.avatar_large]];
        nameLab.text = _user.name;
        descLab.text = _user.userDescription;
        [ZXUnitil fitTheLabel:descLab];
    }else if (indexPath.row == 2){
        cell =[tableView dequeueReusableCellWithIdentifier:@"thirdCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thirdCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"全部视频";
    }else if (indexPath.row == 3){
        cell =[tableView dequeueReusableCellWithIdentifier:@"forthCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"forthCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"分享视频";
    }
    
    cell.selectionStyle = (indexPath.row==2||indexPath.row==3)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        if (_isFromAuthorList) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        __weak typeof(self) weakSelf = self;
        AuthorVideoListController *vc = [[AuthorVideoListController alloc]initWithUser:_user selectCallback:^(VideoModel *model) {
            _videoObject = model;
            [weakSelf startLoadRequest:_videoObject.link];
            [weakSelf.tableView reloadData];
            [MobClick event:@"videoViewController" label:_user.name];
        }];
        vc.isFromVideo = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {//分享
        
       NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:_videoObject];
        NSString *content = [NSString stringWithFormat:@"%@\n%@",_videoObject.title,_videoObject.published];
        [WXApiRequestHandler sendAppContentData:nil
                                        ExtInfo:[dic jsonString]
                                         ExtURL:nil
                                          Title:[NSString stringWithFormat:@"我分享了 「%@」 的精彩视频",_user.name]
                                    Description:content
                                     MessageExt:NSStringFromClass([VideoModel class])
                                  MessageAction:nil
                                     ThumbImage:nil
                                        InScene:WXSceneSession];
    }
}



-(void)favarateAction:(UIButton*)btn{
    if (_isFav) {
        [[FMDBManager shareManager]deleteDataWithModel:_videoObject];
    }else{
        [[FMDBManager shareManager]saveDataWithModel:_videoObject];
    }
    _isFav = !_isFav;
    btn.selected = !btn.selected;
}
#pragma mark - navi

-(void)clickedBackAction:(UIButton*)btn{
    if (self.player.isFullScreen) {
        [self.player performOrientationChange:UIInterfaceOrientationPortrait];
        self.player.isFullScreen = NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}



-(void)dealloc{
    _videoObject = nil;
    _choosV = nil;
    _user = nil;
    _adView.rootViewController = nil;
    _adView.delegate = nil;
}

@end


#pragma chooseview


@implementation ChooseView{
    void (^block)(NSString*);
}

-(id)initWithTitleArr:(NSArray *)arr action:(void (^)(NSString *))clickedBlock{
    if (self = [super initWithFrame:CGRectMake(0, 0, 40, 25*arr.count)]) {
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        [self addSubview:view];
        for (int i=0; i<arr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 25*i, self.frame.size.width, 20)];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        block = clickedBlock;
    }
    return self;
}


-(void)clickedBtn:(UIButton*)btn{
    if (block) {
        block([btn titleForState:UIControlStateNormal]);
    }
}
-(void)dealloc{
    block = nil;
}
@end





