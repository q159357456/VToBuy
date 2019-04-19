//
//  QianTainRoleModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QianTainRoleModel : NSObject
@property(nonatomic,copy)NSString *RoleNa;

@property(nonatomic,copy)NSString *RoleNo;

@property(nonatomic,copy)NSString *AccountNo;

@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
