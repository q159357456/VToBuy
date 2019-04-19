//
//  ProDetailTwoTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProDetailTwoTableViewCell.h"

@implementation ProDetailTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(ADShopInfoModel *)model
{
    NSString *path=[NSString stringWithFormat:@"%@/%@",PICTUREPATH,[NSString stringWithFormat:@"%@",model.logourl]];
    NSString *codePath=[path URLEncodedString];
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:codePath] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.shopName.text=model.ShopName;
    self.adressLable.text=model.address;
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setButt:(UIButton *)butt
{
    butt.layer.cornerRadius=4;
    butt.layer.masksToBounds=YES;
    butt.layer.borderColor=navigationBarColor.CGColor;
    butt.layer.borderWidth=1;
    [butt setTitleColor:navigationBarColor forState: UIControlStateNormal];
    butt.enabled=NO;
}
@end
