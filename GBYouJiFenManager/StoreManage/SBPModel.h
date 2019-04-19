//
//  SBPModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPModel : NSObject
@property(nonatomic,copy)NSString *SBP003;
@property(nonatomic,copy)NSString *SBP004;
@property(nonatomic,copy)NSString *SBP005;
@property(nonatomic,copy)NSString *SBP009;
@property(nonatomic,copy)NSString *SBP010;
@property(nonatomic,copy)NSString *SBP011;
@property(nonatomic,copy)NSString *SBP014;
@property(nonatomic,copy)NSString *SBP015;
@property(nonatomic,copy)NSString *SBP016;
@property(nonatomic,copy)NSString *SBP017;
@property(nonatomic,copy)NSString *SBP027;
@property(nonatomic,copy)NSString *SBP032;
@property(nonatomic,copy)NSString *SBP026;
@property(nonatomic,copy)NSString *PSQuantity;
@property(nonatomic,copy)NSString *TFQuantity;
@property(nonatomic,assign)NSInteger leftCount;
@property(nonatomic,strong)NSMutableArray *SPTArray;
@property(nonatomic,strong)NSMutableArray *sonProductArray;
@property(nonatomic,strong)NSMutableString *detailMuStr;
@property(nonatomic,assign)float Bheight;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
