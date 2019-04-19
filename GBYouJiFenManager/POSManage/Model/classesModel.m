//
//  classesModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "classesModel.h"

@implementation classesModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        classesModel *model = [[classesModel alloc] init];
        model.classesName = dic1[@"CS002"];
        model.beginTime = dic1[@"CS003"];
        model.endTime = dic1[@"CS004"];
        model.itemNo = dic1[@"CS001"];
        model.selected = NO;
       
        [dataArr addObject:model];
    }
    return dataArr;
}


@end
