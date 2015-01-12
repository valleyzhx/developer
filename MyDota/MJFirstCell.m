//
//  MJFirstCell.m
//  MyDota
//
//  Created by Simplan on 14/12/30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "MJFirstCell.h"
#define theR 80

@implementation MJFirstCell{
    float maxNum;
    NSMutableArray *numArr;
    float win;
}
/*
 AdeptHero1 = Nbrn;
 AdeptHero2 = EC77;
 AdeptHero3 = Udea;
 AdeptHeroId1 = 1315074670;
 AdeptHeroId2 = 1162032951;
 AdeptHeroId3 = 1432642913;
 AdeptHeroName1 = "\U5353\U5c14\U6e38\U4fa0";
 AdeptHeroName2 = "\U876e\U86c7";
 AdeptHeroName3 = "\U5730\U72f1\U9886\U4e3b";
 BuWang = 9;
 ConsumeScore = 113;
 CreepKilled = 0;
 "D_Win" = "0.4193548387096774";
 DenyRax = 0;
 DenyTower = 8;
 DoubleKill = 85;
 FuHao = 14;
 GameScore = 1000;
 HeroAssist = 1363;
 HeroDeath = 901;
 HeroDeny = 459;
 HeroHit = 9994;
 HeroKill = 774;
 HitRax = 45;
 HitTower = 95;
 Lost = 90;
 MVP = 13;
 MingJiang = "Lv.9";
 "MingJiang_D" = 9;
 NeutralKill = 1841;
 Offline = 2;
 OfflineFlag = 0;
 OfflineFormat = "0.00%";
 Other = 20;
 "P_Win" = "41.94%";
 PianJiang = 15;
 PoDi = 15;
 PoJun = 9;
 "R_Win" = "41.94%";
 Roshan = 36;
 ScoreType = 10001;
 Sum = 155;
 TopKill = 0;
 Total = 155;
 TripleKill = 15;
 UserID = 303488438;
 Win = 65;
 WinBit = 50;
 WinFlag = 361554868469848;
 YingHun = 12;
 llResv = 0;
 offlineBit = 50;
 */
- (void)awakeFromNib {
    // Initialization code
    numArr = [[NSMutableArray alloc]init];
}
-(void)setCellDataWithMJInfo:(NSDictionary*)infoDic{
    
    NSArray *keys = @[@"MVP",@"BuWang",@"PoJun",@"FuHao",@"PianJiang",@"PoDi"];
    win = [infoDic[@"P_Win"]floatValue];
    int sum = [infoDic[@"Sum"]intValue];
    if (sum<=0) {
        return;
    }
    if (sum<=10) {
        maxNum = sum/1.3;
    }else if(sum<100){
        maxNum = sum/2;
    }else if (sum<500){
        maxNum = sum/3.3;
    }else{
        maxNum = sum/4.5;
    }
    int temMax = 0;
    for (NSString *key in keys) {
        temMax = MAX(temMax, [infoDic[key]intValue]);
        [numArr addObject:infoDic[key]];
    }
    if (temMax/maxNum>=1.0) {
        maxNum = temMax;
    }
    _mvpLab.text = [NSString stringWithFormat:@"MVP:%d/%.2f",[infoDic[@"MVP"]intValue],[infoDic[@"MVP"]floatValue]/sum];
    _podiLab.text = [NSString stringWithFormat:@"破敌:%d/%.2f",[infoDic[@"PoDi"]intValue],[infoDic[@"PoDi"]floatValue]/sum];
    _pojunLab.text = [NSString stringWithFormat:@"破军:%d/%.2f",[infoDic[@"PoJun"]intValue],[infoDic[@"PoJun"]floatValue]/sum];
    _fuhaoLab.text = [NSString stringWithFormat:@"富豪:%d/%.2f",[infoDic[@"FuHao"]intValue],[infoDic[@"FuHao"]floatValue]/sum];
    _assisLab.text = [NSString stringWithFormat:@"助攻:%d/%.2f",[infoDic[@"PianJiang"]intValue],[infoDic[@"PianJiang"]floatValue]/sum];
    _fanbuLab.text = [NSString stringWithFormat:@"补王:%d/%.2f",[infoDic[@"BuWang"]intValue],[infoDic[@"BuWang"]floatValue]/sum];
    _yinghunLab.text = [NSString stringWithFormat:@"英魂:%d/%.2f",[infoDic[@"YingHun"]intValue],[infoDic[@"YingHun"]floatValue]/sum];
    
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1, -1);//反转坐标
    
    CGColorRef backColorRef = [UIColor lightGrayColor].CGColor;
    CGContextSetStrokeColorWithColor(context, backColorRef);
    CGContextSetLineWidth(context, 1);
    CGFloat lengths[] = {10,2};
    CGContextSetLineDash(context, 0, lengths,2);
    
    float r = theR;
    int n = 4;
    double ang = M_PI/3;
    CGPoint oriPoint = CGPointMake(theR+20+5, theR+20);
    
    for (int i=1; i<=6; i++) {
        CGContextMoveToPoint(context, oriPoint.x, oriPoint.y);
        CGPoint newPoint = CGPointMake(r*cos(ang)+oriPoint.x, r*sin(ang)+oriPoint.y);
        CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:10];
        lab.center = CGPointMake(1.15*r*cos(ang)+oriPoint.x, 1.15*r*sin(ang)+oriPoint.y);
        lab.textColor = [UIColor blueColor];
        lab.text = @[@"助攻",@"金钱",@"推塔",@"反补",@"综合",@"杀敌"][i-1];
        [self addSubview:lab];
        ang += M_PI/3;
    }
    
    int newR = r/n;
    for (int k=1; k<=n; k++) {
        r=newR*k;
        CGPoint firstPoint = CGPointMake(r*cos(ang)+oriPoint.x, r*sin(ang)+oriPoint.y);
        CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
        ang = M_PI/3*2;
        for (int i=1; i<=6; i++) {
            CGPoint newPoint = CGPointMake(r*cos(ang)+oriPoint.x, r*sin(ang)+oriPoint.y);
            CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
            ang += M_PI/3;
        }
        ang = M_PI/3;
    }
    CGContextStrokePath(context);
    CGFloat lengs[] = {10,0};
    CGContextSetLineDash(context, 0, lengs,2);
    backColorRef = [UIColor blueColor].CGColor;
    CGContextSetStrokeColorWithColor(context, backColorRef);
    r = ([numArr[0]floatValue]/maxNum)*theR;
    ang = M_PI/3;
    CGPoint firstPoint = CGPointMake(r*cos(ang)+oriPoint.x, r*sin(ang)+oriPoint.y);
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    ang = M_PI/3*2;
    for (int i=1; i<=6; i++) {
        r = ([numArr[MIN(i, 5)]floatValue]/maxNum)*theR;
        CGPoint newPoint = CGPointMake(r*cos(ang)+oriPoint.x, r*sin(ang)+oriPoint.y);
        if(i==6){
            newPoint = firstPoint;
        }
        CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
        ang += M_PI/3;
    }
    CGContextStrokePath(context);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
