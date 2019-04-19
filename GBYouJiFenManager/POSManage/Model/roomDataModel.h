//
//  roomDataModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface roomDataModel : NSObject
@property(nonatomic,copy)NSString *roomName;
@property(nonatomic,copy)NSString *roomType;
@property(nonatomic,copy)NSString *floorArea;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSString *isValid;
@property(nonatomic,copy)NSString *isBook;
@property(nonatomic,copy)NSString *ST002;
@property(nonatomic,copy)NSString *AF002;
@property(nonatomic,copy)NSString *SI007;
@property(nonatomic,copy)NSString *SI005;

//新增
@property(nonatomic,copy)NSString *SI017;
@property(nonatomic,copy)NSString *UDF06;



+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
