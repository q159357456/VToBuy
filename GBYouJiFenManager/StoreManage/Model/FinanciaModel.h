//
//  FinanciaModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinanciaModel : NSObject
@property(nonatomic,copy)NSString *Cash1;
@property(nonatomic,copy)NSString *Cash2;
@property(nonatomic,copy)NSString *Count1;
@property(nonatomic,copy)NSString *Count2;
@property(nonatomic,copy)NSString *Count3;
@property(nonatomic,copy)NSString *Scores;
@property(nonatomic,copy)NSString *TotalAmount;
@property(nonatomic,copy)NSString *TotalAmount1;
@property(nonatomic,copy)NSString *TotalAmount2;
@property(nonatomic,copy)NSString *TotalAmount3;
@property(nonatomic,copy)NSString *TotalAmount4;
@property(nonatomic,copy)NSString *TotalAmount5;
@property(nonatomic,copy)NSString *TotalCount;
@property(nonatomic,strong)NSArray *Detail;
@property(nonatomic,copy)NSString *TotalShopAmount;
@property(nonatomic,copy)NSString *TotalShopAmount1;
@property(nonatomic,copy)NSString *TotalShopAmount2;


@property(nonatomic,copy)NSString *onlineamount1;
@property(nonatomic,copy)NSString *onlineamount2;
@property(nonatomic,copy)NSString *offlineamount1;
@property(nonatomic,copy)NSString *offlineamount2;
@property(nonatomic,copy)NSString *memberamount1;
@property(nonatomic,copy)NSString *memberamount2;
@property(nonatomic,copy)NSString *othercouponamount1;
@property(nonatomic,copy)NSString *othercouponamount2;
@property(nonatomic,copy)NSString *shopcouponamount1;
@property(nonatomic,copy)NSString *shopcouponamount2;
@property(nonatomic,copy)NSString *platformcouponamount1;
@property(nonatomic,copy)NSString *platformcouponamount2;
@property(nonatomic,copy)NSString *lotteryamount1;
@property(nonatomic,copy)NSString *lotteryamount2;
@property(nonatomic,copy)NSString *quitamount1;
@property(nonatomic,copy)NSString *quitamount2;
@property(nonatomic,copy)NSString *subamount1;
@property(nonatomic,copy)NSString *subamount2;

@property(nonatomic,copy)NSString *totalamount1;
@property(nonatomic,copy)NSString *totalamount2;






+(FinanciaModel*)getDataWithDic:(NSDictionary*)dic;
@end
