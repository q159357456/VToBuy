//
//  PCRegisyerModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCRegisyerModel : NSObject
@property(nonatomic,copy)NSString *PCMAC;
@property(nonatomic,copy)NSString *PCName;
@property(nonatomic,copy)NSString *PCArea;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
