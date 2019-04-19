//
//  ZWHSharesListTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/3.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import "ZWHSharesListTableViewCell.h"

#define OCOLOR [UIColor qmui_colorWithHexString:@"5DC5FD"]
#define TCOLOR [UIColor qmui_colorWithHexString:@"8BC34A"]

@implementation ZWHSharesListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    _name = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:[UIColor blackColor]];
    _name.text = @"syrena";
    [self.contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(8));
        make.top.equalTo(self.contentView).offset(WIDTH_PRO(8));
        //make.width.mas_equalTo(WIDTH_PRO(70));
    }];
    
    _deleteBtn = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"delete"] title:@""];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(HEIGHT_PRO(18));
        make.centerY.equalTo(_name);
        make.right.equalTo(self.contentView).offset(-WIDTH_PRO(8));
    }];
    
    _edit = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"edit-1"] title:@""];
    [self.contentView addSubview:_edit];
    [_edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(HEIGHT_PRO(18));
        make.centerY.equalTo(_name);
        make.right.equalTo(_deleteBtn.mas_left).offset(-WIDTH_PRO(8));
    }];
    
    _backView = [[UIView alloc]init];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.mas_left);
        make.right.equalTo(_edit.mas_left).offset(-WIDTH_PRO(8));
        make.top.equalTo(_name.mas_bottom).offset(6);
        make.height.mas_equalTo(HEIGHT_PRO(25));
    }];
    [_backView layoutIfNeeded];
    _backView.qmui_borderColor = DEEPLINE;
    _backView.qmui_borderWidth = 1;
    _backView.qmui_borderPosition = QMUIViewBorderPositionLeft;
    
    _shares = [[QMUIButton alloc]qmui_initWithImage:[UIImage qmui_imageWithColor:randomColor size:CGSizeMake(_backView.width*0.6, _backView.height) cornerRadius:0] title:@"60%"];
    _shares.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _shares.userInteractionEnabled = NO;
    _shares.spacingBetweenImageAndTitle = 6;
    _shares.titleLabel.font = ZWHFont(10);
    [_backView addSubview:_shares];
    [_shares mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_backView);
        //make.width.mas_equalTo(WIDTH_PRO(_backView.width*0.6));
    }];
    [_shares layoutIfNeeded];
    
    _time = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:navigationBarColor];
    _time.text = @"syrena";
    [self.contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.mas_left);
        make.top.equalTo(_backView.mas_bottom).offset(6);
    }];
    
    _baseq = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(12) textColor:navigationBarColor];
    [self.contentView addSubview:_baseq];
    [_baseq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_time.mas_bottom).offset(6);
        make.left.equalTo(_time.mas_left);
    }];
    
    
    CellLine;
}


-(void)setModel:(ZWHSharesModel *)model{
    _model = model;
    _name.text = _model.MemberName;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    _time.text = [NSString stringWithFormat:@"入股日期:%@  更新日期:%@",[[format dateFromString:_model.FirstEffective] stringWithFormat:@"yyyy-MM-dd"],[[format dateFromString:_model.LastEffective] stringWithFormat:@"yyyy-MM-dd"]];
    UIColor *color = _model.row%2==0?OCOLOR:TCOLOR;
    float rat = [_model.Ratio floatValue]*0.01;
    CGFloat rrr = (CGFloat)rat;
    
    [_shares setImage:[UIImage qmui_imageWithColor:color size:CGSizeMake(_backView.width*rrr, _backView.height) cornerRadius:0] forState:0];
    [_shares setTitle:[NSString stringWithFormat:@"%@%%",_model.Ratio] forState:0];
    
    [_shares mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_backView.width*rrr + 60);
    }];
    
    _baseq.text = [NSString stringWithFormat:@"赠送基数:%ld份",_model.BaseNum];
    
    
    if ([_model.MemberName isEqualToString:@"新"]) {
        NSLog(@"abc");
    }
}




@end
