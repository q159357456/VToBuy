//
//  PayTypeModel.m
//  GBManagement
//
//  Created by 工博计算机 on 16/12/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "PayTypeModel.h"

@implementation PayTypeModel
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic
{
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
     
        
        PayTypeModel *model=[[PayTypeModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        model.isSlected=NO;
        [array addObject:model];
    }
    
    
    return array;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}


@end
