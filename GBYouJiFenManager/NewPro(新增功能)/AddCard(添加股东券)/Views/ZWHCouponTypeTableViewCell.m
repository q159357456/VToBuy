//
//  ZWHCouponTypeTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/17.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHCouponTypeTableViewCell.h"

@implementation ZWHCouponTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    _title = [[QMUILabel alloc]qmui_initWithFont:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = @"券类型";
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(90);
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    _title.qmui_borderWidth = 1;
    _title.qmui_borderColor = LINECOLOR;
    _title.qmui_borderPosition = QMUIViewBorderPositionRight;
    
    _normalBtn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"payType_1"] title:@"普通"];
    [_normalBtn setTitleColor:[UIColor blackColor] forState:0];
    _normalBtn.spacingBetweenImageAndTitle = 6;
    [self.contentView addSubview:_normalBtn];
    [_normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_right).offset(WIDTH_PRO(15));
        make.centerY.equalTo(_title);
    }];
    
    _vipBtn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"payType_1"] title:@"VIP"];
    [_vipBtn setTitleColor:[UIColor blackColor] forState:0];
    _vipBtn.spacingBetweenImageAndTitle = 6;
    [self.contentView addSubview:_vipBtn];
    [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_normalBtn.mas_right).offset(WIDTH_PRO(25));
        make.centerY.equalTo(_title);
    }];
    
    
    _shareholder = [[QMUIButton alloc]qmui_initWithImage:[[UIImage imageNamed:@"sj"] qmui_imageWithTintColor:[UIColor grayColor]] title:@"股东选择"];
    [_shareholder setTitleColor:[UIColor blackColor] forState:0];
    _shareholder.spacingBetweenImageAndTitle = 6;
    _shareholder.imagePosition = QMUIButtonImagePositionRight;
    _shareholder.titleLabel.font = ZWHFont(13);
    _shareholder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_shareholder];
    [_shareholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(15));
        make.centerY.equalTo(_title);
        make.width.mas_equalTo(WIDTH_PRO(130));
    }];
    
}






@end
