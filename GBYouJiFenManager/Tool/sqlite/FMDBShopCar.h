//
//  FMDBShopCar.h
//  GongBo.2
//
//  Created by 工博计算机 on 16/8/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBhleper.h"
#import "ProductModel.h"
@interface FMDBShopCar : NSObject
@property(nonatomic,strong)FMDatabase *db;

//创建单例
+(FMDBShopCar*) shareInstance;
//查询
-(NSMutableArray *)getShopCarModel;
////更新
-(void)updateUser:(ProductModel *)shopCarModel;
//
-(void)updatSelected:(ProductModel*)shopCarModel;
//删除
-(void)deleteTable :(ProductModel *)shopCarModel;
//增加
-(void)insertUser:(ProductModel *)shopCarModel;
//删除表
-(void)deleteTable;
@end
