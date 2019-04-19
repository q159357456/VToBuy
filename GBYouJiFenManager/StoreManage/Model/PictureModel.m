//
//  PictureModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        PictureModel *model=[[PictureModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
