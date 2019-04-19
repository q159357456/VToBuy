//
//  ZWHCardListTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHCardListTableViewCell.h"

@implementation ZWHCardListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}


-(void)setUI{
    self.contentView.backgroundColor = LINECOLOR;
    _img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clip_1"]];
    //_img.backgroundColor = [UIColor whiteColor];
    _img.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(10));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_PRO(91));
        make.height.mas_equalTo(HEIGHT_PRO(85));
    }];
    
    UIView *rigView = [[UIView alloc]init];
    [self.contentView insertSubview:rigView atIndex:0];
    rigView.backgroundColor = [UIColor whiteColor];
    [rigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(-WIDTH_PRO(14));
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(10));
        make.top.bottom.equalTo(_img);
    }];
    
    _quota = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(18) textColor:[UIColor whiteColor]];
    [_img addSubview:_quota];
    [_quota mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img).offset(HEIGHT_PRO(3));
        make.centerX.equalTo(_img);
    }];
    
    _title = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img).offset(HEIGHT_PRO(4));
        make.left.equalTo(_img.mas_right).offset(WIDTH_PRO(8));
        make.right.equalTo(rigView.mas_right);
    }];
    _title.numberOfLines = 0;
    
    _detail = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:navigationBarColor];
    [self.contentView addSubview:_detail];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_title.mas_bottom).offset(HEIGHT_PRO(4));
        make.left.equalTo(_img.mas_right).offset(WIDTH_PRO(8));
        make.right.equalTo(rigView.mas_right);
    }];
    _detail.numberOfLines = 0;
    
    
    _time = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:[UIColor grayColor]];
    [self.contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detail.mas_bottom);
        make.left.equalTo(_img.mas_right).offset(WIDTH_PRO(8));
        make.right.equalTo(rigView.mas_right).offset(-WIDTH_PRO(8));
        make.height.mas_equalTo(HEIGHT_PRO(22));
    }];
    _time.qmui_borderColor = [UIColor grayColor];
    _time.qmui_borderWidth = 1;
    _time.qmui_borderPosition = QMUIViewBorderPositionBottom;
    _time.qmui_dashPattern = @[@3,@3];
    _time.qmui_dashPhase = 2;
    
    _shareholder = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:[UIColor redColor]];
    [self.contentView addSubview:_shareholder];
    [_shareholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_time.mas_bottom).offset(HEIGHT_PRO(4));
        make.left.equalTo(_img.mas_right).offset(WIDTH_PRO(8));
    }];
    
    _share = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"80"] title:@"分享"];
    _share.titleLabel.font = ZWHFont(12);
    [self.contentView addSubview:_share];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shareholder);
        make.right.equalTo(rigView.mas_right).offset(-WIDTH_PRO(8));
        make.width.mas_equalTo(WIDTH_PRO(56));
        make.height.mas_equalTo(HEIGHT_PRO(19));
    }];
    [_share layoutIfNeeded];
    
    [_share setTitleColor:[UIColor redColor] forState:0];
    _share.layer.borderColor = [UIColor redColor].CGColor;
    _share.layer.borderWidth = 1;
    _share.layer.cornerRadius = _share.height/2;
    _share.layer.masksToBounds = YES;
    
    
    _shareholder.text = @"股东";
    _time.text = @"有效期至。。。。";
    _detail.text = @"已领取1/1";
    _quota.text = @"150元";
    _title.text = @"满100减10";
}

-(void)setModel:(CouponModel *)model{
    _model = model;
    
    _quota.text = [NSString stringWithFormat:@"¥%@",[model.Amount2 removeZeroWithStr]];
    _title.text = [NSString stringWithFormat:@"满%@元立减%@元(仅限工作日使用)",model.Amount1,model.Amount2];
    _detail.text = [NSString stringWithFormat:@"已领取%@/%@  已使用%@/%@",model.Quantity2,model.Quantity1,model.Quantity3,model.Quantity2];
    _time.text = [NSString stringWithFormat:@"有效期至%@",[model.EndDate componentsSeparatedByString:@"T"][0]];
    _shareholder.text = [NSString stringWithFormat:@"股东:%@",model.membername.length>0?model.membername:@""];
    if (model.UDF01.length>0) {
        _shareholder.hidden = NO;
        _share.hidden = NO;
    }else{
        _shareholder.hidden = YES;
        _share.hidden = YES;
    }

}







@end
