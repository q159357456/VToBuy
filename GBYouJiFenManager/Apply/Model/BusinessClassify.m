//
//  BusinessClassify.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BusinessClassify.h"

@implementation BusinessClassify
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        BusinessClassify *model=[[BusinessClassify alloc]init];

        [model setValuesForKeysWithDictionary:dic1];
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
