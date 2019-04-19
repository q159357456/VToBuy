//
//  ZWHPaiFaTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHPaiFaTableViewCell.h"

@implementation ZWHPaiFaTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    CellLine
    
    _title = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    _title.text = @"派派金发送";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.qmui_borderColor = LINECOLOR;
    _title.qmui_borderWidth = 1;
    _title.qmui_borderPosition = QMUIViewBorderPositionRight;
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(8));
        make.width.mas_equalTo(WIDTH_PRO(90));
        make.height.mas_equalTo(HEIGHT_PRO(30));
        make.centerY.equalTo(self.contentView);
    }];
    
    _time = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"creatSeat_1"] title:@"a"];
    [_time setTitleColor:[UIColor blackColor] forState:0];
    _time.titleLabel.font = ZWHFont(14);
    _time.imagePosition = QMUIButtonImagePositionRight;
    [self.contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(self.contentView);
    }];
    
    _paisong = [[QMUIButton alloc]qmui_initWithImage:nil title:@"派送"];
    [_paisong setTitleColor:[UIColor whiteColor] forState:0];
    _paisong.titleLabel.font = ZWHFont(12);
    _paisong.backgroundColor = navigationBarColor;
    _paisong.layer.cornerRadius = 4;
    _paisong.layer.masksToBounds = YES;
    [self.contentView addSubview:_paisong];
    [_paisong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(8));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_PRO(45));
        make.height.mas_equalTo(HEIGHT_PRO(20));
    }];
    
    _reset = [[QMUIButton alloc]qmui_initWithImage:nil title:@"重算"];
    [_reset setTitleColor:[UIColor whiteColor] forState:0];
    _reset.titleLabel.font = ZWHFont(12);
    _reset.backgroundColor = [UIColor orangeColor];
    _reset.layer.cornerRadius = 4;
    _reset.layer.masksToBounds = YES;
    [self.contentView addSubview:_reset];
    [_reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_paisong.mas_left).offset(-WIDTH_PRO(8));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_PRO(45));
        make.height.mas_equalTo(HEIGHT_PRO(20));
    }];
    
    
    
}




@end
