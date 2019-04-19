//
//  datePaymentDetailModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.


#import "datePaymentDetailModel.h"

@implementation datePaymentDetailModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        datePaymentDetailModel *model = [[datePaymentDetailModel alloc] init];
        model.payMoneyPEP = dic1[@"PEP009"];
        model.originalMoneyPEP = dic1[@"PEP006"];
        model.homeMoneyPEP = dic1[@"PEP008"];
        model.changeMoneyPEP = dic1[@"PEP010"];
        model.dateTime = dic1[@"PEP003"];
        model.BillType = dic1[@"UDF01"];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
