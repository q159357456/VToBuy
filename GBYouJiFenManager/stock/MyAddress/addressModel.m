//
//  addressModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.

#import "addressModel.h"

@implementation addressModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1  in dic[@"DataSet"][@"Table"]) {
        addressModel *model = [[addressModel alloc] init];
        model.ID = dic1[@"ID"];
        model.contact = dic1[@"Contact"];
        model.mobile = dic1[@"Mobile"];
        model.address = dic1[@"Address"];
        model.area = dic1[@"Area"];
        model.defaultAddress = dic1[@"DefaultAddr"];
        model.MemberNo = dic1[@"MemberNo"];
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
