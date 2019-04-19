//
//  ZZmbrModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/12/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ZZmbrModel.h"

@implementation ZZmbrModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        ZZmbrModel *model=[[ZZmbrModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
