//
//  ZWHCardManTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/10.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHCardManTableViewCell.h"

@implementation ZWHCardManTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    CellLine;
    _name = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.centerY.equalTo(self.contentView);
    }];
    
    _corView = [[UIView alloc]init];
    _corView.layer.borderWidth = 1;
    _corView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:_corView];
    [_corView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_PRO(-15));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(HEIGHT_PRO(20));
    }];
    
    _corView.layer.cornerRadius = HEIGHT_PRO(10);
    _corView.layer.masksToBounds = YES;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _corView.backgroundColor = _isSelect?navigationBarColor:[UIColor whiteColor];
}






@end
