//
//  ZWHPersonOneTableViewCell.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/17.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHPersonOneTableViewCell.h"

@implementation ZWHPersonOneTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = navigationBarColor;
        [self setUI];
    }
    return self;
}


-(void)setUI{
    _tit1 = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    _tit2 = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    _tit3 = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    _yongjin = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    _chongzhi = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    _xianjin = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor whiteColor]];
    
    _yongBtn = [[QMUIButton alloc]init];
    _chongBtn = [[QMUIButton alloc]init];
    _xianBtn = [[QMUIButton alloc]init];
    
    NSArray *titArr = @[_tit1,_tit2,_tit3];
    NSArray *titStrArr = @[@"佣金账户",@"充值账户",@"现金账户"];
    NSArray *labArr = @[_yongjin,_chongzhi,_xianjin];
    NSArray *btnArr = @[_yongBtn,_chongBtn,_xianBtn];
    
    
    for (NSInteger i=0; i<titArr.count; i++) {
        CGFloat wid = (SCREEN_WIDTH-2)/3;
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(wid*i);
            make.width.mas_equalTo(wid);
            make.top.equalTo(self.contentView).offset(WIDTH_PRO(15));
            make.bottom.equalTo(self.contentView).offset(-WIDTH_PRO(15));
        }];
        if (i<2) {
            view.qmui_borderColor = [UIColor whiteColor];
            view.qmui_borderWidth = 1;
            view.qmui_borderPosition = QMUIViewBorderPositionRight;
        }
        
        QMUILabel *lab = titArr[i];
        lab.text = titStrArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view);
        }];
        
        QMUILabel *valuelab = labArr[i];
        valuelab.text = @"0.0000";
        valuelab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:valuelab];
        [valuelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.bottom.equalTo(view);
        }];
        
        QMUIButton *btn = btnArr[i];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(view);
        }];
    }
}



@end
