//
//  RegionModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic withStr:(NSString*)str
{
  
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        RegionModel *model=[[RegionModel alloc]init];
        if ([str isEqualToString:@"Provice"])
        {
            model.provName=dic1[@"provName"];
            model.provCode=dic1[@"provCode"];
            
        }else if ([str isEqualToString:@"City"])
        {
            model.cityName=dic1[@"cityName"];
            model.cityCode=dic1[@"cityCode"];
            model.provCode=dic1[@"provCode"];
            
        }else
        {
            model.boroName=dic1[@"boroName"];
            model.boroCode=dic1[@"boroCode"];
            model.cityCode=dic1[@"cityCode"];
        }
       
        
        
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}


@end
