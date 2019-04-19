//
//  FMDBMember.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBhleper.h"
#import "MemberModel.h"
@interface FMDBMember : NSObject
@property(nonatomic,strong)FMDatabase *db;
//创建单例
+(FMDBMember*) shareInstance;
//查询
-(NSMutableArray *)getMemberData;
////更新
-(void)updateUser:(MemberModel*)groupModel;
//
//删除
//-(void)deleteTable :(MemberModel *)groupModel;
//增加
-(void)insertUser:(MemberModel *)groupModel;
//删除表
-(void)deleteTable;
@end
