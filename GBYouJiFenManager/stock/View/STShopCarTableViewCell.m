//
//  STShopCarTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "STShopCarTableViewCell.h"

@implementation STShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(ProductModel *)model
{
    if (model.selected)
    {
        
        self.selLable.backgroundColor=navigationBarColor;
    }else
    {
        
         self.selLable.backgroundColor=[UIColor whiteColor];
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1];
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:[url URLEncodedString]] placeholderImage:[UIImage imageNamed:@"shzx"]];
    self.product.text=model.ProductName;
    self.proCount.text=[NSString stringWithFormat:@"X%ld",model.count];
    self.countLable.text=[NSString stringWithFormat:@"%ld",model.count];
    self.priceLable.text=[NSString stringWithFormat:@"¥%@",model.RetailPrice];
}
-(void)setSelLable:(UILabel *)selLable
{
    _selLable=selLable;
    _selLable.layer.cornerRadius=10;
    _selLable.layer.masksToBounds=YES;
    _selLable.layer.borderWidth=1;
    _selLable.layer.borderColor=[UIColor lightGrayColor].CGColor;
}
-(void)setHideen
{
    self.pluse.hidden=YES;
    self.mince.hidden=YES;
    self.countLable.hidden=YES;
}
-(void)setNoHideen{
    self.pluse.hidden=NO;
    self.mince.hidden=NO;
    self.countLable.hidden=NO;
}
- (IBAction)mince:(UIButton *)sender {
   
    self.minceBlock();
}
- (IBAction)pluse:(UIButton *)sender {
    
    self.pluseBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
