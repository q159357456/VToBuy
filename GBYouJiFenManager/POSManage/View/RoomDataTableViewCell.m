//
//  RoomDataTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "RoomDataTableViewCell.h"

@implementation RoomDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setChoseView:_selectLab];
    [self initLabel];
}

-(void)initLabel
{
    _RoomNameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (screen_width-30)/3, 40)];
    _RoomNameLab.textAlignment = NSTextAlignmentCenter;
    
    _RoomTypeLab = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/3+30, 0, (screen_width-30)/3, 40)];
    _RoomTypeLab.textAlignment = NSTextAlignmentCenter;

    _FloorAreaLab = [[UILabel alloc] initWithFrame:CGRectMake(((screen_width-30)/3)*2+30, 0, (screen_width-30)/3, 40)];
    _FloorAreaLab.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_RoomNameLab];
    [self.contentView addSubview:_RoomTypeLab];
    [self.contentView addSubview:_FloorAreaLab];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)setDataWithModel:(roomDataModel *)model
{
    
    self.RoomNameLab.text = model.roomName;
    self.RoomTypeLab.text = model.roomType;
    self.FloorAreaLab.text = model.floorArea;
    
}

-(void)setDataWithModel1:(classesModel *)model
{
    self.RoomNameLab.text = model.classesName;
    self.RoomTypeLab.text = model.beginTime;
    self.FloorAreaLab.text = model.endTime;
}

-(void)setDataWithModel2:(offspringPrintModel *)model
{
    self.RoomNameLab.text = model.PrinterName;
    self.RoomTypeLab.text = model.PrinterIP;
    self.FloorAreaLab.text = model.BigClasses;
}

-(void)setDataWithModel3:(rechargeModel *)model
{
    self.RoomNameLab.text = model.CashNumber;
    self.RoomTypeLab.text = model.PresentNumber;
    self.FloorAreaLab.text = model.CreditsScore;
}

-(void)setDataWithModel4:(SettleBillModel *)model
{
    self.RoomNameLab.text = model.billName;
    if ([model.GetCode isEqualToString:@"0"]) {
        self.RoomTypeLab.text = @"非营业收入";
    }
    if ([model.GetCode isEqualToString:@"1"]) {
        self.RoomTypeLab.text = @"营业收入";
    }
    
    self.FloorAreaLab.text = model.BillCode;
}

-(void)setDataWithModel5:(userAccountModel *)model
{
    self.RoomNameLab.text = model.Account_No;
    self.RoomTypeLab.text = model.Account_Name;
    if ([model.isSuper isEqualToString:@"True"]) {
        self.FloorAreaLab.text = @"是";
    }
    if ([model.isSuper isEqualToString:@"False"]) {
        self.FloorAreaLab.text = @"否";
    }
}


-(void)setDataWithModel6:(InternalRegisterModel *)model
{
    self.RoomNameLab.text = model.itemNo;
    self.RoomTypeLab.text = model.equipmentName;
    self.FloorAreaLab.text = model.roomName;
}

-(void)setChoseView:(UILabel *)selectLab
{
    _selectLab=selectLab;
    _selectLab.layer.cornerRadius = 10;
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
