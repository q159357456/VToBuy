//
//  ResonModel.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/10.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResonModel : NSObject
@property(nonatomic,copy)NSString *CauseName_CN;
@property(nonatomic,assign)BOOL isSelected;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
