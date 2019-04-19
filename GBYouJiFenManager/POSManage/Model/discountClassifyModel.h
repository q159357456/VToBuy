//
//  discountClassifyModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface discountClassifyModel : NSObject
@property(nonatomic,copy)NSString *VarDisPlay;
@property(nonatomic,copy)NSString *VarValue;

@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
