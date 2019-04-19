//
//  PersonTwoTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PersonTwoTableViewCell.h"

@implementation PersonTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)copy:(UIButton *)sender {
    self.copyBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
