//
//  TasteRequestModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasteRequestModel : NSObject
@property(nonatomic,copy)NSString *tasteName;
@property(nonatomic,copy)NSString *tasteClasses;
@property(nonatomic,copy)NSString *itemNo;
@property(nonatomic,copy)NSString *tasteNumber;


@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic)BOOL selected;

+(NSMutableArray *)getDataWith:(NSDictionary *)dic;
@end
