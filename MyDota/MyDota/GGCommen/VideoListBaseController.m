//
//  VideoListBaseController.m
//  MyDota
//
//  Created by Xiang on 15/10/21.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListBaseController.h"
#import "VideoListCell.h"
#import <UIImageView+AFNetworking.h>
#import "VideoViewController.h"
#import "MyDefines.h"
//#import <GoogleMobileAds/GoogleMobileAds.h>
static NSString *const GADAdUnitID = @"ca-app-pub-7534063156170955/2261335225";

@interface VideoListBaseController () <GADNativeExpressAdViewDelegate>{
    NSMutableArray *_nativeADViews;
    NSMutableArray *_adsToLoadArr;
}

@end

@implementation VideoListBaseController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [NSMutableArray array];
    _adsToLoadArr = [NSMutableArray array];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
        view.backgroundColor = viewBGColor;
        view;
    });
    [self setAdViews];
    [self preloadNextAd];

}


-(void)setAdViews{
    _nativeADViews = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        GADNativeExpressAdView *adView = [[GADNativeExpressAdView alloc]initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(SCREEN_WIDTH, 132))];
        adView.adUnitID = GADAdUnitID;
        adView.rootViewController = self;
        adView.delegate = self;
        [_nativeADViews addObject:adView];
        [_adsToLoadArr addObject:adView];
    }
    
}

- (void)preloadNextAd {
    if (!_adsToLoadArr.count) {
        return;
    }
    GADNativeExpressAdView *adView = _adsToLoadArr.firstObject;
    [_adsToLoadArr removeObjectAtIndex:0];
    [adView loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- tableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSInteger adNum = MIN(_listArr.count/10, 10);
    return _listArr.count;// + adNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger adNum = MIN(_listArr.count/10, 10);
    NSInteger adIndex = MIN(indexPath.row/10, 10);
    if (indexPath.row%10 == 9 && adIndex<adNum) {
        return 132;
    }
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger adNum = MIN(_listArr.count/10, 10);
//    NSInteger adIndex = MIN(indexPath.row/10, 10);
//    
//    if ( indexPath.row!=0 && indexPath.row%10 == 9 && adIndex<adNum) {// AD Cell
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdCell"];
//        if (_nativeADViews.count>adIndex) {
//            GADNativeExpressAdView *adView = _nativeADViews[adIndex];
//            adView.tag = 888;
//            [cell.contentView addSubview:adView];
//            adView.center = CGPointMake(SCREEN_WIDTH/2, 132.0/2);
//        }
//        
//        return cell;
//    }
    
    // =============    Normal Cell

    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"];
    UILabel *userLab = (UILabel*)[cell.contentView viewWithTag:77];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VideoListCell" owner:self options:nil]firstObject];
        userLab = [[UILabel alloc]initWithFrame:CGRectMake(cell.publishLab.frame.origin.x, cell.publishLab.frame.origin.y-25, 150, 14)];
        userLab.tag = 77;
        [cell.contentView addSubview:userLab];
    }
    NSInteger modelIndex = indexPath.row;
    VideoModel *model = _listArr[modelIndex];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    cell.titleLab.text = model.title;
    cell.publishLab.text = model.published;
    [ZXUnitil fitTheLabel:cell.titleLab];
    //userLab.text = dataDic[@""];
    float y = cell.publishLab.frame.origin.y - CGRectGetMaxY(cell.imgView.frame);
    userLab.center = CGPointMake(userLab.center.x, CGRectGetMaxY(cell.imgView.frame)+y/2);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GADNativeExpressAdView *adView = [cell.contentView viewWithTag:888];
    if (adView) {
        
        
        return;
    }
    
    
    NSInteger adIndex = MIN(indexPath.row/10, 10);
    NSInteger modelIndex = indexPath.row-adIndex;
    VideoModel *model = _listArr[modelIndex];
    VideoViewController *controller = [[VideoViewController alloc]initWithVideoModel:model];
    [self.navigationController pushViewController:controller animated:YES];
    
}


// MARK: - GADNativeExpressAdView delegate methods
- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView {
    // Mark native express ad as succesfully loaded.
    // Load the next ad in the adsToLoad list.
    [self preloadNextAd];

}

- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad: %@", error.localizedDescription);
    // Load the next ad in the adsToLoad list.
    [self preloadNextAd];

}


@end
