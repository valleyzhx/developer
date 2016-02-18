//
//  VideoListCell.m
//  MyDota
//
//  Created by Xiang on 15/10/18.
//  Copyright © 2015年 iOGG. All rights reserved.
//

#import "VideoListCell.h"
#import "MyDefines.h"

@implementation VideoListCell

- (void)awakeFromNib {
    // Initialization code
    _publishLab.textColor = TextLightColor;
    _titleLab.textColor = TextDarkColor;
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
