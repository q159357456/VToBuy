//
//  deliveryModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface deliveryModel : NSObject
@property(nonatomic,copy)NSString *deliveryTime;
@property(nonatomic,copy)NSString *itemNo;

@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
