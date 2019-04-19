//
//  PayTypeModel.h
//  GBManagement
//
//  Created by 工博计算机 on 16/12/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTypeModel : NSObject
/**
 公司编号
 */
//@property(nonatomic,copy)NSString *COMPANY;
///**
//用户群组
// */
//@property(nonatomic,copy)NSString *SHOPID;
/**
结账类型
 */
@property(nonatomic,copy)NSString *CM001;
/**
结账名称
*/
@property(nonatomic,copy)NSString *CM002;
/**
快捷码
*/
@property(nonatomic,copy)NSString *CM003;
/**
面值类型
 */
@property(nonatomic,copy)NSString *CM011;
/**
面值币种
 */
@property(nonatomic,copy)NSString *CM012;
/**
 面值金额
 */
@property(nonatomic,copy)NSString *CM013;
/**
 限定每次可消费张数
 */
@property(nonatomic,copy)NSString *CM014;
/**
 是否可找零
 */
@property(nonatomic,copy)NSString *CM018;
/**
记录号码
 */
@property(nonatomic,copy)NSString *CM020;
/**
 是否被选中
 */
@property(nonatomic,assign)BOOL isSlected;
+(NSMutableArray *)getDatawithdic:(NSDictionary *)dic;
@end
