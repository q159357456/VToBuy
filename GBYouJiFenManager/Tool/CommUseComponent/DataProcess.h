//
//  DataProcess.h
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/4/17.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelObject.h"
/****url define****/
#define GetCommSelectDataInfo3 @"SystemCommService.asmx/GetCommSelectDataInfo3"
#define GetCommSelectDataInfo4 @"SystemCommService.asmx/GetCommSelectDataInfo4"
/****表查询define****/
#define TableQuery_Ordinary(tablename,selectfield,condition,selectorserby)   ([DataProcess TabelName:tablename SelectField:selectfield Condition:condition SelectOrderBy:selectorserby])
/*******/
//默认城市
#define defaultCityName @"东莞市"
#define defaultCityCode @"441900"
#define ResponseTable(a) (a[@"DataSet"][@"Table"])
NS_ASSUME_NONNULL_BEGIN

@interface DataProcess : NSObject
//增删改
+(NSString*)AddJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data;
+(NSString*)EditJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data;
+(NSString*)DeletJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data;

//表查询
+(NSDictionary*)TabelName:(NSString*)tableName SelectField:(NSString *)SelectField Condition:(NSString *)Condition SelectOrderBy:(NSString *)SelectOrderBy;
+(NSDictionary*)TabelName:(NSString*)tableName SelectField:(NSString *)SelectField Condition:(NSString *)Condition SelectOrderBy:(NSString *)SelectOrderBy Page:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
