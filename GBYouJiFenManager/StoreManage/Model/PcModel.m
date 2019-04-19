//
//  PcModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/10/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PcModel.h"

@implementation PcModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        PcModel *model=[[PcModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
