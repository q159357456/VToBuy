//
//  ZWHPieModel.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHPieModel : ZWHBaseModel

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *basequantity;
@property(nonatomic,copy)NSString *joinquantity;
@property(nonatomic,copy)NSString *permoney;
@property(nonatomic,copy)NSString *rate;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *totalamount;

@property(nonatomic,copy)NSArray *partnerlist;

@end

NS_ASSUME_NONNULL_END
