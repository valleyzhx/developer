//
//  HeroInfoCell.h
//  MyDota
//
//  Created by Simplan on 14/12/28.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *winLostLab;
-(void)setSocreWithData:(NSDictionary*)heroInfo;
@end
