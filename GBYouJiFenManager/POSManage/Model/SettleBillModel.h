//
//  SettleBillModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettleBillModel : NSObject

@property(nonatomic,copy)NSString *printBill;//列印账单
@property(nonatomic,copy)NSString *rerurnCharge;//找零
@property(nonatomic,copy)NSString *speedMoney;//快速付款
@property(nonatomic,copy)NSString *validCode;//有效码
@property(nonatomic,copy)NSString *scoreExchange;;//积分兑换
@property(nonatomic,copy)NSString *billName;//结账名称
@property(nonatomic,copy)NSString *BillCode;//结账分类代码
@property(nonatomic,copy)NSString *GetCode;//营收代码
@property(nonatomic,copy)NSString *insideRate;//内部兑换率
@property(nonatomic,copy)NSString *outsideRate;//外部兑换率
@property(nonatomic,copy)NSString *sortOrder;//排列顺序
@property(nonatomic,copy)NSString *faceValueType;//面值类型
@property(nonatomic,copy)NSString *faceValueMoney;//面值金额
@property(nonatomic,copy)NSString *itemNo;


@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;

@end
