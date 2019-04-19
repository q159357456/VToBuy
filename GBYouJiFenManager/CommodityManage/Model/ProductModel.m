//
//  ProductModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        ProductModel *model=[[ProductModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic1];
    
         model.selected=NO;
         model.count=0;
        [dataArray addObject:model];
    }
    
//    NSLog(@"%ld",dataArray.count);
    return dataArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
