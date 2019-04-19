//
//  FloorModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloorModel : NSObject
@property(nonatomic,copy)NSString *FloorInfo;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
