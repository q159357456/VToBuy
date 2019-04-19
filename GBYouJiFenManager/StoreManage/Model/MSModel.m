//
//  MSModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MSModel.h"

@implementation MSModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        MSModel *model=[[MSModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
       
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
