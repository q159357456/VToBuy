//
//  FMDBShopCar.m
//  GongBo.2
//
//  Created by 工博计算机 on 16/8/12.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "FMDBShopCar.h"

@implementation FMDBShopCar
//创建单例
+(FMDBShopCar*)shareInstance{
    static dispatch_once_t onceToken;
    static FMDBShopCar *sharedInstance=nil;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FMDBShopCar alloc]init];
    });
    [sharedInstance createUser];
    return sharedInstance;
}

-(void)createUser
{

    self.db=[FMDBhleper shareDatabase].db;
    if(![self.db tableExists:@"shopCar"])
    {
        [self.db executeUpdate:@"CREATE TABLE shopCar(ProductNo TEXT PRIMARY KEY NOT NULL,COMPANY TEXT,SHOPID TEXT,ProductName TEXT,ProductSpec TEXT,count integer,Unit TEXT,RetailPrice TEXT,StanPrice TEXT,SupplierNo TEXT,ManyBuy TEXT,PicAddress1 TEXT,PicAddress2 TEXT, Property TEXT,shopname TEXT )"];
        NSLog(@"create shopCar1 success");
    }
    else{
      
    }
    
}
//增
-(void)insertUser:(ProductModel *)shopCarModel
{
    
    FMResultSet *rs = [self.db executeQuery:@"select * from shopCar where ProductNo= ?",shopCarModel.ProductNo];
    
    if ([rs next]) {//如果存在ID ，更新
        NSLog(@"已存在增加数量");
        [self updateUser:shopCarModel];
    }else{//根据ID创建一条新的数据
       NSLog(@"不存在插入新数据");
        [self insertShopCar:shopCarModel];
        
    }
    
}

- (void)insertShopCar:(ProductModel *)pmodel
{
    NSLog(@"----%ld",pmodel.count);
    BOOL b= [self.db executeUpdate:@"INSERT INTO shopCar (ProductNo,COMPANY,SHOPID,ProductName,ProductSpec,count,Unit,RetailPrice,StanPrice,SupplierNo,ManyBuy,PicAddress1,PicAddress2,Property,shopname) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",pmodel.ProductNo,pmodel.COMPANY,pmodel.SHOPID,pmodel.ProductName,pmodel.ProductSpec,[NSString stringWithFormat:@"%ld",pmodel.count],pmodel.Unit,pmodel.RetailPrice,pmodel.StanPrice,pmodel.SupplierNo,pmodel.ManyBuy,pmodel.PicAddress1,pmodel.PicAddress2,pmodel.Property,pmodel.shopname];
    if(b==YES){
         NSLog(@"inser shopCar success");
    }
    
    
}
//更新数量
-(void)updateUser:(ProductModel *)shopCarModel
{
//    NSLog(@"count: %ld",shopCarModel.count);
    FMResultSet *rs = [self.db executeQuery:@"select * from shopCar where ProductNo = ?",shopCarModel.ProductNo];
    
    if ([rs next]) {
        BOOL operaResult = [self.db executeUpdate:@"UPDATE shopCar SET count=? WHERE ProductNo=?",[NSString stringWithFormat:@"%ld",shopCarModel.count],shopCarModel.ProductNo];
        if(operaResult==YES){
            NSLog(@"update shopCar success");
        }
    }else{
        NSLog(@"数据库不存在此条数据%@",shopCarModel);
    }
    
    
    
}
//更新选中状态
-(void)updatSelected:(ProductModel*)pmodel
{
   
//    FMResultSet *rs = [self.db executeQuery:@"select * from shopCar where ProductNo = ?",shopCarModel.ProductNo];
//    
//    if ([rs next]) {
//         NSLog(@"status: %@",[NSString stringWithFormat:@"%ld",shopCarModel.selected]);
//        BOOL operaResult = [self.db executeUpdate:@"UPDATE shopCar SET selected=? WHERE ProductNo=?",[NSString stringWithFormat:@"%ld",shopCarModel.selected],shopCarModel.ProductNo];
//        if(operaResult==YES){
//            NSLog(@"update shopCar success");
//        }
//    }else{
//        NSLog(@"数据库不存在此条数据%@",shopCarModel);
//    }
}

//查询
-(NSMutableArray *)getShopCarModel
{
   
    NSMutableArray *array=[NSMutableArray array];
      FMResultSet *rs = [self.db executeQuery:@"select * from shopCar"];
    while ([rs next]) {
        ProductModel *shopCar=[[ProductModel alloc]init];
        shopCar.ProductNo=[rs stringForColumn:@"ProductNo"];
        shopCar.COMPANY=[rs stringForColumn:@"COMPANY"];
        shopCar.SHOPID=[rs stringForColumn:@"SHOPID"];
        shopCar.ProductName=[rs stringForColumn:@"ProductName"];
        shopCar.count=[rs intForColumn:@"count"];
        shopCar.ProductSpec=[rs stringForColumn:@"ProductSpec"];
        shopCar.Unit=[rs stringForColumn:@"Unit"];
        shopCar.Property=[rs stringForColumn:@"Property"];
        shopCar.RetailPrice=[rs stringForColumn:@"RetailPrice"];
        shopCar.StanPrice=[rs stringForColumn:@"StanPrice"];;
        shopCar.SupplierNo=[rs stringForColumn:@"SupplierNo"];
        shopCar.ManyBuy=[rs stringForColumn:@"ManyBuy"];
        shopCar.PicAddress1=[rs stringForColumn:@"PicAddress1"];
        shopCar.PicAddress2=[rs stringForColumn:@"PicAddress2"];
        shopCar.shopname=[rs stringForColumn:@"shopname"];
        [array addObject:shopCar];
    }
    return array;
}

-(void)deleteTable :(ProductModel *)shopCarModel
{
    
    self.db=[FMDBhleper shareDatabase].db;
    if([self.db tableExists:@"shopCar"])
    {
        [self.db executeUpdate:@"delete from shopCar where ProductNo=?",shopCarModel.ProductNo];
        NSLog(@"删除成功");
    }
    
    
}
//删除表
-(void)deleteTable
{
    
    self.db=[FMDBhleper shareDatabase].db;
    if([self.db tableExists:@"shopCar"])
    {
        [self.db executeUpdate:@"delete from shopCar"];
        NSLog(@"删除成功");
    }
    
    
}

@end
