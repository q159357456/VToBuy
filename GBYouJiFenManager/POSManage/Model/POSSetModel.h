//
//  POSSetModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/25.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSSetModel : NSObject

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
//小票页脚
@property(nonatomic,copy)NSString *POS_Ordertitle;
@property(nonatomic,copy)NSString *POS_ReceiptTitle;
@property(nonatomic,copy)NSString *POS_MemberReceiptTitle;
@property(nonatomic,copy)NSString *POS_PassWorkTitle;
@property(nonatomic,copy)NSString *POS_CashBoxTitle;
@property(nonatomic,copy)NSString *POS_GiftTitle;
@property(nonatomic,copy)NSString *POS_GuanDanTitle;

//小票份数
@property(nonatomic,copy)NSString *POS_OrderPrintNum;
@property(nonatomic,copy)NSString *POS_MemberReceiptPrintNum;
@property(nonatomic,copy)NSString *POS_ReceiptPrintNum;
@property(nonatomic,copy)NSString *POS_PassWorkPrintNum;
@property(nonatomic,copy)NSString *POS_CashBoxPrintNum;
@property(nonatomic,copy)NSString *POS_GiftPrintNum;
@property(nonatomic,copy)NSString *POS_GuanDanPrintNum;

//其他设置
@property(nonatomic,copy)NSString *POS_SeatShowQty;
@property(nonatomic,copy)NSString *POS_SeatHeight;
@property(nonatomic,copy)NSString *POS_SeatWidth;
@property(nonatomic,copy)NSString *POS_BillHeight;
@property(nonatomic,copy)NSString *POS_BillWidth;
@property(nonatomic,copy)NSString *POS_GoodShowQty;
@property(nonatomic,copy)NSString *POS_SeatShowOtherQty;
@property(nonatomic,copy)NSString *POS_RunModel;
@property(nonatomic,copy)NSString *POS_RoomMode;
@property(nonatomic,copy)NSString *POS_SendBillMode;
@property(nonatomic,copy)NSString *POS_PrintMode;
@property(nonatomic,copy)NSString *POS_CashBoxOpenWay;
@property(nonatomic,copy)NSString *UDF01;

@end
