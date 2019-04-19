//
//  BusinessClassify.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessClassify : NSObject
@property(nonatomic,copy)NSString *classifyNo;
@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic,copy)NSString *ParentNo;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
