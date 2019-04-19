//
//  DateFormsModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.


#import "DateFormsModel.h"

@implementation DateFormsModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        DateFormsModel *model = [[DateFormsModel alloc] init];
        model.classesTimes = dic1[@"EI004"];
        model.operateTime = dic1[@"EI003"];
        model.operateMachine = dic1[@"EI005"];
        model.FormsNumber = dic1[@"EI006"];
        model.selected = NO;
        
        model.PI001 = dic1[@"EI001"];
        model.PI002 = dic1[@"EI002"];
        model.PI007 = dic1[@"EI007"];
        model.PI008 = dic1[@"EI008"];
        model.PI009 = dic1[@"EI009"];
        model.PI010 = dic1[@"EI010"];
        model.PI011 = dic1[@"EI011"];
        model.PI012 = dic1[@"EI012"];
        model.PI013 = dic1[@"EI013"];
        model.PI014 = dic1[@"EI014"];
        model.PI015 = dic1[@"EI015"];
        model.PI016 = dic1[@"EI016"];
        model.PI017 = dic1[@"EI017"];
        model.PI018 = dic1[@"EI018"];
        model.PI019 = dic1[@"EI019"];
        model.PI020 = dic1[@"EI020"];
        model.PI021 = dic1[@"EI021"];
        model.PI022 = dic1[@"EI022"];
        model.PI023 = dic1[@"EI023"];
        model.status = dic1[@"status"];
        model.UDF03 = dic1[@"UDF03"];
        model.UDF07 = dic1[@"UDF07"];
        model.UDF08 = dic1[@"UDF08"];
        model.UDF09 = dic1[@"UDF09"];
        model.UDF10 = dic1[@"UDF10"];
        model.UDF11 = dic1[@"UDF11"];
        
        [dataArr addObject:model];
    }
    return dataArr;
}

@end
