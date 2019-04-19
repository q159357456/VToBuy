//
//  ADModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADModel : NSObject
@property(nonatomic,copy)NSString *PicAddress1;
@property(nonatomic,copy)NSString *AD_No;
@property(nonatomic,copy)NSString *AD_Type;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
