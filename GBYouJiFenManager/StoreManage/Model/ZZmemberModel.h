//
//  ZZmemberModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/12/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZmemberModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *SHOPID;
/**
 编号
 */
@property(nonatomic,copy)NSString *MS001;
/**
名称
 */
@property(nonatomic,copy)NSString *MS002;
/**
 性别
 */
@property(nonatomic,copy)NSString *MS006;
/**
 手机号码
 */
@property(nonatomic,copy)NSString *MS007;
@property(nonatomic,copy)NSString *MS008;
@property(nonatomic,copy)NSString *MS015;
/**
 本金=金币
 */
@property(nonatomic,copy)NSString *MS028;
/**
 赠金=代金券
 */
@property(nonatomic,copy)NSString *MS029;
@property(nonatomic,copy)NSString *MS030;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
