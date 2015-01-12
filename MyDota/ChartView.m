//
//  ChartView.m
//  MyDota
//
//  Created by Simplan on 14/12/20.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "ChartView.h"
#define edge 10
#define average 4.0
#define ViewHeight 150
#define sliderHeight 50
@implementation ChartView
{
    NSArray *dataArray;
    UILabel *scoreLabel;
    float everyX;
    int min;
    int max;
    int tempTag;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(id)initWithArray:(NSArray *)rateArr{
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, ViewHeight+sliderHeight)];
    if (self) {
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, screenWidth, 20)];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:scoreLabel];
        dataArray = [rateArr copy];
        self.backgroundColor = [UIColor whiteColor];
        if (rateArr.count) {
            [self findMaxAndMinWithDataArray:rateArr];
            UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(edge, ViewHeight+10, screenWidth-2*edge, 5)];
            slider.maximumValue = screenWidth-edge;
            slider.minimumValue = edge;
            slider.value = slider.maximumValue;
            tempTag = (int)dataArray.count;
            [slider addTarget:self action:@selector(changeTheValue:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:slider];
        }
    }
    return self;
}
-(void)findMaxAndMinWithDataArray:(NSArray*)array{
     min = [array[0]intValue];
     max = [array[0]intValue];
    for (id num in array) {
        min = MIN(min, [num intValue]);
        max = MAX(max, [num intValue]);
    }
    min = (int)(min/100.0)*100;
    max = ceil(max/100.0)*100;
}
- (void)drawRect:(CGRect)rect {
    float ScoreHeight = (max-min)/average;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef backColorRef = [UIColor lightGrayColor].CGColor;
    CGContextSetStrokeColorWithColor(context, backColorRef);
    CGContextSetLineWidth(context, 1);
    
    float lineHeight = (ViewHeight-2*edge)/average;
    float startX = edge;
    float startY = ViewHeight-edge;
    for (int i=0; i<average+1; i++) {
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context,self.bounds.size.width-edge,startY);
        CGContextStrokePath(context);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(edge, startY, 100, 10)];
        lab.font = [UIFont systemFontOfSize:8];
        lab.text = [NSString stringWithFormat:@"%.0lf",min+ScoreHeight*i];
        [self addSubview:lab];
        startY -= lineHeight;
        
    }
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    
    everyX = (screenWidth-2*edge)/(dataArray.count-1);
    startX = edge;
    int firstScore = [[dataArray firstObject]intValue];
    startY = ((max-firstScore)/ScoreHeight)*lineHeight+edge;
    
    UIView *cirView = [[UIView alloc]initWithFrame:CGRectMake(startX-2, startY-2, 4, 4)];
    cirView.backgroundColor = [UIColor orangeColor];
    cirView.tag = 1;
    [self addSubview:cirView];
    
    for (int i=1; i<dataArray.count; i++) {
        id num = dataArray[i];
        CGContextMoveToPoint(context, startX, startY);
        startX += everyX;
        startY = ((max-[num intValue])/ScoreHeight)*lineHeight+edge;
        CGContextAddLineToPoint(context,startX,startY);
        CGContextStrokePath(context);
        UIView *cirView = [[UIView alloc]initWithFrame:CGRectMake(startX-2, startY-2, 4, 4)];
        cirView.backgroundColor = [UIColor orangeColor];
        cirView.tag = i+1;
        [self addSubview:cirView];
        
    }
    UIView *view = [self viewWithTag:tempTag];
    view.backgroundColor = [UIColor greenColor];
    
}
-(void)changeTheValue:(UISlider*)slider{
    int index = (slider.value-edge)/everyX;
    int num = [dataArray[index]intValue];
    scoreLabel.text = [NSString stringWithFormat:@"%d",num];
    if (tempTag!=index+1) {
        UIView *view = [self viewWithTag:tempTag];
        view.backgroundColor = [UIColor orangeColor];
        UIView *newView = [self viewWithTag:index+1];
        newView.backgroundColor = [UIColor greenColor];
        tempTag = index+1;
    }
}

@end
