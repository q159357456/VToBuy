//
//  SettleBillModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "SettleBillModel.h"


/**
 @property(nonatomic,copy)NSString *printBill;//列印账单
 @property(nonatomic,copy)NSString *rerurnCharge;//找零
 @property(nonatomic,copy)NSString *speedMoney;//快速付款
 @property(nonatomic,copy)NSString *validCode;//有效码
 @property(nonatomic,copy)NSString *scoreExchange;;//积分兑换
 @property(nonatomic,copy)NSString *billName;//结账名称
 @property(nonatomic,copy)NSString *BillCode;//结账分类代码
 @property(nonatomic,copy)NSString *GetCode;//营收代码
 @property(nonatomic,copy)NSString *insideRate;//内部兑换率
 @property(nonatomic,assign)NSInteger outsideRate;//外部兑换率
 @property(nonatomic,assign)NSString *sortOrder;//排列顺序
 @property(nonatomic,assign)NSInteger faceValueType;//面值类型
 @property(nonatomic,assign)NSString *faceValueMoney;//面值金额
 */

@implementation SettleBillModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        SettleBillModel *model = [[SettleBillModel alloc] init];
        model.itemNo = dic1[@"CM001"];
        model.billName = dic1[@"CM002"];
        model.BillCode = dic1[@"CM004"];
        model.GetCode = dic1[@"CM017"];
        model.insideRate = dic1[@"CM005"];
        model.outsideRate = dic1[@"CM006"];
        model.sortOrder = dic1[@"CM007"];
        model.faceValueType = dic1[@"CM011"];
        model.faceValueMoney = dic1[@"CM013"];
        
        model.printBill = dic1[@"CM008"];
        model.rerurnCharge = dic1[@"CM018"];
        model.speedMoney = dic1[@"CM023"];
        model.validCode = dic1[@"CM019"];
        model.scoreExchange = dic1[@"CM022"];
        
        model.selected = NO;
        
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
