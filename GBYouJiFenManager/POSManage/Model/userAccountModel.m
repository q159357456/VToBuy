//
//  userAccountModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "userAccountModel.h"

@implementation userAccountModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        userAccountModel *model = [[userAccountModel alloc] init];
        [model setValuesForKeysWithDictionary:dic1];
       
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
