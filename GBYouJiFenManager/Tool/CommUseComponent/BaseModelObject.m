//
//  BaseModelObject.m
//  FengHuaKe
//
//  Created by chenheng on 2019/4/15.
//  Copyright © 2019年 gongbo. All rights reserved.
//

#import "BaseModelObject.h"

@implementation BaseModelObject
+(NSArray *)transformToModelList:(NSArray *)dataList
{
    Class class = [self class];
    NSArray *reslut = [class mj_objectArrayWithKeyValuesArray:dataList];
    return reslut;
}
+(instancetype)transformToModel:(NSDictionary*)jsonDic{
    
    Class class = [self class];
    return  [class mj_objectWithKeyValues:jsonDic];
    
}
@end
