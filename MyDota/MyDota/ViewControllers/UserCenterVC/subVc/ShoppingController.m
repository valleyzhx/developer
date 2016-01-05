//
//  ShoppingController.m
//  MyDota
//
//  Created by Xiang on 15/12/14.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "ShoppingController.h"
#import "MyDefines.h"
#import "GGWebController.h"

#define tailX (5*timesOf320)
#define btnWid ((SCREEN_WIDTH - 6*tailX)/5)
#define btnHei btnWid/3
#define viewH (tailX*2+btnHei)

@implementation ShoppingController{
    UISearchBar *_searchBar;
    UIButton *_backGroundBtn;
    UIView *_btnsView;
}


-(void)viewDidLoad{
    self.showGDTADView = YES;
    [super viewDidLoad];
    _naviBar.backgroundView.alpha = 1;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 22, (SCREEN_WIDTH - 50) , 40)] ;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setTranslucent:YES];
    
    [_naviBar addSubview:_searchBar];
    _searchBar.delegate = self;// 设置代理
    _backGroundBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
    _backGroundBtn.backgroundColor = [UIColor blackColor];
    _backGroundBtn.alpha = 0;
    [_backGroundBtn addTarget:self action:@selector(clickedTheBackGround:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_backGroundBtn belowSubview:_naviBar];
    
    
    [self setBtnsViewUI];
    
    
    [_searchBar becomeFirstResponder];
}

-(void)setBtnsViewUI{
    _btnsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviBar.frame), SCREEN_WIDTH, viewH)];
    _btnsView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[@"电竞",@"鼠标",@"键盘",@"Dota",@"游戏"];
    for (int i=0; i<5; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(tailX+i*(btnWid+tailX), tailX, btnWid, btnHei)];
        btn.layer.borderColor = Nav_Color.CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitleColor:Nav_Color forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn addTarget:self action:@selector(cilickTheViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btnsView addSubview:btn];
    }
    [self.view addSubview:_btnsView];
}


-(void)cilickTheViewBtn:(UIButton*)btn{
    NSString *name = [btn titleForState:UIControlStateNormal];
    [self loadWebViewWithName:name];
}


-(void)clickedTheBackGround:(UIButton*)btn{
    [_searchBar resignFirstResponder];
    [self animationWithBackgroundBtn:YES];
}




-(void)loadWebViewWithName:(NSString*)name{
    GGWebController *controller = [[GGWebController alloc]init];
    NSString *url = [NSString stringWithFormat:@"http://r.m.taobao.com/s?p=mm_20694712_12038828_43718712&q=%@",name];
    controller.urlString = url;
    controller.title = name;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark ---- UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self animationWithBackgroundBtn:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *text = searchBar.text;
    [self loadWebViewWithName:text];
}

#pragma BackgroundBtn Animate
-(void)animationWithBackgroundBtn:(BOOL)shouldHidden{
    float alpha = shouldHidden?0:0.5;
    [UIView animateWithDuration:0.6 animations:^{
        _backGroundBtn.alpha = alpha;
    }];
}
#pragma mark GDT Degetate
- (void)bannerViewDidReceived{
    if (![[self.view subviews]containsObject:_bannerView]) {
        _bannerView.center = CGPointMake(_bannerView.center.x, self.view.frame.size.height-40);
        [self.view insertSubview:_bannerView belowSubview:_backGroundBtn];
    }
}
@end
