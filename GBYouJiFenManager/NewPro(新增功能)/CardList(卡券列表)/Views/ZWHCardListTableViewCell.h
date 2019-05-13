//
//  ZWHCardListTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHCardListTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)QMUILabel *quota;
@property(nonatomic,strong)QMUILabel *title;
@property(nonatomic,strong)QMUILabel *detail;
@property(nonatomic,strong)QMUILabel *time;
@property(nonatomic,strong)QMUILabel *shareholder;
@property(nonatomic,strong)QMUIButton *share;
@property(nonatomic,strong)CouponModel *model;
@property(nonatomic,strong)UIButton * deletBtn;
@property(nonatomic,copy)void(^RefreshCallBack)();

@end

NS_ASSUME_NONNULL_END
