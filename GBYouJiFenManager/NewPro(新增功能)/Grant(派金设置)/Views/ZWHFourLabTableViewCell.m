//
//  ZWHFourLabTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHFourLabTableViewCell.h"

@implementation ZWHFourLabTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    //CellLine
    
    CGFloat cellwid = SCREEN_WIDTH/5;
    
    
    _one = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    _one.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_one];
    [_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(cellwid/2);
        make.centerY.equalTo(self.contentView);
    }];
    
    _two = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    _two.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_two];
    [_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(cellwid*1.5);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_PRO(60));
    }];
    
    _three = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    _three.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_three];
    [_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(cellwid*2.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    _four = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    _four.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_four];
    [_four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(cellwid*3.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    _five = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    _five.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_five];
    [_five mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_left).offset(cellwid*4.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    _one.text = @"参加时间";
    _two.text = @"姓名";
    _three.text = @"金额";
    _four.text = @"份数";
    _five.text = @"派派金";
}


-(void)setModel:(ZWHPieListModel *)model{
    _model = model;
    NSString *string =_model.chargedate;
    NSRange range = [string rangeOfString:@"T"];//匹配得到的下标
    string = [string substringWithRange:NSMakeRange(0, range.location)];
    _one.text = string;
    _two.text = _model.membername;
    _three.text = [NSString stringWithFormat:@"¥%.2f",[_model.chargeamount floatValue]];
    _four.text = _model.piecopies;
    _five.text = [NSString stringWithFormat:@"¥%.2f",[_model.pieamount floatValue]];
    _five.textColor = [UIColor orangeColor];
    
}







@end
