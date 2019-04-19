//
//  AflchSetTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AflchSetTableViewCell.h"

@implementation AflchSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)edit:(UIButton *)sender {
    self.editBlock();
}
- (IBAction)delet:(UIButton *)sender {
    self.deleteBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
