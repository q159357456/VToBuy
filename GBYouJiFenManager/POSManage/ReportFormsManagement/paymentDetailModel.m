//
//  paymentDetailModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "paymentDetailModel.h"

@implementation paymentDetailModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        paymentDetailModel *model = [[paymentDetailModel alloc] init];
        model.payMoneyPPP = dic1[@"PPP011"];
        model.originalMoneyPPP = dic1[@"PPP008"];
        model.homeMoneyPPP = dic1[@"PPP010"];
        model.changeMoneyPPP = dic1[@"PPP012"];
        model.dateTime = dic1[@"PPP003"];
        model.billType = dic1[@"UDF01"];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
