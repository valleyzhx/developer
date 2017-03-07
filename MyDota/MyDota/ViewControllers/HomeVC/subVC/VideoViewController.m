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
#import "UserModel.h"
#import "UIKit+AFNetworking.h"
#import "AuthorVideoListController.h"
#import "FMDBManager.h"
#import "WXApiRequestHandler.h"
#import "CommentListModel.h"
#import "CommentViewController.h"
#import "UIImageView+AFNetworking.h"


@interface ChooseView : UIView

-(id)initWithTitleArr:(NSArray*)arr action:(void(^)(NSString*))clickedBlock;

@end



@interface VideoViewController ()<UIActionSheetDelegate,UIWebViewDelegate>

@end

@implementation VideoViewController{
    VideoModel *_videoObject;
    UIWebView *_webView;
    
    //NSMutableDictionary *_typeDic;
    UserModel *_user;
    BOOL _isFav;
    
    BOOL _showFullAd;

    BOOL _showingSheet;
}

-(id)initWithVideoModel:(VideoModel *)model{
    if (self = [super init]) {
        _videoObject = model;
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebVideoView];
    self.title = @"视频播放";
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(_webView.frame)+ 5)];
        view.backgroundColor = viewBGColor;
        
       UILabel *coutLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame)- 30, SCREEN_WIDTH, 20)];
        coutLab.textColor = Nav_Color;
        coutLab.font = [UIFont systemFontOfSize:14];
        coutLab.textAlignment = NSTextAlignmentCenter;
        if (_videoObject.view_count) {
            coutLab.text = [NSString stringWithFormat:@"观看次数:%d",_videoObject.view_count];
        }
        [view addSubview:coutLab];
        view;
    });
    
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
    
    [self initFullWindowObserver];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [shareButton setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareAction:) forControlEvents:UIControlEventTouchUpInside];
    _naviBar.rightView = shareButton;
    
    [self loadBottomADView];
    
    NSInteger count = ((AppDelegate*)[UIApplication sharedApplication].delegate).videoAppearCount;
    _showFullAd = count%5 == 4;
    if (_showFullAd) {
        [self loadFullADView];
    }
    ((AppDelegate*)[UIApplication sharedApplication].delegate).videoAppearCount = count+1;
    [self checkWIFI];

}


- (void)loadWebVideoView{
    //改成网页播放
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_WIDTH*0.6)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    if (!_videoObject.modelID) {
        [self showMessage:@"暂时无法访问"];
        return;
    }
    
    NSString *bundle = [[NSBundle mainBundle]pathForResource:@"video" ofType:@"html"];
    bundle = [bundle stringByAppendingFormat:@"?videoid=%@",_videoObject.modelID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:bundle]];
    [_webView loadRequest:request];
    [self.view bringSubviewToFront:_naviBar];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    
    return 2;//评论为单独的section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==1) {
        return 1;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1) {
        return 44;
    }
    if (indexPath.row == 0) {
        float titleHeight = [ZXUnitil heightOfStringWithString:_videoObject.title font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-44];
        return 35 + titleHeight;
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
    
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionOneCell"];
            cell.textLabel.text = @"查看评论";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    
    
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        UILabel *titleLab = (UILabel*)[cell.contentView viewWithTag:10];
        UILabel *detialLab = (UILabel*)[cell.contentView viewWithTag:11];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
            titleLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, 5, SCREEN_WIDTH-44, 20)];
            titleLab.tag = 10;
            titleLab.numberOfLines = 0;
            titleLab.textColor = TextDarkColor;
            titleLab.font = [UIFont systemFontOfSize:14];
            
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
        [ZXUnitil fitTheLabel:titleLab];
        detialLab.text = [NSString stringWithFormat:@"发布时间: %@",_videoObject.published];
        detialLab.center = CGPointMake(detialLab.center.x, CGRectGetMaxY(titleLab.frame)+5 + detialLab.frame.size.height/2);
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
    
    if (indexPath.section ==1) {
        if (indexPath.row == 0) {//评论
            CommentViewController *vc = [[CommentViewController alloc]initWithVideoId:_videoObject.modelID];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }
    
    
    if (indexPath.row == 2) {
        if (_isFromAuthorList) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        __weak typeof(self) weakSelf = self;
        AuthorVideoListController *vc = [[AuthorVideoListController alloc]initWithUser:_user selectCallback:^(VideoModel *model) {
            _videoObject = model;
            [weakSelf loadWebVideoView];
            [weakSelf.tableView reloadData];
            [MobClick event:@"videoViewController" label:_user.name];
        }];
        vc.isFromVideo = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - action

-(void)favarateAction:(UIButton*)btn{
    if (_isFav) {
        [[FMDBManager shareManager]deleteDataWithModel:_videoObject];
    }else{
        [[FMDBManager shareManager]saveDataWithModel:_videoObject];
    }
    _isFav = !_isFav;
    btn.selected = !btn.selected;
}


-(void)clickShareAction:(UIButton*)btn{
    _showingSheet = YES;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友",@"分享到朋友圈", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){//好友
        [self shareVideoInScene:WXSceneSession];
    }else if (buttonIndex == 1) {//朋友圈
        [self shareVideoInScene:WXSceneTimeline];
    }else if (buttonIndex == 2){//取消
        
    }
    _showingSheet = NO;
}

-(void)shareVideoInScene:(enum WXScene)scene{
    NSString *content = [NSString stringWithFormat:@"%@\n%@",_videoObject.title,_videoObject.published];
    NSString *url = [@"http://xianng.com/videoplay/video.html?videoid=" stringByAppendingString:_videoObject.modelID];
    UIImage *img = [[UIImageView sharedImageCache]cachedImageForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_videoObject.thumbnail]]];
    
    
    [WXApiRequestHandler sendLinkURL:url TagName:@"刀一把" Title:content Description:content ThumbImage:img InScene:(enum WXScene)scene];
}

#pragma mark - navi

#pragma mark- UIWebviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

#pragma mark - 横屏播放

-(void)initFullWindowObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}

// 进入全屏
-(void)begainFullScreen
{
    if (_showingSheet) {
        return;
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

}
// 退出全屏
-(void)endFullScreen
{
    if (_showingSheet) {
        return;
    }
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}





-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end


#pragma chooseview


@implementation ChooseView{
    void (^block)(NSString*);
}

-(id)initWithTitleArr:(NSArray *)arr action:(void (^)(NSString *))clickedBlock{
    if (self = [super initWithFrame:CGRectMake(0, 0, 40, 30*arr.count)]) {
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        UIView *baseView = [[UIView alloc]initWithFrame:view.bounds];
        baseView.backgroundColor = [UIColor blackColor];
        baseView.alpha = 0.8;
        [view addSubview:baseView];
        [self addSubview:view];
        for (int i=0; i<arr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30*i, self.frame.size.width, 30)];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
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





