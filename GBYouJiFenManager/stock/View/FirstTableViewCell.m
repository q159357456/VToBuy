//
//  FirstTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(ADShopInfoModel *)model
{
    NSString *path=[NSString stringWithFormat:@"%@/%@",PICTUREPATH,[NSString stringWithFormat:@"%@",model.logourl]];
    NSString *codePath=[path URLEncodedString];
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:codePath] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.shopLable.text=model.ShopName;
    self.adreeLable.text=[NSString stringWithFormat:@"%@%@%@%@",model.provName,model.cityName,model.boroName,model.address];
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
