//
//  ReasonTableViewCell.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ReasonTableViewCell.h"

@implementation ReasonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSelectImage:(UIImageView *)selectImage
{
    _selectImage=selectImage;
//    _selectImage.layer.cornerRadius=self.selectImage.frame.size.width/2;
//    _selectImage.layer.masksToBounds=YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
