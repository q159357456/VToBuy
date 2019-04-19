//
//  FinanciaModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FinanciaModel.h"

@implementation FinanciaModel
+(FinanciaModel*)getDataWithDic:(NSDictionary*)dic
{
    
    
    
      NSDictionary *dic1=dic[@"DataSet"][@"OrderInfo"];
        FinanciaModel *model=[[FinanciaModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
    
    
    
    
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
