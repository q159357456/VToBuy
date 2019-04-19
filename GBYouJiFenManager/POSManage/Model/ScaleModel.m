//
//  ScaleModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ScaleModel.h"

@implementation ScaleModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        ScaleModel *model = [[ScaleModel alloc] init];
        model.IPAddress = dic1[@"IP"];
        model.StartUsing = dic1[@"status"];
        model.itemNo = dic1[@"ID"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}
@end
