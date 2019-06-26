//
//  MemberModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *CREATE_DATE;
@property(nonatomic,copy)NSString *ShopType;
@property(nonatomic,copy)NSString *Phone;
@property(nonatomic,copy)NSString *Address;
@property(nonatomic,copy)NSString *Contact;
@property(nonatomic,copy)NSString *LogoUrl;
@property(nonatomic,copy)NSString *ShopCategory;
@property(nonatomic,copy)NSString *ShopName;
@property(nonatomic,copy)NSString *ShopDiscount ;
@property(nonatomic,copy)NSString *Mobile;
@property(nonatomic,copy)NSString *License;
@property(nonatomic,copy)NSString *LicensePhoto;
@property(nonatomic,copy)NSString *IDPhoto;
@property(nonatomic,copy)NSString *provName;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *boroName;
@property(nonatomic,copy)NSString *provCode;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *boroCode;
@property(nonatomic,copy)NSString *Latitude ;
@property(nonatomic,copy)NSString *Longitude;
@property(nonatomic,copy)NSString *UDF01;
@property(nonatomic,copy)NSString *UDF02;//店铺模式
@property(nonatomic,copy)NSString *UDF07;//起送金额
@property(nonatomic,copy)NSString *UDF03;//营业时间
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *Scores;
@property(nonatomic,copy)NSString *Cash1;
@property(nonatomic,copy)NSString *Cash2;
@property(nonatomic,copy)NSString *Cash3;
@property(nonatomic,copy)NSString *telphone;
@property(nonatomic,copy)NSString *Status;
@property(nonatomic,copy)NSString *bank_check;
@property(nonatomic,copy)NSString *IsUpdate;

@property(nonatomic,copy)NSString *IsGoodsAdd;
@property(nonatomic,copy)NSString *IsReportManager;
@property(nonatomic,copy)NSString *IsSystemSet;
@property(nonatomic,copy)NSString *IsCashManager;
@property(nonatomic,copy)NSString *circleCode;
@property(nonatomic,copy)NSString *circleName;
@property(nonatomic,copy)NSString *shoplabel;


+(NSMutableArray*)getDataWithDic:(NSDictionary*)dic;

+(NSMutableArray*)getDataWithDicPerson:(NSDictionary*)dic;

@end
