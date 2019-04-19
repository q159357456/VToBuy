//
//  cashierModel.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "cashierModel.h"

@implementation cashierModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray=[NSMutableArray array];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"])
    {
        cashierModel *model=[[cashierModel alloc]init];
        model.name = dic1[@"Account_Name"];
        model.phoneNumber = dic1[@"Account_No"];
        model.screat = dic1[@"PassWord"];
        model.addRoom = dic1[@"IsRoomAdd"];
        model.addGood = dic1[@"IsGoodsAdd"];
        model.systemSet = dic1[@"IsSystemSet"];
        model.memberManage = dic1[@"IsMemberManager"];
        model.cashManage = dic1[@"IsCashManager"];
        model.changeMoney = dic1[@"IsPriceChange"];
        model.isReport = dic1[@"IsReportManager"];
        model.discountSettle = dic1[@"IsDiscount"];
        model.zengSong = dic1[@"IsFree"];
        model.Moling = dic1[@"IsMoling"];
        model.freezeAccount = dic1[@"IsLock"];
        
        [dataArray addObject:model];
    }
    
    
    return dataArray;
}
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    
//    
//}
@end
