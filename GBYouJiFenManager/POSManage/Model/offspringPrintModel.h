//
//  offspringPrintModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface offspringPrintModel : NSObject
@property(nonatomic,copy)NSString *PrinterName;
@property(nonatomic,copy)NSString *PrinterIP;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,copy)NSString *BigClasses;
@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;
@end
