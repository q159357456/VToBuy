//
//  GroupModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        GroupModel *model=[[GroupModel alloc]init];
        model.GP_No=dic1[@"GP_No"];
        
        NSLog(@"--%@",[NSString stringWithFormat:@"%@",model.GP_No]);
        model.GP_Name=dic1[@"GP_Name"];
        model.BasicQuantity=dic1[@"BasicQuantity"];
        model.beiZhu=dic1[@"Remark"];
        
        
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
@end
