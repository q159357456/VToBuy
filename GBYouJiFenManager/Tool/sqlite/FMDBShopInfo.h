//
//  FMDBShopInfo.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBhleper.h"
#import "ADShopInfoModel.h"
@interface FMDBShopInfo : NSObject
@property(nonatomic,strong)FMDatabase *db;

//创建单例
+(FMDBShopInfo*) shareInstance;
//查询
-(NSMutableArray *)getShopInfo;
//删除
-(void)deleteTable :(ADShopInfoModel *)shopModel;
//增加
- (void)insertShopInfo:(ADShopInfoModel *)shopModel;
//删除表
-(void)deleteTable;

@end
