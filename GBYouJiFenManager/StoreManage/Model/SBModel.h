//
//  SBModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBModel : NSObject
@property(nonatomic,copy)NSString *SB002;
@property(nonatomic,copy)NSString *SB029;
@property(nonatomic,copy)NSString *SB016;
@property(nonatomic,copy)NSString *SB004;
//关联会员
@property(nonatomic,copy)NSString *MS002;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
