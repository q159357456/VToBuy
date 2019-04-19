//
//  AlreadyChosenTableViewCell.m
//  GBManagement
//
//  Created by 工博计算机 on 16/12/1.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "AlreadyChosenTableViewCell.h"

@implementation AlreadyChosenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(SBPModel *)model
{
    self.detailLable.numberOfLines=0;
    self.detailLable.lineBreakMode = NSLineBreakByWordWrapping;
    self.Dheight.constant=model.Bheight;

    self.detailLable.text=model.detailMuStr;
        

    self.productName.text=model.SBP005;
    float k=model.SBP009.floatValue;
    self.contLable.text=[NSString stringWithFormat:@"X%.0f",k];
  
    self.priceLable.text=[NSString stringWithFormat:@"¥%@",[model.SBP011 removeZeroWithStr]];
    
    if (model.SBP027.floatValue)
    {
        
        self.contentView.backgroundColor=[UIColor lightGrayColor];
        self.cancelButton.hidden=YES;
    }
    if ([model.SBP009 intValue]<0) {
        [self.cancelButton setTitle:@"已退" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.cancelButton.enabled=NO;
    }
    if (model.leftCount<=0) {
        self.cancelButton.enabled=NO;
    }
    
}
- (IBAction)tuiCai:(UIButton *)sender
{
    self.tuicaiBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
