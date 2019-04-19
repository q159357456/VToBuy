//
//  TastManagerCollectionViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "TastManagerCollectionViewCell.h"

@implementation TastManagerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deletBut:(UIButton *)sender {
    self.deletBlock();
}

@end
