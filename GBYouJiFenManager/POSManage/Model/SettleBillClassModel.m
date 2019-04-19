//
//  SettleBillClassModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 秦根. All rights reserved.
//
#import "SettleBillClassModel.h"

@implementation SettleBillClassModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        SettleBillClassModel *model = [[SettleBillClassModel alloc] init];
        model.billName = dic1[@"CC002"];
        model.itemNo = dic1[@"CC001"];
        model.billMode = dic1[@"CC004"];
        model.validCode = dic1[@"CC003"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
