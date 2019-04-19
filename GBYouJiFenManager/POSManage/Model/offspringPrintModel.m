//
//  offspringPrintModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "offspringPrintModel.h"

@implementation offspringPrintModel
+(NSMutableArray *)getDataWith:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        offspringPrintModel *model = [[offspringPrintModel alloc] init];
        model.PrinterName = dic1[@"PS002"];
        model.PrinterIP = dic1[@"PS004"];
        model.itemNo = dic1[@"PS001"];
        model.BigClasses = dic1[@"PS007"];
        model.selected = NO;
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
