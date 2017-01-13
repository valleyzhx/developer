//
//  ADViewController.m
//  MyDota
//
//  Created by Xiang on 15/11/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "ADViewController.h"
#import "MyDefines.h"
#import "GGRequest.h"
#import "UIImageView+AFNetworking.h"


@interface ADViewController ()<UIActionSheetDelegate>

@end

@implementation ADViewController{
    UIImageView *_imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"每日一句";
    self.view.backgroundColor = viewBGColor;
    _naviBar.backgroundView.alpha = 0;
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/5)];
    _imgView.userInteractionEnabled = YES;
    [self.view addSubview:_imgView];
    [self.view bringSubviewToFront:_naviBar];
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(panTheImageAction:)];
    [_imgView addGestureRecognizer:longPressGr];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_imgView.frame)+10, SCREEN_WIDTH-20, 200)];
    lab.numberOfLines = 0;
    //lab.text = @"这里是广告,谢谢点进来^_^";
//    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheAction:)];
    [lab addGestureRecognizer:tap];
    lab.userInteractionEnabled = YES;
    
    [GGRequest requestWithUrl:@"http://open.iciba.com/dsapi/" accepType:@"html" withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [operation.responseData jsonObject];
        if (dic) {
            NSString *content = dic[@"content"];
            NSString *note = dic[@"note"];
            NSString *dateline = dic[@"dateline"];
            NSString *url = dic[@"picture2"];
            if (note && content) {
                lab.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",content,note,dateline];
            }
            if (url.length) {
                [_imgView setImageWithURL:[NSURL URLWithString:url]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [MobClick event:@"ADViewController"];
}


-(void)tapTheAction:(UITapGestureRecognizer*)tap{
    [self loadFullADView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    
    return self;
}


-(void)dealloc{

}

#pragma mark ---- Action

-(void)panTheImageAction:(UILongPressGestureRecognizer*)gesture{
    
    UIGestureRecognizerState state = gesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [sheet showInView:self.view];
    }
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self saveImageToAlbum];
    }
}


- (void)saveImageToAlbum{
    UIImageWriteToSavedPhotosAlbum(_imgView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"保存成功";
    }else
    {
        message = [error description];
    }
    [MBProgressHUD showString:message inView:self.view];

}


@end
