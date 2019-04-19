//
//  paymentDetailModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface paymentDetailModel : NSObject
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *payMoneyPPP;
@property(nonatomic,copy)NSString *originalMoneyPPP;
@property(nonatomic,copy)NSString *homeMoneyPPP;
@property(nonatomic,copy)NSString *changeMoneyPPP;
@property(nonatomic,copy)NSString *dateTime;
@property(nonatomic,copy)NSString *billType;
@end
