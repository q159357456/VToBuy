//
//  DataProcess.m
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/4/17.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import "DataProcess.h"

@implementation DataProcess
/****增删改 start****/
+(NSString*)AddJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data{
    return [DataProcess handleJson:@"Add" TableName:tableName Data:data];
}
+(NSString*)EditJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data{
   return [DataProcess handleJson:@"Edit" TableName:tableName Data:data];
}
+(NSString*)DeletJsonTableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data{
   return [DataProcess handleJson:@"Del" TableName:tableName Data:data];

}
+(NSString*)handleJson:(NSString*)funName TableName:(NSString*)tableName Data:(NSArray<NSDictionary*>*)data{
    
    NSDictionary *jsonArray=@{@"Command":funName,@"TableName":tableName,@"Data":data};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonArray options:kNilOptions error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    return jsonStr;

}
/****增删改 end****/
/****表查询 start****/
+(NSDictionary*)TabelName:(NSString*)tableName SelectField:(NSString *)SelectField Condition:(NSString *)Condition SelectOrderBy:(NSString *)SelectOrderBy;
{
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":SelectOrderBy,@"CipherText":CIPHERTEXT};
    
    return dic;
}
+(NSDictionary*)TabelName:(NSString*)tableName SelectField:(NSString *)SelectField Condition:(NSString *)Condition SelectOrderBy:(NSString *)SelectOrderBy Page:(NSInteger)page
{
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":SelectOrderBy,@"CipherText":CIPHERTEXT,@"Page":[NSNumber numberWithInteger:page],@"PageSize":@20};
    
    return dic;
}
@end
