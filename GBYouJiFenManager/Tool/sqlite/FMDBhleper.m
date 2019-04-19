//
//  FMDBhleper.m
//  GongBo.2
//
//  Created by 工博计算机 on 16/8/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "FMDBhleper.h"

@implementation FMDBhleper
//创建单例
+(FMDBhleper*)shareDatabase
{
    static dispatch_once_t onceToken;
    static FMDBhleper *helper=nil;
    dispatch_once(&onceToken, ^{
        helper=[[FMDBhleper alloc]init];
        [helper createDB];
    });
    [helper openDb];
    return helper;
}
//创建数据库
-(void)createDB
{
    if(self.db != nil)
    {
        return;
    }
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [filePath stringByAppendingString:@"/gongbo4.db"];
    NSLog(@"%@",dbFilePath);
    self.db = [FMDatabase databaseWithPath:dbFilePath];
}
//打开数据库
-(void)openDb
{
    if (![self.db open]) {
        [self.db open];
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
}

@end
