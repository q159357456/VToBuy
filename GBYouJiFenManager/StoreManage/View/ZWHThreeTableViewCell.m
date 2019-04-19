//
//  ZWHThreeTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/16.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHThreeTableViewCell.h"

@implementation ZWHThreeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    _line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor qmui_colorWithHexString:@"f3f3f3"];
    [self.contentView addSubview:_line];
    _line.hidden = YES;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    _leftL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_leftL];
    [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_PRO(15));
        make.centerY.equalTo(self.contentView);
    }];
    
    _centerL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor blackColor]];
    [self.contentView addSubview:_centerL];
    _centerL.textAlignment = NSTextAlignmentCenter;
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.contentView).offset(WIDTH_PRO(150));
        make.center.equalTo(self.contentView);
    }];
    
    _rightL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor blackColor]];
    _rightL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rightL];
    [_rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_right).offset(-(SCREEN_WIDTH/3/2));
        make.centerY.equalTo(self.contentView);
    }];
}








@end
