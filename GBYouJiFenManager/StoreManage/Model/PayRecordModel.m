//
//  PayRecordModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PayRecordModel.h"

@implementation PayRecordModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        PayRecordModel *model=[[PayRecordModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        if ([model.Payment1 hasSuffix:@","]) {
            NSMutableString *muStr=[NSMutableString stringWithString:model.Payment1];
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];
            model.Payment1=muStr;
        }
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

@end
