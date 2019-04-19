//
//  DespositModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DespositModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,copy)NSString *CREATOR;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *IsBankProcess;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *ServiceCash;
@property(nonatomic,copy)NSString *WithdrawCash;
@property(nonatomic,copy)NSString *mode;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
