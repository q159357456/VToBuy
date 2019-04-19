//
//  SPTModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SPTModel.h"

@implementation SPTModel
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        SPTModel *model=[[SPTModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
     
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
