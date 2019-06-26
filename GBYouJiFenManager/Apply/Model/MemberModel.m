//
//  MemberModel.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic
{
//    NSLog(@"dic==>%@",dic);
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Shop"])
    {
      
        MemberModel *model=[[MemberModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}

+(NSMutableArray*)getDataWithDicPerson:(NSDictionary*)dic
{
//    NSLog(@"dic==>%@",dic);
    NSMutableArray *datArray=[NSMutableArray array];
    
    
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        
        MemberModel *model=[[MemberModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        
        [datArray addObject:model];
    }
    
    
    return datArray;
}



-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
