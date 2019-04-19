//
//  BillStateTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BillStateTableViewCell.h"

@implementation BillStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithMode:(ADBillModel *)model
{
    self.billNoLable.text=[NSString stringWithFormat:@"订单号:%@",model.SB002];
    if (screen_width==320) {
        
        
        self.billNoLable.font=[UIFont systemFontOfSize:13];
          self.timeLable.font=[UIFont systemFontOfSize:14];
          self.payModel.font=[UIFont systemFontOfSize:14];
    }
    self.priceLable.text=[NSString stringWithFormat:@"¥%@",model.SB023];
    self.timeLable.text=model.sb015;
    self.payModel.text=model.payment1;
 
}
- (IBAction)button4:(UIButton *)sender {
    self.touBlock(4);
}
- (IBAction)button3:(UIButton *)sender {
      self.touBlock(3);
}
- (IBAction)button2:(UIButton *)sender {
      self.touBlock(2);
}
- (IBAction)button1:(UIButton *)sender {
     self.touBlock(1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
