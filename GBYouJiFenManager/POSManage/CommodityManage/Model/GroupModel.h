//
//  GroupModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
@property(nonatomic,copy)NSString *GP_No;
@property(nonatomic,copy)NSString *GP_Name;
@property(nonatomic,copy)NSString *BasicQuantity;
@property(nonatomic,copy)NSString *beiZhu;
@property(nonatomic,assign)BOOL selected;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
