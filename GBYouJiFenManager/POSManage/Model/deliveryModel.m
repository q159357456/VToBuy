//
//  deliveryModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "deliveryModel.h"

@implementation deliveryModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        deliveryModel *model = [[deliveryModel alloc] init];
        model.deliveryTime = dic1[@"STT002"];
        model.itemNo = dic1[@"STT001"];
        
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
