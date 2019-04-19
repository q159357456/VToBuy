//
//  ADModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ADModel.h"

@implementation ADModel
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic
{
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        
        
        ADModel *model=[[ADModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
      
        [array addObject:model];
    }
    
    
    return array;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
