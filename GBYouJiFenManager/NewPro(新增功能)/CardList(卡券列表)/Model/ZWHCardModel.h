//
//  ZWHCardModel.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHCardModel : ZWHBaseModel

@property(nonatomic,strong)NSString *num1;
@property(nonatomic,strong)NSString *num2;
@property(nonatomic,strong)NSString *num3;
@property(nonatomic,strong)NSArray *couponlist;

@end

NS_ASSUME_NONNULL_END
