//
//  BaseModelObject.h
//  FengHuaKe
//
//  Created by chenheng on 2019/4/15.
//  Copyright © 2019年 gongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModelObject : NSObject
+(NSArray *)transformToModelList:(NSArray *)dataList;
+(instancetype)transformToModel:(NSDictionary*)jsonDic;
@end

NS_ASSUME_NONNULL_END
