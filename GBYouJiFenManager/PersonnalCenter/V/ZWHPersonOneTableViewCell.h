//
//  ZWHPersonOneTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/17.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWHPersonOneTableViewCell : UITableViewCell


@property(nonatomic,strong)QMUILabel *tit1;
@property(nonatomic,strong)QMUILabel *tit2;
@property(nonatomic,strong)QMUILabel *tit3;

@property(nonatomic,strong)QMUILabel *yongjin;
@property(nonatomic,strong)QMUILabel *xianjin;
@property(nonatomic,strong)QMUILabel *chongzhi;

@property(nonatomic,strong)QMUIButton *yongBtn;
@property(nonatomic,strong)QMUIButton *xianBtn;
@property(nonatomic,strong)QMUIButton *chongBtn;


@end

NS_ASSUME_NONNULL_END
