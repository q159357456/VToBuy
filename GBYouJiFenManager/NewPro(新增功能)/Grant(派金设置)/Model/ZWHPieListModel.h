//
//  ZWHPieListModel.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHPieListModel : ZWHBaseModel

@property(nonatomic,copy)NSString *chargeamount;
@property(nonatomic,copy)NSString *chargedate;
@property(nonatomic,copy)NSString *membername;
@property(nonatomic,copy)NSString *memberno;
@property(nonatomic,copy)NSString *pieamount;
@property(nonatomic,copy)NSString *piecopies;
@property(nonatomic,copy)NSString *sendmonth;

@end

NS_ASSUME_NONNULL_END
