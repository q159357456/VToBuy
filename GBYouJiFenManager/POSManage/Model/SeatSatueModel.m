//
//  SeatSatueModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SeatSatueModel.h"

@implementation SeatSatueModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        SeatSatueModel *model=[[SeatSatueModel alloc]init];
      
        [model setValuesForKeysWithDictionary:dic1];
    
        model.isSlected=NO;
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
