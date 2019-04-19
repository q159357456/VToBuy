//
//  ADShopInfoModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADShopInfoModel : NSObject
@property(nonatomic,copy)NSString *ShopName;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *shopdiscount;
@property(nonatomic,copy)NSString *rowid;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *logourl;
@property(nonatomic,copy)NSString *Contact;
@property(nonatomic,copy)NSString *Company;
@property(nonatomic,copy)NSString *Cheapgoods;
@property(nonatomic,copy)NSString *IsCoupon;
@property(nonatomic,copy)NSString *IsFullcut;
@property(nonatomic,copy)NSString *IsPreOrder;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *distance;
@property(nonatomic,copy)NSString *Mobile;
@property(nonatomic,copy)NSString *provName;
@property(nonatomic,copy)NSString *cityName ;
@property(nonatomic,copy)NSString *boroName ;
+(ADShopInfoModel *)getDatawithdic:(NSDictionary *)dic;
@end
