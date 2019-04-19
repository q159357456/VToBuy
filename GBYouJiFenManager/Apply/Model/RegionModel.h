//
//  RegionModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionModel : NSObject
@property(nonatomic,copy)NSString *provName;
@property(nonatomic,copy)NSString *provCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *boroName;
@property(nonatomic,copy)NSString *boroCode;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic withStr:(NSString*)str;
@end
