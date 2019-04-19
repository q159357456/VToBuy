//
//  ADShopInfoModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ADShopInfoModel.h"

@implementation ADShopInfoModel
+(ADShopInfoModel *)getDatawithdic:(NSDictionary *)dic
{
    
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        
        ADShopInfoModel *model=[[ADShopInfoModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        [array addObject:model];
    }
    return array[0];
   
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
