//
//  userAccountModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userAccountModel : NSObject
@property(nonatomic,copy)NSString *RoleNo;
@property(nonatomic,copy)NSString *Pno;
@property(nonatomic,copy)NSString *Account_No;
@property(nonatomic,copy)NSString *Account_Name;
@property(nonatomic,copy)NSString *isSuper;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *RightValue;
@property(nonatomic,copy)NSString *AccountNo;
@property(nonatomic,copy)NSString *AccountNo1;



@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
