//
//  rechargeModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rechargeModel : NSObject
@property(nonatomic,copy)NSString *CashNumber;
@property(nonatomic,copy)NSString *PresentNumber;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,copy)NSString *CreditsScore;
@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;

@end
