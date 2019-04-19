//
//  DespositModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "DespositModel.h"

@implementation DespositModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        DespositModel *model=[[DespositModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
