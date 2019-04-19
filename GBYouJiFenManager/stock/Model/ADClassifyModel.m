//
//  ADClassifyModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ADClassifyModel.h"

@implementation ADClassifyModel
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic
{
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        
        
        ADClassifyModel *model=[[ADClassifyModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        [array addObject:model];
    }
    
    
    return array;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
