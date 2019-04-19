//
//  SBModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SBModel.h"

@implementation SBModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        SBModel *model=[[SBModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
