//
//  ZZmbrModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/12/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZmbrModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *SHOPID;
/**
 */
@property(nonatomic,copy)NSString *MS001;
@property(nonatomic,copy)NSString *CREATOR;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,copy)NSString *MODIFIER;
@property(nonatomic,copy)NSString *MODI_DATE;
@property(nonatomic,copy)NSString *FLAG;
@property(nonatomic,copy)NSString *IsUpdate;
@property(nonatomic,copy)NSString *MBR000;
@property(nonatomic,copy)NSString *MBR001;
@property(nonatomic,copy)NSString *MBR002;
@property(nonatomic,copy)NSString *MBR003;
@property(nonatomic,copy)NSString *MBR004;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *cash;
@property(nonatomic,copy)NSString *goodsif;
@property(nonatomic,copy)NSString *grade;
@property(nonatomic,copy)NSString *redscores;
@property(nonatomic,copy)NSString *whitescores;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
