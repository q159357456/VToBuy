//
//  ScaleModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleModel : NSObject
@property(nonatomic,copy)NSString *IPAddress;
@property(nonatomic,copy)NSString *StartUsing;
@property(nonatomic,copy)NSString *itemNo;

@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;
@end
