//
//  CloseReportModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloseReportModel : NSObject
@property(nonatomic,copy)NSString *classesTimes;
@property(nonatomic,copy)NSString *operateTime;
@property(nonatomic,copy)NSString *operateMachine;
@property(nonatomic,copy)NSString *FormsNumber;
@property(nonatomic)BOOL selected;
@property(nonatomic,copy)NSString *PI001;
@property(nonatomic,copy)NSString *PI002;
@property(nonatomic,copy)NSString *PI006;
@property(nonatomic,copy)NSString *PI008;
@property(nonatomic,copy)NSString *PI009;
@property(nonatomic,copy)NSString *PI010;
@property(nonatomic,copy)NSString *PI011;
@property(nonatomic,copy)NSString *PI012;
@property(nonatomic,copy)NSString *PI013;
@property(nonatomic,copy)NSString *PI014;
@property(nonatomic,copy)NSString *PI015;
@property(nonatomic,copy)NSString *PI016;
@property(nonatomic,copy)NSString *PI017;
@property(nonatomic,copy)NSString *PI018;
@property(nonatomic,copy)NSString *PI019;
@property(nonatomic,copy)NSString *PI020;
@property(nonatomic,copy)NSString *PI021;
@property(nonatomic,copy)NSString *PI022;
@property(nonatomic,copy)NSString *PI023;
@property(nonatomic,copy)NSString *PI024;
@property(nonatomic,copy)NSString *PI025;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *UDF03;
@property(nonatomic,copy)NSString *UDF07;
@property(nonatomic,copy)NSString *UDF08;
@property(nonatomic,copy)NSString *UDF09;
@property(nonatomic,copy)NSString *UDF10;
@property(nonatomic,copy)NSString *UDF11;
@property(nonatomic,copy)NSString *area;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;

@end
