//
//  ZWHOrderOnlineTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/14.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHOrderOnlineTableViewCell.h"

@implementation ZWHOrderOnlineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIView *topline = [[UIView alloc]init];
    topline.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(10));
    topline.backgroundColor = LINECOLOR;
    [self.contentView addSubview:topline];
    
    _orderNo = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_orderNo];
    [_orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.top.equalTo(topline.mas_bottom).offset(HEIGHT_PRO(15));
    }];
    
    _time = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor qmui_colorWithHexString:@"8A8A8A"]];
    _time.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(15));
        make.centerY.equalTo(_orderNo);
    }];
    
    QMUILabel *tip = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    tip.text = @"金额";
    [self.contentView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.top.equalTo(_orderNo.mas_bottom).offset(HEIGHT_PRO(15));
    }];
    
    
    _money = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor qmui_colorWithHexString:@"EA5519"]];
    [self.contentView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.mas_right).offset(WIDTH_PRO(6));
        make.centerY.equalTo(tip);
    }];
    
    _num = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    _num.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_num];
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(15));
        make.centerY.equalTo(_money);
    }];
    
    
    UIView *midline = [[UIView alloc]init];
    midline.backgroundColor = LINECOLOR;
    [self.contentView addSubview:midline];
    [midline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(15));
        make.top.equalTo(_num.mas_bottom).offset(HEIGHT_PRO(9));
        make.height.mas_equalTo(1);
    }];
    
    _takeOrder = [[QMUIButton alloc]qmui_initWithImage:nil title:@"取单"];
    _takeOrder.tintColorAdjustsTitleAndImage = navigationBarColor;
    _takeOrder.titleLabel.font = ZWHFont(12);
    _takeOrder.layer.borderColor = navigationBarColor.CGColor;
    _takeOrder.layer.borderWidth = 1;
    _takeOrder.layer.cornerRadius = 5;
    _takeOrder.layer.masksToBounds = YES;
    [self.contentView addSubview:_takeOrder];
    [_takeOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_PRO(25));
        make.width.mas_equalTo(WIDTH_PRO(60));
        make.top.equalTo(midline.mas_bottom).offset(HEIGHT_PRO(6));
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(15));
    }];
    
    _cancelOrder = [[QMUIButton alloc]qmui_initWithImage:nil title:@"作废"];
    _cancelOrder.tintColorAdjustsTitleAndImage = [UIColor blackColor];
    _cancelOrder.titleLabel.font = ZWHFont(12);
    _cancelOrder.layer.borderColor = [UIColor blackColor].CGColor;
    _cancelOrder.layer.borderWidth = 1;
    _cancelOrder.layer.cornerRadius = 5;
    _cancelOrder.layer.masksToBounds = YES;
    [self.contentView addSubview:_cancelOrder];
    [_cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_PRO(25));
        make.width.mas_equalTo(WIDTH_PRO(60));
        make.top.equalTo(midline.mas_bottom).offset(HEIGHT_PRO(6));
        make.right.equalTo(_takeOrder.mas_left).offset(-WIDTH_PRO(15));
    }];
    
    
    _seat = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor orangeColor]];
    _seat.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_seat];
    [_seat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.centerY.equalTo(_takeOrder);
    }];
    
    
    
    _orderNo.text = @"订单号：123456";
    _time.text = @"2018-12-12 11:11";
    _money.text = @"¥100";
    _num.text = @"人数: 12人";
    _seat.text = @"A区5桌";
}

-(void)setModel:(ZWHOrderOnlineModel *)model{
    _model = model;
    NSString *ding = [_model.SB002 stringByReplacingCharactersInRange:NSMakeRange(2, _model.SB002.length-8) withString:@"***"];
    _orderNo.text = [NSString stringWithFormat:@"订单号:%@",ding];
    _time.text = _model.CREATE_DATE;
    _money.text = [NSString stringWithFormat:@"¥%@",_model.SB023];
    _num.text = [NSString stringWithFormat:@"人数:%@",_model.SB009];
    _seat.text = _model.SB005.length>0?[NSString stringWithFormat:@"房台号:%@",_model.SB005]:@"";
}




@end
