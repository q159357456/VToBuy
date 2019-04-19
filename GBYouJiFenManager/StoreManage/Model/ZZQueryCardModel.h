//
//  ZZQueryCardModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/12/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZQueryCardModel : NSObject
//卡号，状态，开卡日期，生效日期，本金,赠金,积分，白积分，红积分,最近消费日期,最近充值日期
@property(nonatomic,copy)NSString *cardid;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *startdate;
@property(nonatomic,copy)NSString *effectdate;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *grants;
@property(nonatomic,copy)NSString *integral;
@property(nonatomic,copy)NSString *whitescores;
@property(nonatomic,copy)NSString *redscores;
@property(nonatomic,copy)NSString *usedate;
@property(nonatomic,copy)NSString *rechargedate;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
