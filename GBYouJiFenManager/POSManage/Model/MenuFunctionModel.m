//
//  MenuFunctionModel.m
//  GBYouJiFenManager

//  Created by mac on 2017/6/29.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "MenuFunctionModel.h"

@implementation MenuFunctionModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        MenuFunctionModel *model = [[MenuFunctionModel alloc] init];
        model.Pno = dic1[@"Pno"];
        model.Pna = dic1[@"Pna"];
        model.RightValue = dic1[@"RightValue"];
        model.RoleNo = dic1[@"RoleNo"];
        model.AccountNo = dic1[@"AccountNo"];
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
