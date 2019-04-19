//
//  commidityBigClassModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "commidityBigClassModel.h"

@implementation commidityBigClassModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        commidityBigClassModel *model = [[commidityBigClassModel alloc] init];
        model.classesNamePI = dic1[@"UDF01"];
        model.orderMoneyPI = dic1[@"PPI007"];
        model.discountMoneyPI = dic1[@"PPI008"];
        model.actuallyMoneyPI = dic1[@"PPI010"];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
