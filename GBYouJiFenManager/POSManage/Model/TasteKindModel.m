//
//  TasteKindModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.


#import "TasteKindModel.h"

@implementation TasteKindModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        TasteKindModel *model = [[TasteKindModel alloc] init];
        model.classifyList = dic1[@"DC003"];
        model.classifyName = dic1[@"DC002"];
        model.itemNo = dic1[@"DC001"];
        model.selected = NO;
        
        [dataArray addObject:model];
    }
    return dataArray;
}
@end
