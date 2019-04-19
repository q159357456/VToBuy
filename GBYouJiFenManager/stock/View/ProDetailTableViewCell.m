//
//  ProDetailTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProDetailTableViewCell.h"

@implementation ProDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)pluse:(UIButton *)sender {
    self.addBlock(sender);
}
- (IBAction)mince:(UIButton *)sender {
    self.minceBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
