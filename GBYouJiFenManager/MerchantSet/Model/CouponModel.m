//
//  CouponModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/17.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        CouponModel *model=[[CouponModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
