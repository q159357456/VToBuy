//
//  PcModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/10/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PcModel : NSObject
@property(nonatomic,copy)NSString *PC004;
@property(nonatomic,copy)NSString *PC008;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
