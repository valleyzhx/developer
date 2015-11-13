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

#define imageHeight 230

@interface UserCenterController ()<UzysAssetsPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserCenterController{
    NSArray *_titleArr;
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

        view;
    });
    _titleArr = @[@"我的收藏",@"意见反馈",@"给个好评",@"分享APP",@"别点 (╯`□′)╯(┻━┻"];
//    
//    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
//    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
//    appearanceConfig.assetsGroupSelectedImageName = @"checker";
//    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
//    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark ---- scrolldelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float y = scrollView.contentOffset.y;
    if (y>0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    y = MIN(0, y);
    _imagView.transform = CGAffineTransformMakeScale(1.0-y/300, 1.0-y/300);
}


#pragma mark --- tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        FavoVideoListController *controller = [[FavoVideoListController alloc]init];
        [self pushWithoutTabbar:controller];
    }
    
    if (indexPath.row == 3) {
        [WXApiRequestHandler sendAppContentData:nil
                                        ExtInfo:@""
                                         ExtURL:nil
                                          Title:@"刀一把"
                                    Description:@"最新最热Dota视频App"
                                     MessageExt:nil
                                  MessageAction:nil
                                     ThumbImage:nil
                                        InScene:WXSceneSession];
    }
    if (indexPath.row == 4) {
        
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
    picker.maximumNumberOfSelectionMedia = 1;
    picker.maximumNumberOfSelectionVideo = 0;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}



#pragma mark --- UzysAssetsPickerControllerDelegate

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
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
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
