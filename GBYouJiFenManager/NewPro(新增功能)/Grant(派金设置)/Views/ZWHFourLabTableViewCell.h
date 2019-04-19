//
//  ZWHFourLabTableViewCell.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHPieListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHFourLabTableViewCell : UITableViewCell

@property(nonatomic,strong)QMUILabel *one;
@property(nonatomic,strong)QMUILabel *two;
@property(nonatomic,strong)QMUILabel *three;
@property(nonatomic,strong)QMUILabel *four;
@property(nonatomic,strong)QMUILabel *five;

@property(nonatomic,strong)ZWHPieListModel *model;

@end

NS_ASSUME_NONNULL_END
