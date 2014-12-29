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

@interface ScoreViewController ()

@end

@implementation ScoreViewController{
    ScoreDetialViewController *controllor;
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
        NSError *err = requset.error;
        
    }];

    [requset startAsynchronous];
    _myTextField.text = @"喑哑的平原";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)checkAction:(id)sender {
    
    [self doCheckUserName:_myTextField.text];
}
-(void)doCheckUserName:(NSString*)name{
    NSNumber *uid = [[NSUserDefaults standardUserDefaults]objectForKey:name];
    if (uid.intValue !=0) {
        [self getTheScoreWithUid:uid];
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/?r=1415282734594"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:@"getuidbypname" forKey:@"method"];
    [request setCompletionBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if (result.count) {
            NSNumber *uid = result[@"uid"];
            [[NSUserDefaults standardUserDefaults]setObject:uid forKey:name];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self getTheScoreWithUid:uid];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)getTheScoreWithUid:(NSNumber*)uid{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/rating/?r=1415283385790"]];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"getrating" forKey:@"method"];
    [request addPostValue:uid forKey:@"u"];
    [request addPostValue:@"10001" forKey:@"t"];
    [request setCompletionBlock:^{
        //NSLog(@"%@",request.responseString);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        int error = [dic[@"error"]intValue];
        if (error==0) {
            ScoreData *data = [[ScoreData alloc]initWith11Dic:dic];
            controllor = [[ScoreDetialViewController alloc]initWithNibName:@"ScoreDetialViewController" bundle:nil withData:data];
            controllor.userId = uid;
            
            [self loadTTScore:uid];
            
        }
    }];
    [request startAsynchronous];
}
-(void)loadTTScore:(NSString*)_userId{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://i.5211game.com/request/rating/?r=1419043495810"]];
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
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controllor];
            nav.title = _myTextField.text;
            [self presentModalViewController:nav animated:YES];

        }
    }];
    [request startAsynchronous];
}
-(void)dealloc{
    controllor = nil;
}
@end
