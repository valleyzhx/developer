//
//  HeroInfoCell.m
//  MyDota
//
//  Created by Simplan on 14/12/28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import "HeroInfoCell.h"


@implementation HeroInfoCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setSocreWithData:(NSDictionary*)heroInfo{
    _titleLab.text = heroInfo[@"heroname"];
    _winLostLab.text = [NSString stringWithFormat:@"%@胜%@负",heroInfo[@"win"],heroInfo[@"lost"]];
    _scoreLab.text = [NSString stringWithFormat:@"%@",heroInfo[@"score"]];
    _iconView.image = nil;

    [_iconView sd_setImageWithURL:[NSURL URLWithString:img11Url(heroInfo[@"heroId"])]];

}
-(void)setMingJiangWithData:(NSDictionary *)heroInfo{
    _titleLab.text = heroInfo[@"heroname"];
    _winLostLab.text = [NSString stringWithFormat:@"%@胜%@负",heroInfo[@"win"],heroInfo[@"lost"]];
    _scoreLab.text = [NSString stringWithFormat:@"%@",heroInfo[@"cscore"]];
    _iconView.image = nil;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:img11Url(heroInfo[@"heroId"])]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
