//
//  CloseReportModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.

#import "CloseReportModel.h"

@implementation CloseReportModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        CloseReportModel *model = [[CloseReportModel alloc] init];
        model.classesTimes = dic1[@"PI004"];
        model.operateTime = dic1[@"PI003"];
        model.operateMachine = dic1[@"PI005"];
        model.FormsNumber = dic1[@"PI007"];
        model.selected = NO;
        model.PI001 = dic1[@"PI001"];
        model.PI002 = dic1[@"PI002"];
        model.PI006 = dic1[@"PI006"];
        model.PI008 = dic1[@"PI008"];
        model.PI009 = dic1[@"PI009"];
        model.PI010 = dic1[@"PI010"];
        model.PI011 = dic1[@"PI011"];
        model.PI012 = dic1[@"PI012"];
        model.PI013 = dic1[@"PI013"];
        model.PI014 = dic1[@"PI014"];
        model.PI015 = dic1[@"PI015"];
        model.PI016 = dic1[@"PI016"];
        model.PI017 = dic1[@"PI017"];
        model.PI018 = dic1[@"PI018"];
        model.PI019 = dic1[@"PI019"];
        model.PI020 = dic1[@"PI020"];
        model.PI021 = dic1[@"PI021"];
        model.PI022 = dic1[@"PI022"];
        model.PI023 = dic1[@"PI023"];
        model.PI024 = dic1[@"PI024"];
        model.PI025 = dic1[@"PI025"];
        model.status = dic1[@"status"];
        model.UDF03 = dic1[@"UDF03"];
        model.UDF07 = dic1[@"UDF07"];
        model.UDF08 = dic1[@"UDF08"];
        model.UDF09 = dic1[@"UDF09"];
        model.UDF10 = dic1[@"UDF10"];
        model.UDF11 = dic1[@"UDF11"];
        model.area = dic1[@"area"];
        
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
