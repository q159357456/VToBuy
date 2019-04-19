//
//  DateCommidityBigClassModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCommidityBigClassModel : NSObject
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *classesNameEI;
@property(nonatomic,copy)NSString *orderMoneyEI;
@property(nonatomic,copy)NSString *discountMoneyEI;
@property(nonatomic,copy)NSString *actuallyMoneyEI;
@end
