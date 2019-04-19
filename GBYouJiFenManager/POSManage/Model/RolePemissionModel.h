//
//  RolePemissionModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/27.
//  Copyright © 2017年 xia. All rights reserved.

#import <Foundation/Foundation.h>

@interface RolePemissionModel : NSObject
@property(nonatomic,copy)NSString *RoleNo;
@property(nonatomic,copy)NSString *RoleNa;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *Pno;
//@property(nonatomic,copy)NSString *Pna;
@property(nonatomic,copy)NSString *RightValue;
@property(nonatomic,copy)NSString *RoleNo1;
//@property(nonatomic,strong)NSMutableDictionary *CMS_RoleRight;

@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
//+(NSMutableArray *)getDataWithDic1:(NSDictionary *)dic;

@end
