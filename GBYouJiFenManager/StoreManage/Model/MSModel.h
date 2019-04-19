//
//  MSModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSModel : NSObject
@property(nonatomic,copy)NSString *Amount;
@property(nonatomic,copy)NSString *BuyCount;
@property(nonatomic,copy)NSString *create_date;
@property(nonatomic,copy)NSString *ms001;
@property(nonatomic,copy)NSString *ms002 ;
@property(nonatomic,copy)NSString *ms008;
@property(nonatomic,copy)NSString *rowid;
@property(nonatomic,copy)NSString *udf06;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
