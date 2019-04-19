//
//  trreeTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "trreeTableViewCell.h"

@implementation trreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)select:(UIButton *)sender
{
    self.selectedBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
