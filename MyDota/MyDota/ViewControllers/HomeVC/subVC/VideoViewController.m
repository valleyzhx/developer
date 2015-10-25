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
#import "MBProgressHUD.h"
#import "M3U8Tool.h"
#import "UserModel.h"
#import "UIKit+AFNetworking.h"
#import "AuthorVideoListController.h"
#import "VideoModel.h"
#import "MTLHALResource+Helper.h"
#import "DatabaseOperation.h"

@interface ChooseView : UIView

-(id)initWithTitleArr:(NSArray*)arr action:(void(^)(NSString*))clickedBlock;

@end



@interface VideoViewController ()<VKVideoPlayerDelegate>
@property (nonatomic,strong)VKVideoPlayer *player;

@end

@implementation VideoViewController{
    NSDictionary *_inputDic;
    VideoModel *_model;
    NSString *_m3u8Url;
    //NSMutableDictionary *_typeDic;
    NSString *_selectKey;
    ChooseView *_choosV;
    UserModel *_user;
    BOOL _isFav;
}

-(id)initWithVideoDiction:(NSDictionary *)dic{
    if (self = [super init]) {
        _inputDic = dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    naviBar.backgroundView.alpha = 0;
    [self setVideoView];
    [self startLoadRequest:_inputDic[@"link"]];
    //[self loadTheVidList];
    CGRect r = self.tableView.frame;
    r.origin.y = self.player.view.frame.size.height;
    r.size.height -= r.origin.y;
    self.tableView.frame = r;
    [self.view bringSubviewToFront:naviBar];
    if (!_userId) {
        _userId = [_inputDic[@"userid"]integerValue];
    }
    [UserModel getUserInfoBy:@(_userId) complish:^(id objc) {
        _user = objc;
        [self.tableView reloadData];
    }];
    _isFav = [VideoModel haveDataWithID:_inputDic[@"id"]];
}

-(void)startLoadRequest:(NSString*)htmlUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [M3U8Tool m3u8UrlWithUrl:htmlUrl complised:^(NSString *m3u8Url) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
        naviBar.hidden = videoPlayer.isFullScreen;
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
    return 3;
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
            
            UIButton *favarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
            favarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [favarBtn setTitleColor:JDDarkOrange forState:UIControlStateNormal];
            [favarBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [favarBtn addTarget:self action:@selector(favarateAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = favarBtn;
        }
        titleLab.text = _inputDic[@"title"];
        detialLab.text = [NSString stringWithFormat:@"发布时间: %@",_inputDic[@"published"]];
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
    }
    cell.selectionStyle = indexPath.row==2?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        if (_isFromAuthorList) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        
        AuthorVideoListController *vc = [[AuthorVideoListController alloc]initWithUser:_user selectCallback:^(NSDictionary *dic) {
            _inputDic = nil;
            _inputDic = dic;
            [self startLoadRequest:dic[@"link"]];
            [self.tableView reloadData];
        }];
        vc.isFromVideo = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}





-(void)dealloc{
    
}
-(void)favarateAction:(UIButton*)btn{
    
    FMDatabase *db = [DatabaseOperation openDataBase];
    if (_isFav) {
        
    }
    [DatabaseOperation closeDataBase:db];
    _isFav = NO;
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





