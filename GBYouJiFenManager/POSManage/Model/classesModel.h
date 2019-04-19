//
//  classesModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface classesModel : NSObject
@property(nonatomic,copy)NSString *classesName;
@property(nonatomic,copy)NSString *beginTime;
@property(nonatomic,copy)NSString *endTime;

@property(nonatomic,copy)NSString *itemNo;

@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
