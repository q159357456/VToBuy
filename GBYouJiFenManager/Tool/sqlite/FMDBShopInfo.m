//
//  FMDBShopInfo.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FMDBShopInfo.h"

@implementation FMDBShopInfo
//创建单例
+(FMDBShopInfo*)shareInstance{
    static dispatch_once_t onceToken;
    static FMDBShopInfo *sharedInstance=nil;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FMDBShopInfo alloc]init];
    });
    [sharedInstance createUser];
    return sharedInstance;
}
-(void)createUser
{
//    @property(nonatomic,copy)NSString *ShopName;
//    @property(nonatomic,copy)NSString *SHOPID;
//    @property(nonatomic,copy)NSString *shopdiscount;
//    @property(nonatomic,copy)NSString *rowid;
//    @property(nonatomic,copy)NSString *phone;
//    @property(nonatomic,copy)NSString *logourl;
//    @property(nonatomic,copy)NSString *Contact;
//    @property(nonatomic,copy)NSString *Company;
//    @property(nonatomic,copy)NSString *Cheapgoods;
//    @property(nonatomic,copy)NSString *IsCoupon;
//    @property(nonatomic,copy)NSString *IsFullcut;
//    @property(nonatomic,copy)NSString *IsPreOrder;
//    @property(nonatomic,copy)NSString *address;
//    @property(nonatomic,copy)NSString *distance;
//    @property(nonatomic,copy)NSString *Mobile;
//    @property(nonatomic,copy)NSString *provName;
//    @property(nonatomic,copy)NSString *cityName ;
//    @property(nonatomic,copy)NSString *boroName ;
    self.db=[FMDBhleper shareDatabase].db;
    if(![self.db tableExists:@"ShopInfo"])
    {
        [self.db executeUpdate:@"CREATE TABLE ShopInfo(SHOPID TEXT PRIMARY KEY NOT NULL,ShopName TEXT)"];
        NSLog(@"create ShopInfo success");
    }
    else{
        
    }
    
}
//查询
-(NSMutableArray *)getShopInfo
{
    
    NSMutableArray *array=[NSMutableArray array];
    FMResultSet *rs = [self.db executeQuery:@"select * from ShopInfo"];
    while ([rs next]) {
        ADShopInfoModel *shop=[[ADShopInfoModel alloc]init];
    shop.SHOPID=[rs stringForColumn:@"SHOPID"];
    shop.ShopName=[rs stringForColumn:@"ShopName"];
     
     
        
        [array addObject:shop];
    }
    return array;
}

- (void)insertShopInfo:(ADShopInfoModel *)shopModel
{
    NSLog(@"%@",shopModel.SHOPID);
    FMResultSet *rs = [self.db executeQuery:@"select * from ShopInfo where SHOPID= ?",shopModel.SHOPID];
    
    if (![rs next]) {//如果不存在则插入
    
        BOOL b= [self.db executeUpdate:@"INSERT INTO ShopInfo (SHOPID,ShopName) VALUES(?,?)",shopModel.SHOPID,shopModel.ShopName];
        if(b==YES){
            NSLog(@"不存在则插入");
        }
    }else
    {
        NSLog(@"已经存在");
    }
   
    
    
}
-(void)deleteTable :(ADShopInfoModel *)shopModel
{
    
    self.db=[FMDBhleper shareDatabase].db;
    if([self.db tableExists:@"ShopInfo"])
    {
        [self.db executeUpdate:@"delete from ShopInfo where SHOPID=?",shopModel.SHOPID];
        NSLog(@"删除成功");
    }
    
    
}
//删除表
-(void)deleteTable
{
    
    self.db=[FMDBhleper shareDatabase].db;
    if([self.db tableExists:@"ShopInfo"])
    {
        [self.db executeUpdate:@"delete from ShopInfo"];
        NSLog(@"删除成功");
    }
    
    
}
@end
