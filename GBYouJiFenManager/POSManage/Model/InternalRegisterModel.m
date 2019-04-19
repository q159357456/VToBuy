//
//  InternalRegisterModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/6.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "InternalRegisterModel.h"

@implementation InternalRegisterModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        InternalRegisterModel *model = [[InternalRegisterModel alloc] init];
        model.roomName = dic1[@"DV006"];
        model.equipmentName = dic1[@"DV002"];
        model.itemNo = dic1[@"DV001"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}
@end
