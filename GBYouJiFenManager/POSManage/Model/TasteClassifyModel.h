//
//  TasteClassifyModel.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasteClassifyModel : NSObject
@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic,copy)NSString *classifyNo;
@property(nonatomic,copy)NSString *classifyType;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
