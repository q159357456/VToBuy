//
//  INV_ProductModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "INV_ProductModel.h"

@implementation INV_ProductModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"INV_Product"])
    {
        INV_ProductModel *model=[[INV_ProductModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        model.count=0;
        model.POSDIArray=[NSMutableArray array];
        model.DetailProductArray=[NSMutableArray array];
        model.detailMuStr=[NSMutableString string];
        [dataArray addObject:model];
    }
    
 
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
