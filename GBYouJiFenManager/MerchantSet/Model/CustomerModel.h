//
//  CustomerModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/24.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject
@property(nonatomic,copy)NSString *MS001;
@property(nonatomic,copy)NSString *MS002;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
