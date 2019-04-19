//
//  seatTimeModel.h
//  Restaurant
//
//  Created by 张帆 on 16/11/2.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface seatTimeModel : NSObject


/**
 是否可用
 */
@property(nonatomic,copy)NSString *preok;

/**
 预定时间段
 */
@property(nonatomic,copy)NSString *pretime;

/**
 开始时间
 */
@property(nonatomic,copy)NSString *t1;

/**
 结束时间
 */
@property(nonatomic,copy)NSString *t2;

/**
 状态信息
 */
@property(nonatomic,copy)NSString *msg;
@end
