//
//  discountClassifyModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "discountClassifyModel.h"

@implementation discountClassifyModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        discountClassifyModel *model = [[discountClassifyModel alloc] init];
        model.VarDisPlay = dic1[@"VarDisplay1"];
        model.VarValue = dic1[@"VarValue"];
        
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
