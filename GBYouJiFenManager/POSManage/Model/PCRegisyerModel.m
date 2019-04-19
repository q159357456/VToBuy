//
//  PCRegisyerModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "PCRegisyerModel.h"

@implementation PCRegisyerModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        PCRegisyerModel *model = [[PCRegisyerModel alloc] init];
        model.PCMAC = dic1[@"DN004"];
        model.PCName = dic1[@"DN002"];
        model.PCArea = dic1[@"DN006"];
        model.itemNo = dic1[@"DN001"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
