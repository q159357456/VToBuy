//
//  TasteRequestModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "TasteRequestModel.h"

@implementation TasteRequestModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        TasteRequestModel *model = [[TasteRequestModel alloc] init];
        model.tasteName = dic1[@"DI002"];
        model.tasteClasses = dic1[@"DI003"];
        model.itemNo = dic1[@"DI001"];
        model.tasteNumber = dic1[@"DI008"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

//+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
//{
//    NSMutableArray *dataArray=[NSMutableArray array];
//    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
//    {
//        TasteRequestModel *model=[[TasteRequestModel alloc]init];
//        [model setValuesForKeysWithDictionary:dic1];
//        
//        [dataArray addObject:model];
//    }
//    
//    
//    return dataArray;
//}


@end
