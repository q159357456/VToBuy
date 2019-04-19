//
//  SBPModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SBPModel.h"

@implementation SBPModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        SBPModel *model=[[SBPModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        model.leftCount=0;
        model.SPTArray=[NSMutableArray array];
        model.sonProductArray=[NSMutableArray array];
        model.detailMuStr=[NSMutableString string];
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
