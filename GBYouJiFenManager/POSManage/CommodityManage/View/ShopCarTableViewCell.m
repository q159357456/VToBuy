//
//  ShopCarTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ShopCarTableViewCell.h"
#import "ProductModel.h"
#import "POSDIModel.h"
@implementation ShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(INV_ProductModel *)model
{

    self.bottomHeight.constant=model.height;
           _lable1.text=model.ProductName;
            _lable2.text=[NSString stringWithFormat:@"¥%@",model.RetailPrice];
            _lable3.text=[NSString stringWithFormat:@"%ld",model.count];
    _lable4.numberOfLines=0;
    _lable4.text=model.detailMuStr;
    _lable4.lineBreakMode = NSLineBreakByWordWrapping;
         _lable4.text=model.detailMuStr;
    
}
- (IBAction)pluse:(UIButton *)sender {
    self.minceBlock();
    
}
- (IBAction)mince:(UIButton *)sender {
    self.addBlock(sender);
}
-(void)setRLable:(UILabel *)rLable
{
    _rLable=rLable;
    _rLable.layer.cornerRadius=5;
    _rLable.layer.masksToBounds=YES;
    _rLable.backgroundColor=navigationBarColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
