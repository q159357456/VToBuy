//
//  DateCommidityBigClassModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "DateCommidityBigClassModel.h"

@implementation DateCommidityBigClassModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        DateCommidityBigClassModel *model = [[DateCommidityBigClassModel alloc] init];
        model.classesNameEI = dic1[@"UDF01"];
        model.orderMoneyEI = dic1[@"PEI005"];
        model.discountMoneyEI = dic1[@"PEI006"];
        model.actuallyMoneyEI = dic1[@"PEI008"];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
