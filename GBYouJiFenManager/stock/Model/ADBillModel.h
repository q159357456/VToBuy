//
//  ADBillModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADBillModel : NSObject
@property(nonatomic,copy)NSString *POtype;
@property(nonatomic,copy)NSString *SB002;
@property(nonatomic,copy)NSString *SB023;
@property(nonatomic,copy)NSString *ShopAmount;
@property(nonatomic,copy)NSString *discountAmount1;
@property(nonatomic,copy)NSString *discountAmount2;
@property(nonatomic,copy)NSString *payment0;
@property(nonatomic,copy)NSString *payment1;
@property(nonatomic,copy)NSString *payment2 ;
@property(nonatomic,copy)NSString *po;
@property(nonatomic,copy)NSString *sb015;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,assign)NSInteger funType;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
