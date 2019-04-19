//
//  datePaymentDetailModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface datePaymentDetailModel : NSObject
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *payMoneyPEP;
@property(nonatomic,copy)NSString *originalMoneyPEP;
@property(nonatomic,copy)NSString *homeMoneyPEP;
@property(nonatomic,copy)NSString *changeMoneyPEP;
@property(nonatomic,copy)NSString *dateTime;
@property(nonatomic,copy)NSString *BillType;
@end
