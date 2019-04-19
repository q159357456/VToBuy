//
//  discountModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface discountModel : NSObject
@property(nonatomic,copy)NSString *discountName;
@property(nonatomic,copy)NSString *discountType;
@property(nonatomic,copy)NSString *appointDiscount;
@property(nonatomic,copy)NSString *printDiscount;
@property(nonatomic,copy)NSString *discountMoney;
@property(nonatomic,copy)NSString *itemNo;

@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;

@end
