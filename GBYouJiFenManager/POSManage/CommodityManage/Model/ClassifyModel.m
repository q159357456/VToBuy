//
//  ClassifyModel.m
//  树形测试
//
//  Created by 工博计算机 on 17/4/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        ClassifyModel *model=[[ClassifyModel alloc]init];
        model.COMPANY=dic1[@"COMPANY"];
        model.SHOPID=dic1[@"SHOPID"];
        model.classifyName=dic1[@"ClassifyName"];
        model.classifyNo=dic1[@"ClassifyNo"];
        model.ClassifyType=dic1[@"ClassifyType"];
        model.parentno=dic1[@"ParentNo"];
        model.Status=dic1[@"Status"];
        model.depth=[dic1[@"UDF01"] intValue];
//        if (model.parentno.length==0)
//        {
            model.expand=YES;
//        }else
//        {
//            model.expand=NO;
//        }
        model.selected=NO;
        [dataArray addObject:model];
    }
    

        return dataArray;
}
@end
