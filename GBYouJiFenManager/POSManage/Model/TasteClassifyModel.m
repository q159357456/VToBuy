//
//  TasteClassifyModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "TasteClassifyModel.h"

@implementation TasteClassifyModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        TasteClassifyModel *model = [[TasteClassifyModel alloc] init];
        model.classifyName = dic1[@"ClassifyName"];
        model.classifyNo = dic1[@"ClassifyNo"];
        model.classifyType = dic1[@"ClassifyType"];
        
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
