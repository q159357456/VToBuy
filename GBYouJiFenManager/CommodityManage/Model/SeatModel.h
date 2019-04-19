//
//  SeatModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatModel : NSObject
/**
 公司编号
 */
@property(nonatomic,copy)NSString *COMPANY;

/**
 商铺名称
 */
@property(nonatomic,copy)NSString *SHOPID;

/**
 房台编号
 */
@property(nonatomic,copy)NSString *SI001;

/**
 房台名称
 */
@property(nonatomic,copy)NSString *SI002;

/**
 房台类型
 */
@property(nonatomic,copy)NSString *SI003;

/**
 区域楼层编号
 */
@property(nonatomic,copy)NSString *SI004;

/**
 房台状态编号
 */
@property(nonatomic,copy)NSString *SI005;

/**
 最少开台人数
 */
@property(nonatomic,copy)NSString *SI006;

/**
 最多开台人数
 */
@property(nonatomic,copy)NSString *SI007;

/**
 显示序号
 */
@property(nonatomic,copy)NSString *SI008;

/**
 主台编号
 */
@property(nonatomic,copy)NSString *SI013;

/**
 虚拟台
 */
@property(nonatomic,copy)NSString *SI014;

/**
 是否显示
 */
@property(nonatomic,copy)NSString *SI015;

/**
 房卡号
 */
@property(nonatomic,copy)NSString *SI016;

/**
 台卡号
 */
@property(nonatomic,copy)NSString *SI017;

/**
 是否可预定
 */
@property(nonatomic,copy)NSString *SI018;

/**
 是否附加费
 */
@property(nonatomic,copy)NSString *SI019;
@property(nonatomic,copy)NSString *SS007;
/**
  账单价格
 */
@property(nonatomic,copy)NSString *UDF07;
/**
 选中
 */
@property(nonatomic,assign)BOOL isSelet;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
