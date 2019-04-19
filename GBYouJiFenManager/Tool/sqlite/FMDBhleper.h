//
//  FMDBhleper.h
//  GongBo.2
//
//  Created by 工博计算机 on 16/8/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface FMDBhleper : NSObject
@property(nonatomic,strong)FMDatabase *db;
//单例模式
+(FMDBhleper*) shareDatabase;

@end
