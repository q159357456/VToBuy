//
//  MenuFunctionModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuFunctionModel : NSObject
@property(nonatomic,copy)NSString *Pno;
@property(nonatomic,copy)NSString *Pna;
@property(nonatomic,copy)NSString *RightValue;
@property(nonatomic,copy)NSString *RoleNo;
@property(nonatomic,copy)NSString *AccountNo;

@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
