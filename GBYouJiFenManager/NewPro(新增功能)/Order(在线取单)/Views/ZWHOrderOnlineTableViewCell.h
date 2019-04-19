//
//  ZWHOrderOnlineTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/14.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHOrderOnlineModel.h"

@interface ZWHOrderOnlineTableViewCell : UITableViewCell

@property(nonatomic,strong)QMUILabel *orderNo;
@property(nonatomic,strong)QMUILabel *time;
@property(nonatomic,strong)QMUILabel *money;
@property(nonatomic,strong)QMUILabel *num;
@property(nonatomic,strong)QMUILabel *seat;

@property(nonatomic,strong)QMUIButton *takeOrder;

@property(nonatomic,strong)QMUIButton *cancelOrder;

@property(nonatomic,strong)ZWHOrderOnlineModel *model;

@end
