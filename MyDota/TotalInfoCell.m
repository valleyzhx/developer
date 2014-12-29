//
//  TotalInfoCell.m
//  MyDota
//
//  Created by Simplan on 14/12/28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "TotalInfoCell.h"
#define everyWidth (screenWidth-16)/5.0
#define viewWidth (everyWidth-1*(screenWidth/320.0))

@implementation TotalInfoCell{
    NSMutableArray *viewArr;
    NSMutableArray *imageViewArr;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        viewArr = [[NSMutableArray alloc]init];
        imageViewArr = [[NSMutableArray alloc]init];
        NSArray *array = @[@"总场次",@"胜率",@"胜利场次",@"失败场次",@"逃跑率"];
        for (int i=0; i<5; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8+everyWidth*i, 8, viewWidth, 45)];
            view.backgroundColor = [UIColor lightGrayColor];
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, viewWidth, 20)];
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.text = array[i];
            titleLab.font = [UIFont systemFontOfSize:13];
            titleLab.textColor = [UIColor darkTextColor];
            UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 25)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.font = [UIFont systemFontOfSize:15];
            contentLab.textColor = [UIColor greenColor];
            [view addSubview:titleLab];
            [view addSubview:contentLab];
            contentLab.tag = 2;
            [self.contentView addSubview:view];
            [viewArr addObject:view];
        }
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(8, 58, 75, 40)];
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = @"擅长英雄:";
        [self.contentView addSubview:lab];
        for (int i=0; i<3; i++) {
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(80+45*i, 53+5, 40, 40)];
            [self.contentView addSubview:view];
            [imageViewArr addObject:view];
        }
        
    }
    return self;
}
-(void)setCellDataWithData:(NSDictionary*)infoDic{
    NSArray *array = @[infoDic[@"Total"],infoDic[@"R_Win"],infoDic[@"Win"],infoDic[@"Lost"],infoDic[@"OfflineFormat"]];
    NSArray *imgArr = @[infoDic[@"AdeptHero1"],infoDic[@"AdeptHero2"],infoDic[@"AdeptHero3"]];
    for (int i=0; i<viewArr.count; i++) {
        UIView *view = viewArr[i];
        UILabel *lab = (UILabel*)[view viewWithTag:2];
        lab.text = [NSString stringWithFormat:@"%@",array[i]];
    }
    for (int i=0;i<imageViewArr.count;i++) {
        UIImageView *view = imageViewArr[i];
        NSString *heroStr = imgArr[i];
        if (heroStr.length) {
            [view sd_setImageWithURL:[NSURL URLWithString:img11Url(heroStr)]];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected statehttp://i.5211game.com/img/dota/hero/N0EG.jpg
}

@end
