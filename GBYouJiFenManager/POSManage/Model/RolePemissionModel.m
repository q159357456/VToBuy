//
//  RolePemissionModel.m
//  GBYouJiFenManager

//  Created by mac on 2017/6/27.
//  Copyright © 2017年 xia. All rights reserved.


#import "RolePemissionModel.h"

@implementation RolePemissionModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        RolePemissionModel *model = [[RolePemissionModel alloc] init];
        [model setValuesForKeysWithDictionary:dic1];
//        model.RoleNo = dic1[@"RoleNo"];
//        model.RoleNa = dic1[@"RoleNa"];
//        model.Remark = dic1[@"Remark"];
        model.selected = NO;
        
        [dataArr addObject:model];
    }
    return dataArr;
}


//+(NSMutableArray *)getDataWithDic1:(NSDictionary *)dic
//{
//    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
//        RolePemissionModel *model = [[RolePemissionModel alloc] init];
//        //[model setValuesForKeysWithDictionary:dic1];
//        model.PRoleNo = dic1[@"RoleNo"];
//        model.Pno = dic1[@"Pno"];
//        model.RightValue = dic1[@"RightValue"];
//        model.selected = NO;
//        
//        [dataArr addObject:model];
//    }
//    return dataArr;
//}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
@end
