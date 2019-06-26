//
//  FMDBMember.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FMDBMember.h"

@implementation FMDBMember
//创建单例
+(FMDBMember*)shareInstance{
    static dispatch_once_t onceToken;
    static FMDBMember *sharedInstance=nil;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FMDBMember alloc]init];
    });
    [sharedInstance createUser];
    return sharedInstance;
}

-(void)createUser
{
    
    
    self.db=[FMDBhleper shareDatabase].db;
    if(![self.db tableExists:@"member"])
    {
        [self.db executeUpdate:@"CREATE TABLE member(COMPANY TEXT,SHOPID TEXT,CREATE_DATE TEXT,ShopType TEXT,Phone TEXT,Address TEXT,Contact TEXT,LogoUrl TEXT,ShopCategory TEXT,ShopDiscount TEXT,Mobile TEXT,License TEXT,LicensePhoto TEXT,IDPhoto TEXT,provName TEXT,cityName TEXT,boroName TEXT,Latitude TEXT,Longitude TEXT,ShopName TEXT,provCode TEXT,cityCode TEXT,boroCode TEXT,UDF01 TEXT,Remark TEXT,Scores TEXT,Cash1 TEXT,Cash2 TEXT,telphone TEXT,IsUpdate TEXT,IsGoodsAdd TEXT,IsReportManager TEXT,IsSystemSet TEXT,IsCashManager TEXT,Cash3 TEXT,circleName TEX,circleCode TEX,shoplabel TEX)"];
        NSLog(@"create member success");
        
    }
    else{
//        NSLog(@"已存在表");
    }
    
}


-(void)insertUser:(MemberModel *)groupModel
{
    NSLog(@"%@",groupModel.shoplabel);
    BOOL b= [self.db executeUpdate:@"INSERT INTO member(COMPANY,SHOPID,CREATE_DATE,ShopType,Phone,Address,Contact,LogoUrl,ShopCategory,ShopDiscount,Mobile,License,LicensePhoto,IDPhoto,provName,cityName,boroName,Latitude,Longitude,ShopName,provCode,cityCode,boroCode,UDF01,Remark,Scores,Cash1,Cash2,telphone,IsUpdate,IsGoodsAdd,IsReportManager,IsSystemSet,IsCashManager,Cash3,circleName,circleCode,shoplabel) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",groupModel.COMPANY,groupModel.SHOPID,groupModel.CREATE_DATE,groupModel.ShopType,groupModel.Phone,groupModel.Address,groupModel.Contact,groupModel.LogoUrl,groupModel.ShopCategory,groupModel.ShopDiscount,groupModel.Mobile,groupModel.License,groupModel.LicensePhoto,groupModel.IDPhoto,groupModel.provName,groupModel.cityName,groupModel.boroName,groupModel.Latitude,groupModel.Longitude,groupModel.ShopName,groupModel.provCode,groupModel.cityCode,groupModel.boroCode,groupModel.UDF01,groupModel.Remark,groupModel.Scores,groupModel.Cash1,groupModel.Cash2,groupModel.telphone,groupModel.IsUpdate,groupModel.IsGoodsAdd,groupModel.IsReportManager,groupModel.IsSystemSet,groupModel.IsCashManager,groupModel.Cash3,groupModel.circleName,groupModel.circleCode,groupModel.shoplabel];
    if(b==YES){
        NSLog(@"inser member success");
    }
    
    
}

//更新
-(void)updateUser:(MemberModel *)groupModel
{
    
    FMResultSet *rs = [self.db executeQuery:@"select * from member where SHOPID = ?",groupModel.SHOPID];
    //circleName=?;
    //circleCode=?
    if ([rs next]) {
        BOOL operaResult = [self.db executeUpdate:@"UPDATE member SET Latitude=?,Contact=?,cityName=?,boroName=?,Phone=?,cityCode=?,provName=?,Longitude=?,Address=?,boroCode=?,provCode=?,Remark=?,Scores=?,Cash1=?,Cash2=?,IsUpdate=?,Cash3=?,circleName=?,circleCode=?,shoplabel=? WHERE SHOPID=?",groupModel.Latitude,groupModel.Contact,groupModel.cityName,groupModel.boroName,groupModel.Phone,groupModel.cityCode,groupModel.provName,groupModel.Longitude,groupModel.Address,groupModel.boroCode,groupModel.provCode,groupModel.Remark,groupModel.Scores,groupModel.Cash1,groupModel.Cash2,groupModel.IsUpdate,groupModel.Cash3,groupModel.SHOPID,groupModel.circleName,groupModel.circleCode,groupModel.shoplabel];
        if(operaResult==YES){
            NSLog(@"update member success");
        }
    }else{
        NSLog(@"数据库不存在此条数据%@",groupModel);
    }
    
    
    
}


//查询
-(NSMutableArray *)getMemberData
{
    NSMutableArray *array=[NSMutableArray array];
    FMResultSet *rs = [self.db executeQuery:@"select * from member"];
    while ([rs next]) {
        MemberModel *group=[[MemberModel alloc]init];
       
       
        group.COMPANY=[rs stringForColumn:@"COMPANY"];
        group.SHOPID=[rs stringForColumn:@"SHOPID"];
        group.CREATE_DATE=[rs stringForColumn:@"CREATE_DATE"];
        group.ShopType=[rs stringForColumn:@"ShopType"];
        group.Phone=[rs stringForColumn:@"Phone"];
        group.Address=[rs stringForColumn:@"Address"];
        group.Contact=[rs stringForColumn:@"Contact"];
        group.LogoUrl=[rs stringForColumn:@"LogoUrl"];
        group.ShopCategory=[rs stringForColumn:@"ShopCategory"];
        group.ShopDiscount=[rs stringForColumn:@"ShopDiscount"];
        group.Mobile=[rs stringForColumn:@"Mobile"];
        group.License=[rs stringForColumn:@"License"];
        group.LicensePhoto=[rs stringForColumn:@"LicensePhoto"];
        group.IDPhoto=[rs stringForColumn:@"IDPhoto"];
        group.provName=[rs stringForColumn:@"provName"];
        group.cityName=[rs stringForColumn:@"cityName"];
        group.boroName=[rs stringForColumn:@"boroName"];
        group.ShopName=[rs stringForColumn:@"ShopName"];
        group.provCode=[rs stringForColumn:@"provCode"];
        group.cityCode=[rs stringForColumn:@"cityCode"];
        group.boroCode=[rs stringForColumn:@"boroCode"];
        group.Longitude=[rs stringForColumn:@"Longitude"];
        group.Latitude=[rs stringForColumn:@"Latitude"];
         group.UDF01=[rs stringForColumn:@"UDF01"];
        group.Remark=[rs stringForColumn:@"Remark"];
        group.Scores=[rs stringForColumn:@"Scores"];
        group.Cash1=[rs stringForColumn:@"Cash1"];
        group.Cash2=[rs stringForColumn:@"Cash2"];
        group.Cash3 = [rs stringForColumn:@"Cash3"];
        group.telphone=[rs stringForColumn:@"telphone"];
        group.IsUpdate=[rs stringForColumn:@"IsUpdate"];
        group.IsGoodsAdd = [rs stringForColumn:@"IsGoodsAdd"];
        group.IsReportManager = [rs stringForColumn:@"IsReportManager"];
        group.IsSystemSet = [rs stringForColumn:@"IsSystemSet"];
        group.IsCashManager = [rs stringForColumn:@"IsCashManager"];
        group.circleCode = [rs stringForColumn:@"circleCode"];
        group.circleName = [rs stringForColumn:@"circleName"];
        group.shoplabel = [rs stringForColumn:@"shoplabel"];
        [array addObject:group];
    }
    return array;
}

//-(void)deleteTable :(MemberModel *)groupModel
//{
//    
//    self.db=[FMDBhleper shareDatabase].db;
//    if([self.db tableExists:@"member"])
//    {
//        [self.db executeUpdate:@"delete from member where GP_No=?",groupModel.GP_No];
//        NSLog(@"删除成功");
//    }
//    
//    
//}
//删除表
-(void)deleteTable
{
    
    self.db=[FMDBhleper shareDatabase].db;
    if([self.db tableExists:@"member"])
    {
        [self.db executeUpdate:@"delete from member"];
        NSLog(@"删除成功");
    }
    
    
}

@end
