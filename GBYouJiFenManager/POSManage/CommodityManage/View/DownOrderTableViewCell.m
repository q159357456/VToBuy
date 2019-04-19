//
//  DownOrderTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "DownOrderTableViewCell.h"

@implementation DownOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {


     
     
    }
    return self;
}
-(void)setDataWithModel:(INV_ProductModel*)model
{
    if ([model.Property isEqualToString:@"C"])
    {
        //套餐
        [self styleCWithStr:@"C"];
        self.minceButton.hidden=YES;
        
    }else
    {
        //非套餐
        if (model.POSDC)
        {
           
            //可选口味的情况
             [self styleCWithStr:@"P"];
             self.minceButton.hidden=YES;
            
        }else
        {
            //不可选口味的情况
              [self styleP];
            if (model.count==0)
            {
                self.minceButton.hidden=YES;
                self.lable4.hidden=YES;
            }else
            {
                
                self.minceButton.hidden=NO;
                self.lable4.hidden=NO;
            }
        }
       
        
        
    }

    NSString *url=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[url URLEncodedString]] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.lable1.text=model.ProductName;
    self.lable2.text=[NSString stringWithFormat:@"¥%@",model.RetailPrice];
    self.lable4.text=[NSString stringWithFormat:@"%ld",model.count];

}
-(void)setMinceButton:(UIButton *)minceButton
{
    _minceButton=minceButton;
    _minceButton.hidden=YES;
    
}
-(void)setTastButton:(UIButton *)TastButton
{
    _TastButton=TastButton;
    _TastButton.layer.cornerRadius=8;
    _TastButton.layer.masksToBounds=YES;
    _TastButton.layer.borderWidth=1;
    _TastButton.layer.borderColor=MainColor.CGColor;
}
-(void)styleCWithStr:(NSString*)str
{
    if ([str isEqualToString:@"C"])
    {
        [_TastButton setTitle:@"选择套餐" forState:UIControlStateNormal];
    }else
    {
         [_TastButton setTitle:@"选择规格" forState:UIControlStateNormal];
    }
    
    _pluseButton.hidden=YES;
    _lable4.hidden=YES;
}
-(void)styleP
{
    _TastButton.hidden=YES;
    
}
- (IBAction)chooseTast:(UIButton *)sender
{

   
    self.chooseBlock(sender.titleLabel.text);
}
- (IBAction)pluse:(UIButton *)sender
{

    self.pluseBlock(self.headImage,self.pluseButton);
}
- (IBAction)mince:(UIButton *)sender
{
 
    self.minceBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
