//
//  POSDIModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "POSDIModel.h"

@implementation POSDIModel
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic
    {
        NSMutableArray *array=[NSMutableArray array];
        for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
            
            
            POSDIModel *model=[[POSDIModel alloc]init];
            [model setValuesForKeysWithDictionary:dic1];
            
            [array addObject:model];
        }
        
        
        return array;
    }
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
    {
    }
@end
