//
//  ScoreViewController.m
//  MyDota
//
//  Created by Simplan on 14/11/6.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ScoreViewController.h"
#import "ASIFormDataRequest.h"
#import "ScoreData.h"
#import "MyLoadingView.h"
#import "ScoreDetialViewController.h"
#import "LoadingView.h"
#import "MobClick.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController{
    ScoreDetialViewController *controllor;
    ScoreData *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[MyLoadingView shareLoadingView]showLoadingIn:self.view];
    _findBtn.hidden = YES;
    ASIFormDataRequest *requset = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://passport.5211game.com/11/t/login.aspx?siteid=50005&returnurl=http%3a%2f%2fi.5211game.com%2fLogin.aspx%3freturnurl%3dhttp%253a%252f%252fi.5211game.com%253a80%252f"]];
    [requset setRequestMethod:@"POST"];
     NSString * __VIEWSTATE = @"/wEPDwULLTEyMzI3ODI2ODBkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBQxVc2VyQ2hlY2tCb3jQIGg7DwVBcZCffRMxe03M18OedA==";
     NSString* __EVENTVALIDATION = @"/wEWBQLe2+mbAQLB2tiHDgK1qbSWCwL07qXZBgLmwdLFDZc2mILMY55IspHL6KQgO25sOuhz";
    
    [requset addPostValue:__VIEWSTATE forKey:@"__VIEWSTATE"];
    [requset addPostValue:__EVENTVALIDATION forKey:@"__EVENTVALIDATION"];
    [requset addPostValue:@"骄傲的灭亡" forKey:@"txtUser"];
    [requset addPostValue:@"liujiann" forKey:@"txtPassWord"];
    [requset addPostValue:@"登录" forKey:@"butLogin"];
    [requset addPostValue:@"on" forKey:@"UserCheckBox"];
    //butLogin:登录 UserCheckBox:on
    [requset setCompletionBlock:^{
        [[MyLoadingView shareLoadingView]stopWithFinished:^{
            _findBtn.hidden = NO;
        }];
    }];
    [requset setFailedBlock:^{
        
        
    }];

    [requset startAsynchronous];
#if DEBUG
    _myTextField.text = @"骄傲的灭亡";
#endif
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, screenHeight-90, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _adView = [[AdMoGoView alloc]initWithAppKey:@"b54208fc718045ada08654e52d010b0e" adType:AdViewTypeNormalBanner adMoGoViewDelegate:self autoScale:YES];
    _adView.frame = CGRectZero;
    [_adView setViewPointType:AdMoGoViewPointTypeDown_left];
    [self.view addSubview:_adView];
    
}
-(UIViewController*)viewControllerForPresentingModalView{
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)checkAction:(id)sender {
    [(UIButton*)sender setUserInteractionEnabled:NO];
    [self doCheckUserName:_myTextField.text];
}

- (IBAction)returnTheKeyBoard:(id)sender {
    
    [_myTextField resignFirstResponder];
    
}
-(void)doCheckUserName:(NSString*)name{
    NSNumber *uid = [[NSUserDefaults standardUserDefaults]objectForKey:name];
    if (uid.intValue !=0) {
        [self getTheScoreWithUid:uid];
        return;
    }
   __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/?r=1415282734594"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:@"getuidbypname" forKey:@"method"];
    [request setCompletionBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (result.count) {
            if ([result[@"error"]intValue]==0) {
                NSNumber *uid = result[@"uid"];
                [[NSUserDefaults standardUserDefaults]setObject:uid forKey:name];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self getTheScoreWithUid:uid];
            }else{
                LoadingView *view = [[LoadingView alloc]initWithString:@"没有此用户信息"];
                [view show];
            }
            
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)getTheScoreWithUid:(NSNumber*)uid{
  __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/rating/?r=1415283385790"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"getrating" forKey:@"method"];
    [request addPostValue:uid forKey:@"u"];
    [request addPostValue:@"10001" forKey:@"t"];
    [request setCompletionBlock:^{
        //NSLog(@"%@",request.responseString);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        int error = [dic[@"error"]intValue];
        if (error==0) {
            data = [[ScoreData alloc]initWith11Dic:dic];
            controllor = [[ScoreDetialViewController alloc]initWithNibName:@"ScoreDetialViewController" bundle:nil withData:data];
            controllor.userId = uid;
            if (data.jjcInfos) {
                [self loadJJCScore:uid];
            }else if (data.ttInfos){
                [self loadTTScore:uid];
            }else{
                [self presentDetailController];
            }
            
            
        }
    }];
    [request startAsynchronous];
}
-(void)loadJJCScore:(NSNumber*)_userId{
   __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/rating/?r=1420112767953"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"ladderheros" forKey:@"method"];
    [request addPostValue:_userId forKey:@"u"];
    [request addPostValue:@"10032" forKey:@"t"];
    [request setCompletionBlock:^{
        //NSLog(@"%@",request.responseString);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        int error = [dic[@"error"]intValue];
        if (error==0) {
            controllor.jjcScoreInfoDic = dic;
            if (data.ttInfos){
                [self loadTTScore:_userId];
            }else{
                [self presentDetailController];
            }
            
        }
    }];
    [request startAsynchronous];
}
-(void)loadTTScore:(NSNumber*)_userId{
   __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/rating/?r=1419043495810"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"ladderheros" forKey:@"method"];
    [request addPostValue:_userId forKey:@"u"];
    [request addPostValue:@"10001" forKey:@"t"];
    [request setCompletionBlock:^{
        //NSLog(@"%@",request.responseString);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        int error = [dic[@"error"]intValue];
        if (error==0) {
            controllor.ttScoreInfoDic = dic;
            [self presentDetailController];
        }
    }];
    [request startAsynchronous];
}
-(void)presentDetailController{
    [_findBtn setUserInteractionEnabled:YES];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controllor];
    controllor.title = _myTextField.text;
    [self presentViewController:nav animated:YES completion:nil];
    [MobClick event:watchVideoView];
}
-(void)dealloc{
    controllor = nil;
}
-(void)backAction:(UIButton*)btn{
    btn.hidden = YES;
    float y = 0;
    if (!iOS7) {
        y = -20;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width*1.5, self.view.center.y+y);
        self.view.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    [_findBtn setUserInteractionEnabled:YES];
}
@end
