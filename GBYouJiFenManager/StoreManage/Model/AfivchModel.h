//
//  AfivchModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfivchModel : NSObject
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString *Msg;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,assign)double height;
+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;
@end
