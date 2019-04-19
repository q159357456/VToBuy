//
//  RoomTypeModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "RoomTypeModel.h"

@implementation RoomTypeModel

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
   
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        RoomTypeModel *model = [[RoomTypeModel alloc] init];
        model.RoomName = dic1[@"ST002"];
        model.itemNo = dic1[@"ST001"];
        model.roomArea = dic1[@"ST005"];
        model.AF002 = dic1[@"AF002"];
        model.typename = dic1[@"typename"];
        model.typeno = dic1[@"typeno"];
     
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
