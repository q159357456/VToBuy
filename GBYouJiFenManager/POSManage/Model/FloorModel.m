//
//  FloorModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "FloorModel.h"

@implementation FloorModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        
        FloorModel *model = [[FloorModel alloc] init];
        model.FloorInfo = dic1[@"AF002"];
        model.itemNo = dic1[@"AF001"];
        model.selected = NO;
//        NSLog(@"%@",dic1[@"AF001"]);
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
