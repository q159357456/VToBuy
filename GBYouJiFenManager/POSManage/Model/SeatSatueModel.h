//
//  SeatSatueModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatSatueModel : NSObject
@property(nonatomic,copy)NSString *SS001;
@property(nonatomic,copy)NSString *SS002;
@property(nonatomic,copy)NSString *SS007;
@property(nonatomic,copy)NSString *SS008;
@property(nonatomic,assign)BOOL isSlected;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
