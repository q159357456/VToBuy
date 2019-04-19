//
//  QianTainRoleModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "QianTainRoleModel.h"

@implementation QianTainRoleModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        QianTainRoleModel *model = [[QianTainRoleModel alloc] init];
        model.RoleNa = dic1[@"RoleNa"];
        model.RoleNo = dic1[@"RoleNo"];
        model.AccountNo = dic1[@"AccountNo"];
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
