//
//  ResonModel.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/10.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ResonModel.h"

@implementation ResonModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    
    NSMutableArray *dataArray=[NSMutableArray array];
  
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        ResonModel *model=[[ResonModel alloc]init];
        model.CauseName_CN=dic1[@"CauseName_CN"];
        model.isSelected=NO;
        [dataArray addObject:model];
    }
    return dataArray;
}
@end
