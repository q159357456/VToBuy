//
//  SeatModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SeatModel.h"

@implementation SeatModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        SeatModel *model=[[SeatModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
//        NSLog(@"--%@",dic1[@"UDF06"]);
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
