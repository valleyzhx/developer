//
//  MJFirstCell.h
//  MyDota
//
//  Created by Simplan on 14/12/30.
//  Copyright (c) 2014年 Simplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJFirstCell : UITableViewCell
-(void)setCellDataWithMJInfo:(NSDictionary*)infoDic;
@property (weak, nonatomic) IBOutlet UILabel *mvpLab;
@property (weak, nonatomic) IBOutlet UILabel *podiLab;
@property (weak, nonatomic) IBOutlet UILabel *pojunLab;
@property (weak, nonatomic) IBOutlet UILabel *fuhaoLab;
@property (weak, nonatomic) IBOutlet UILabel *assisLab;
@property (weak, nonatomic) IBOutlet UILabel *fanbuLab;
@property (weak, nonatomic) IBOutlet UILabel *yinghunLab;

@end
