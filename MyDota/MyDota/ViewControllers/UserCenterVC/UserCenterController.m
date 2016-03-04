//
//  UserCenterController.m
//  MyDota
//
//  Created by Xiang on 15/10/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "UserCenterController.h"
#import "MyDefines.h"
#import "UzysAssetsPickerController.h"
#import "WXApiRequestHandler.h"
#import "FavoVideoListController.h"
#import "ADViewController.h"
#import "UMFeedback.h"
#import "ShoppingController.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "FMDBManager.h"
#import "AFNetworking/UIKit+AFNetworking/UIImageView+AFNetworking.h"

#define imageHeight 230

@interface UserCenterController ()<UzysAssetsPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserCenterController{
    NSArray *_titleArr;
    UserModel *_user;
    
    UIImageView *_avatarView;
    UILabel *_userNameLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = viewBGColor;
    
    [self setHeaderImage];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setHiddenExtrLine:YES];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, imageHeight)];
        view.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panTheImageAction:)];
        [view addGestureRecognizer:longPressGr];
        
        
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
        
        _avatarView.center = CGPointMake(SCREEN_WIDTH/2, imageHeight/2);
        _userNameLab.center = CGPointMake(_avatarView.center.x, _avatarView.center.y + 70);
        
        _avatarView.layer.cornerRadius = _avatarView.frame.size.height/2;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        _userNameLab.textAlignment = NSTextAlignmentCenter;
        _userNameLab.textColor = [UIColor whiteColor];
        _userNameLab.font = [UIFont systemFontOfSize:14];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:_avatarView.bounds];
        [btn addTarget:self action:@selector(clickedAvatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_avatarView addSubview:btn];
        
        [view addSubview:_avatarView];
        [view addSubview:_userNameLab];

        view;
    });

    [self checkTokenExpireMethod];
    NSArray *arr = [[FMDBManager shareManager]queryTable:[UserModel class] QueryString:@"select * from UserModel;"];
    if (arr.count == 1) {
        _user = arr.firstObject;
    }
    [self refreshTheUserUI];
}

-(void)checkTokenExpireMethod{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    double expireTime = [[NSUserDefaults standardUserDefaults]doubleForKey:kTokenExpireValue];
    if (time + 3600*24 >= expireTime) {//过期
        [self logoutDataMethod];
    }
}


-(void)makeTiteArr{
    NSString *title = @"登录";
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kToken]) {
        title = @"退出";
    }
    _titleArr = nil;
    _titleArr = @[@[@"我的收藏",@"买套装备"],@[@"意见反馈",@"给个好评",@"分享APP"],@[@"每日一句"],@[title]];
}

-(void)refreshTheUserUI{
    _avatarView.image = nil;
    _userNameLab.text = @"";
    if (_user) {
        [_avatarView setImageWithURL:[NSURL URLWithString:_user.avatar_large]];
        _userNameLab.text = _user.name;
    }
    [self makeTiteArr];
    [self.tableView reloadData];
}

-(void)setHeaderImage{
    NSString *path = [self getImagePath];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    if (imgData) {
      self.imagView.image = [[UIImage alloc]initWithData:imgData];
    }else{
        self.imagView.image = [UIImage imageNamed:@"user_Header.jpg"];
    }
}


-(void)loadTheUerDataMethod:(NSString*)token{
    [UserModel getUserInfoByAccessToken:token complish:^(id objc) {
        if (objc) {
            _user = objc;
            [[FMDBManager shareManager]saveDataWithModel:_user];
            [self refreshTheUserUI];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)logoutDataMethod {
    [[FMDBManager shareManager]deleteDataWithModel:_user];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kToken];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kTokenExpireValue];
    [[NSUserDefaults standardUserDefaults]synchronize];
    _user = nil;
}


-(void)addTheExtraView{
//    _tableView.
}



#pragma mark ---- scrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    y = MIN(0, y);
    _imagView.transform = CGAffineTransformMakeScale(1.0-y/300, 1.0-y/300);
}


#pragma mark --- tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _titleArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section?10:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = viewBGColor;
    return view;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.textColor = TextDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section!=1 ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = JDRedColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    return cell;
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FavoVideoListController *controller = [[FavoVideoListController alloc]init];
            [self pushWithoutTabbar:controller];
        }
        if (indexPath.row == 1) {
            ShoppingController *controller = [[ShoppingController alloc]init];
            [self pushWithoutTabbar:controller];
        }
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=958792762";
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
    
    if (indexPath.section ==1 && indexPath.row == 2) {
        [WXApiRequestHandler sendAppContentData:nil
                                        ExtInfo:@""
                                         ExtURL:appStoreUrl
                                          Title:@"刀一把"
                                    Description:@"最新最热Dota视频App"
                                     MessageExt:nil
                                  MessageAction:nil
                                     ThumbImage:nil
                                        InScene:WXSceneSession];
    }
    if (indexPath.section == 2) {
        ADViewController *controller = [[ADViewController alloc]init];
        [self pushWithoutTabbar:controller];
    }
    if (indexPath.section == 3) {
        if (_user) {
            dispatchDelay(0.5,
                          [self logoutDataMethod];
                          [self refreshTheUserUI];
                          [MBProgressHUD showString:@"退出成功" inView:self.view];
                          );
            
        }else{
            __weak typeof(self) weakSelf = self;
            LoginViewController *controller = [[LoginViewController alloc]initWithFinishBlock:^(NSString *token) {
                [weakSelf makeTiteArr];
                [weakSelf loadTheUerDataMethod:token];
                [weakSelf.tableView reloadData];
            }];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
    
}


#pragma mark ------ Actions


-(void)panTheImageAction:(UILongPressGestureRecognizer*)gesture{
    
    UIGestureRecognizerState state = gesture.state;
    if (state == UIGestureRecognizerStateBegan) {
//        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
//        [sheet showInView:self.view];
        [self choosePictures];
    }
    
}

- (void)choosePictures {
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionPhoto = 1;
    picker.maximumNumberOfSelectionVideo = 0;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

-(void)clickedAvatarButtonAction:(UIButton*)btn{
    
}


#pragma mark --- UzysAssetsPickerControllerDelegate

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage            scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            _imagView.image = img;
            *stop = YES;
            NSString *path = [self getImagePath];
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            [data writeToFile:path atomically:NO];
        }];
        
        
    }
}


-(NSString*)getImagePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DOCPath = [paths objectAtIndex:0];
    NSString *fn = [DOCPath stringByAppendingPathComponent:@"image.png"];
    return fn;
}

#pragma mark -- pushAction

-(void)pushWithoutTabbar:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
