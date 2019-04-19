
//  MobileSecondTableViewCell.m
//  GBYouJiFenManager
//  Created by mac on 17/5/5.
//  Copyright © 2017年 xia. All rights reserved.

#import "MobileSecondTableViewCell.h"

@implementation MobileSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self  setChoseView:_selectLab];

    [self initLabel];
}

-(void)initLabel
{
    _name = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (screen_width-30)/2, 40)];
    _name.textAlignment = NSTextAlignmentCenter;
    _number = [[UILabel alloc] initWithFrame:CGRectMake(30+(screen_width-30)/2, 0, (screen_width-30)/2, 40)];
    _number.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_number];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

//-(void)setDataWithModel:(InternalRegisterModel *)model
//{
//    self.name.text = model.POSNum;
//    self.number.text = model.equipmentName;
//}

-(void)setDataWithModel1:(PCRegisyerModel *)model
{
    self.name.text = model.PCMAC;
    self.name.numberOfLines = 3;
    self.name.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maxLabelSize = CGSizeMake((screen_width-30)/2, 60);
    CGSize expectSize = [self.name sizeThatFits:maxLabelSize];
    self.name.frame = CGRectMake(30, 0, expectSize.width, expectSize.height);
    self.name.textAlignment = NSTextAlignmentCenter;
    self.number.text = model.PCName;
}

-(void)setDataWithModel2:(TasteKindModel *)model
{
    self.name.text = model.classifyList;
    self.number.text = model.classifyName;
}

-(void)setDataWithModel3:(TasteRequestModel *)model
{
    self.name.text = model.tasteClasses;
    self.number.text = model.tasteName;
}

-(void)setDataWithModel4:(scheduleModel *)model
{
    self.name.text = model.beginTime;
    self.number.text = model.endTime;
}

-(void)setDataWithModel5:(RolePemissionModel *)model
{
    self.name.text = model.RoleNo;
    self.number.text = model.RoleNa;
}

-(void)setDataWithModel6:(ScaleModel *)model
{
    self.name.text = model.IPAddress;
    if ([model.StartUsing isEqualToString:@"True"]) {
        self.number.text = @"是";
    }
    if ([model.StartUsing isEqualToString:@"False"]) {
        self.number.text = @"否";
    }
}


-(void)setChoseView:(UILabel *)selectLab
{
    _selectLab=selectLab;
    _selectLab.layer.cornerRadius=10;//正方形的边长的一半 就是圆形
    _selectLab.layer.masksToBounds=YES;
    _selectLab.backgroundColor=[UIColor whiteColor];
    _selectLab.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _selectLab.layer.borderWidth=1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
