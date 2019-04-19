//
//  CouponModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/17.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property(nonatomic,copy)NSString *Amount1;
@property(nonatomic,copy)NSString *Amount2;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,copy)NSString *EndDate;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *LimitQuantity;
@property(nonatomic,copy)NSString *Quantity1;
@property(nonatomic,copy)NSString *Quantity2;
@property(nonatomic,copy)NSString *Quantity3;
@property(nonatomic,copy)NSString *StartDate;
@property(nonatomic,copy)NSString *MS001;
@property(nonatomic,copy)NSString *MS002;
@property(nonatomic,copy)NSString *GetDate;
@property(nonatomic,copy)NSString *UseDate;
@property(nonatomic,copy)NSString *Status;
@property(nonatomic,copy)NSString *Price1;
@property(nonatomic,copy)NSString *Price2;
@property(nonatomic,copy)NSString *ProductName;
@property(nonatomic,copy)NSString *ProductNo;
@property(nonatomic,copy)NSString *HEADIMG;
@property(nonatomic,copy)NSString *UDF01;
@property(nonatomic,copy)NSString *UDF02;
@property(nonatomic,copy)NSString *UDF03;
@property(nonatomic,copy)NSString *membername;



@property(nonatomic,copy)NSString *SHOPID;

+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
