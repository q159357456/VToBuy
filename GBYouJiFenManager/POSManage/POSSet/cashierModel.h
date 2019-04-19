//
//  cashierModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cashierModel : NSObject
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *phoneNumber;//手机号码
@property(nonatomic,copy)NSString *screat;//密码
@property(nonatomic,copy)NSString *sureScreat;//确认密码
@property(nonatomic,copy)NSString *addRoom;;//创建房台
@property(nonatomic,copy)NSString *addGood;//新增商品
@property(nonatomic,copy)NSString *systemSet;//系统设置
@property(nonatomic,copy)NSString *memberManage;//会员管理
@property(nonatomic,copy)NSString *cashManage;//收银管理
@property(nonatomic,copy)NSString *changeMoney;//单品改价
@property(nonatomic,copy)NSString *isReport;//报表管理
@property(nonatomic,copy)NSString *discountSettle;//折扣
@property(nonatomic,copy)NSString *zengSong;//招待
@property(nonatomic,copy)NSString *Moling;//抹零
@property(nonatomic,copy)NSString *freezeAccount;//冻结账户

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
