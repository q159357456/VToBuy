//
//  FinanciaOneTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FinanciaOneTableViewCell.h"
@interface FinanciaOneTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *colView;
@end
@implementation FinanciaOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setColView:(UILabel *)colView
{
    _colView=colView;
    _colView.backgroundColor=navigationBarColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
