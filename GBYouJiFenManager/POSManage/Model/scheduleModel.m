//
//  scheduleModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "scheduleModel.h"

@implementation scheduleModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        scheduleModel *model = [[scheduleModel alloc] init];
        model.beginTime = dic1[@"STT002"];
        model.endTime = dic1[@"STT003"];
        model.itemNo = dic1[@"STT001"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
