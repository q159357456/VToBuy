//
//  discountModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "discountModel.h"

@implementation discountModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        discountModel *model = [[discountModel alloc] init];
        model.discountName = dic1[@"DS002"];
        model.discountType = dic1[@"DS003"];
        model.appointDiscount = dic1[@"DS004"];
        model.printDiscount = dic1[@"DS005"];
        model.discountMoney = dic1[@"DS006"];
        model.itemNo = dic1[@"DS001"];
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
