//
//  InternalRegisterModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/6.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternalRegisterModel : NSObject
@property(nonatomic,copy)NSString *roomName;
@property(nonatomic,copy)NSString *equipmentName;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
