//
//  POSSetModel.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/25.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "POSSetModel.h"

@implementation POSSetModel
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in dic[@"DataSet"][@"Table"]) {
        POSSetModel *model = [[POSSetModel alloc] init];
        //小票份数
        model.POS_OrderPrintNum = dic1[@"POS_OrderPrintNum"];
        model.POS_PassWorkPrintNum = dic1[@"POS_PassWorkPrintNum"];
        model.POS_MemberReceiptPrintNum = dic1[@"POS_MemberReceiptPrintNum"];
        model.POS_ReceiptPrintNum = dic1[@"POS_ReceiptPrintNum"];
        model.POS_GiftPrintNum = dic1[@"POS_GiftPrintNum"];
        model.POS_CashBoxPrintNum = dic1[@"POS_CashBoxPrintNum"];
        model.POS_GuanDanPrintNum = dic1[@"POS_GuanDanPrintNum"];
        
        //小票页脚
        model.POS_Ordertitle = dic1[@"POS_OrderTitle"];
        model.POS_PassWorkTitle = dic1[@"POS_PassWorkTitle"];
        model.POS_MemberReceiptTitle = dic1[@"POS_MemberReceiptTitle"];
        model.POS_ReceiptTitle = dic1[@"POS_ReceiptTitle"];
        model.POS_GiftTitle = dic1[@"POS_GiftTitle"];
        model.POS_CashBoxTitle = dic1[@"POS_CashBoxTitle"];
        model.POS_GuanDanTitle = dic1[@"POS_GuanDanTitle"];
        
        //其他设置
        model.POS_SeatShowQty = dic1[@"POS_SeatShowNumber"];
        model.POS_SeatHeight = dic1[@"POS_SeatHeight"];
        model.POS_SeatWidth = dic1[@"POS_SeatWidth"];
        model.POS_BillHeight = dic1[@"POS_BillHeight"];
        model.POS_BillWidth = dic1[@"POS_BillWidth"];
        model.POS_GoodShowQty = dic1[@"POS_GoodDisplay"];
        model.POS_SeatShowOtherQty = dic1[@"POS_SeatShowOther"];
        model.POS_RunModel = dic1[@"POS_RunModel"];
        model.POS_RoomMode = dic1[@"POS_RoomMode"];
        model.POS_SendBillMode = dic1[@"POS_SendBillMode"];
        model.POS_PrintMode = dic1[@"POS_PrintMode"];
        model.POS_CashBoxOpenWay = dic1[@"POS_CashBoxOpenWay"];
        model.UDF01 = dic1[@"UDF01"];
        
        [dataArray addObject:model];
    }
    return dataArray;
}
@end
