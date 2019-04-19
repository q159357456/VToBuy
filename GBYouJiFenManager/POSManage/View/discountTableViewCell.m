//
//  discountTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "discountTableViewCell.h"

@implementation discountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initLabel];
    
    [self setChooseView:_selectLab];
}

-(void)initLabel
{
    _lab1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (screen_width-30)/5, 40)];
    _lab1.textAlignment = NSTextAlignmentCenter;
    _lab1.font = [UIFont systemFontOfSize:12];
    
    
    _lab2 = [[UILabel alloc] initWithFrame:CGRectMake(30+(screen_width-30)/5, 0, (screen_width-30)/5, 40)];
    _lab2.textAlignment = NSTextAlignmentCenter;
    _lab2.font = [UIFont systemFontOfSize:12];
    
    
    _lab3 = [[UILabel alloc] initWithFrame:CGRectMake(30+2*(screen_width-30)/5, 0, (screen_width-30)/5, 40)];
    _lab3.textAlignment = NSTextAlignmentCenter;
    _lab3.font = [UIFont systemFontOfSize:12];
    
    
    _lab4 = [[UILabel alloc] initWithFrame:CGRectMake(30+3*(screen_width-30)/5, 0, (screen_width-30)/5, 40)];
    _lab4.textAlignment = NSTextAlignmentCenter;
    _lab4.font = [UIFont systemFontOfSize:12];
    
    
    _lab5 = [[UILabel alloc] initWithFrame:CGRectMake(30+4*(screen_width-30)/5, 0, (screen_width-30)/5, 40)];
    _lab5.textAlignment = NSTextAlignmentCenter;
    _lab5.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:_lab1];
    [self.contentView addSubview:_lab2];
    [self.contentView addSubview:_lab3];
    [self.contentView addSubview:_lab4];
    [self.contentView addSubview:_lab5];
}

-(void)setChooseView:(UILabel *)selectLabel
{
    _selectLab = selectLabel;
    _selectLab.layer.cornerRadius = 10;
    _selectLab.layer.masksToBounds = YES;
    _selectLab.backgroundColor = [UIColor whiteColor];
    _selectLab.layer.borderWidth = 1;
    _selectLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


-(void)setDataWithModel:(discountModel *)model
{
    _lab1.text = model.discountName;
    _lab2.text = model.discountType;
    _lab3.text = model.appointDiscount;
    _lab4.text = model.printDiscount;
    _lab5.text = model.discountMoney;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
