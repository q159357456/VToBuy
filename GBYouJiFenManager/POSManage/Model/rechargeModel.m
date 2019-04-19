//
//  rechargeModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "rechargeModel.h"

@implementation rechargeModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        rechargeModel *model = [[rechargeModel alloc] init];
        model.CashNumber = dic1[@"MBR001"];
        model.PresentNumber = dic1[@"MBR002"];
        model.itemNo = dic1[@"MBR000"];
        model.CreditsScore = dic1[@"MBR003"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
