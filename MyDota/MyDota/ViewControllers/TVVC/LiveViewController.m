//
//  LiveViewController.m
//  MyDota
//
//  Created by Xiang on 16/3/11.
//  Copyright © 2016年 iOGG. All rights reserved.
//

#import "LiveViewController.h"
#import "VKVideoPlayer.h"
#import "MyDefines.h"
#import "UMOnlineConfig.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface LiveViewController ()<VKVideoPlayerDelegate>
@property (nonatomic,strong)VKVideoPlayer *player;
@end

@implementation LiveViewController{
    TVModel *_tvModel;
    GADBannerView *_adView;

}

-(id)initWithTVModel:(TVModel *)model{
    if (self = [super init]) {
        _tvModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _naviBar.backgroundView.alpha = 0;

    [self setVideoView];
    if (_tvModel.videoId) {
        [self loadVideoData];
    }
    [self loadAdView];
    [self.view bringSubviewToFront:_naviBar];
}

-(void)loadAdView{
    _adView = [[GADBannerView alloc]
               initWithFrame:CGRectMake((SCREEN_WIDTH-320)/2,50,320,100)];
    _adView.adUnitID = @"ca-app-pub-7534063156170955/2929947627";//调用id
    
    _adView.rootViewController = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [view addSubview:_adView];
    self.tableView.tableFooterView = view;
    GADRequest *req = [GADRequest request];
#if DEBUG
    req.testDevices = @[@"5610fbd8aa463fcd021f9f235d9f6ba1"];
#endif
    [_adView loadRequest:req];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadVideoData {
    NSString* baseUrl = [UMOnlineConfig getConfigParams:zqlive];
    NSString *url = [baseUrl stringByAppendingFormat:@"%@.m3u8",_tvModel.videoId];
    
    [self.player loadVideoWithStreamURL:[NSURL URLWithString:url]];

}

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
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(_player.view.frame)+ 5)];
        view.backgroundColor = viewBGColor;
        view;
    });
    
    
}
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willStartVideo:(id<VKVideoPlayerTrackProtocol>)track{
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event{
    if (event == VKVideoPlayerControlEventTapFullScreen) {
        _naviBar.hidden = videoPlayer.isFullScreen;
    }
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


#pragma mark -- UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *titleLab = (UILabel*)[cell.contentView viewWithTag:10];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(orgX, 5, SCREEN_WIDTH-44, 20)];
        titleLab.tag = 10;
        titleLab.numberOfLines = 0;
        titleLab.textColor = TextDarkColor;
        titleLab.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:titleLab];
    }
    titleLab.text = _tvModel.title;
    [ZXUnitil fitTheLabel:titleLab];
    return cell;
}


-(void)dealloc {
    _adView = nil;
}

@end
