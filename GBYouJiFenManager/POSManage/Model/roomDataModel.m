//
//  roomDataModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "roomDataModel.h"

@implementation roomDataModel

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        roomDataModel *model = [[roomDataModel alloc] init];
        model.roomName = dic1[@"SI002"];
        model.roomType = dic1[@"SI003"];
        model.floorArea = dic1[@"SI004"];
        model.itemNo = dic1[@"SI001"];
        model.isValid = dic1[@"SI015"];
        model.isBook = dic1[@"SI018"];
        model.ST002=dic1[@"ST002"];
        model.AF002=dic1[@"AF002"];
        model.SI007 = dic1[@"SI007"];
        model.SI005 = dic1[@"SI005"];
        
        model.SI017 = dic1[@"SI017"];
        model.UDF06 = dic1[@"UDF06"];

        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
