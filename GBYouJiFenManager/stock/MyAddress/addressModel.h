//
//  addressModel.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addressModel : NSObject
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *area;

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *MemberNo;

@property(nonatomic,copy)NSString *address;

@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSString* defaultAddress;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;

@end
