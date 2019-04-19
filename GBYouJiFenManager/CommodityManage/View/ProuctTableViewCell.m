//
//  ProuctTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProuctTableViewCell.h"

@implementation ProuctTableViewCell

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
-(void)setDataWithModel:(ProductModel *)model Type:(NSString*)type
{
    if ([type isEqualToString:@"Comb"])
    {
        self.productName.text=model.RetailPrice;
        self.classiFy.text=model.ProductName;
        if (model.bom.length>0)
        {
            self.price.text=@"已编辑";
        }else
        {
            self.price.text=@"未编辑";
            self.price.textColor=[UIColor blueColor];
        }

       

        
    }else if([type isEqualToString:@"overFlow"])
    {
        self.productName.text=model.ProductName;
        self.classiFy.text=model.ClassifyName;
        if ([model.IsWeigh isEqualToString:@"True"])
        {
            
            self.price.text=@"是";
        }else
        {
            self.price.text=@"否";
          
        }
        

        
        
    }else
    {
        self.productName.text=model.ProductName;
        self.classiFy.text=model.ClassifyName;
        self.price.text=model.RetailPrice;
    }
   
}
-(void)setChoseView:(UILabel *)choseView
{
    _choseView=choseView;
            self.choseView.layer.cornerRadius=10;
    self.choseView.layer.masksToBounds=YES;
            self.choseView.backgroundColor=[UIColor whiteColor];
            self.choseView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            self.choseView.layer.borderWidth=1;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
