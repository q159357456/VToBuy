//
//  PayRecordModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayRecordModel : NSObject
@property(nonatomic,copy)NSString *HeadImg;
@property(nonatomic,copy)NSString *MS001;
@property(nonatomic,copy)NSString *MS002;
@property(nonatomic,copy)NSString *POtype;
@property(nonatomic,copy)NSString *SB014;
@property(nonatomic,copy)NSString *SB023;
@property(nonatomic,copy)NSString *SB002;
@property(nonatomic,copy)NSString *SB036;
@property(nonatomic,copy)NSString *ShopAmount;
@property(nonatomic,copy)NSString *Potype;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *shopid;
@property(nonatomic,copy)NSString *sb015;
@property(nonatomic,copy)NSString *Payment1;
@property(nonatomic,copy)NSString *Payment2;
@property(nonatomic,copy)NSString *po;
@property(nonatomic,copy)NSString *discountAmount1;
@property(nonatomic,copy)NSString *discountAmount2;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
