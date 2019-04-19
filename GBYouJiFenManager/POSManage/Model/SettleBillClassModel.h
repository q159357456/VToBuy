//
//  SettleBillClassModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettleBillClassModel : NSObject
@property(nonatomic,copy)NSString *billName;
@property(nonatomic,copy)NSString *validCode;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,copy)NSString *billMode;

@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;
@end
