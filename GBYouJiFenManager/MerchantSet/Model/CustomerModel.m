//
//  CustomerModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        CustomerModel *model=[[CustomerModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
