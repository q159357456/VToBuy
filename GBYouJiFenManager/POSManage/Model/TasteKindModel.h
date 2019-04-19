//
//  TasteKindModel.h
//  GBYouJiFenManager

//  Created by mac on 17/5/10.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasteKindModel : NSObject
@property(nonatomic,copy)NSString *classifyList;
@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic,copy)NSString *itemNo;

@property(nonatomic,assign)BOOL selected;

+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
