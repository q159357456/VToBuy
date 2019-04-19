//
//  FloorTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "FloorTableViewCell.h"

@implementation FloorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setChoseView:_selectLab];
    [self initLabel];
}

-(void)initLabel
{
    _floorLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, screen_width-30, 40)];
    _floorLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_floorLab];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)setDataWithModel:(FloorModel *)model
{
    
    self.floorLab.text = model.FloorInfo;
    
}

-(void)setDataWithModel1:(RoomTypeModel*)model
{
    self.floorLab.text = model.RoomName;
}

-(void)setDataWithModel2:(deliveryModel *)model
{
    self.floorLab.text = model.deliveryTime;
}

-(void)setChoseView:(UILabel *)selectLab
{
    _selectLab=selectLab;
    _selectLab.layer.cornerRadius=10;
    _selectLab.layer.masksToBounds=YES;
    _selectLab.backgroundColor=[UIColor whiteColor];
    _selectLab.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _selectLab.layer.borderWidth=1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
