//
//  UpPictureCollectionViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "UpPictureCollectionViewCell.h"

@implementation UpPictureCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)close:(UIButton *)sender
{
    self.closeBlock();
}

@end
