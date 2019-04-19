//
//  ProductModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString * SHOPID;
@property(nonatomic,copy)NSString *shopname;
@property(nonatomic,copy)NSString *StanPrice;
@property(nonatomic,copy)NSString *ManyBuy;
@property(nonatomic,copy)NSString *  Classify_2;
@property(nonatomic,copy)NSString *  ProductName;
@property(nonatomic,copy)NSString *Bonus;
@property(nonatomic,copy)NSString *  ProductNo;
@property(nonatomic,copy)NSString * rowid;
@property(nonatomic,copy)NSString *  RetailPrice;
@property(nonatomic,copy)NSString *  ClassifyName;
@property(nonatomic,copy)NSString *  PicAddress1;
@property(nonatomic,copy)NSString * SupplierNo;
@property(nonatomic,copy)NSString *PicAddress2;
@property(nonatomic,copy)NSString *  Unit;
@property(nonatomic,copy)NSString *  UPC_BarCode;
@property(nonatomic,copy)NSString *  IsUpDown;
@property(nonatomic,copy)NSString *  IsWeigh;
@property(nonatomic,copy)NSString *  Seq;
@property(nonatomic,copy)NSString *  Te_Gp;
@property(nonatomic,copy)NSString *  Dosage;
@property(nonatomic,copy)NSString *GP_Name;
@property(nonatomic,copy)NSString *Property;
@property(nonatomic,copy)NSString *bom;
@property(nonatomic,copy)NSString *BasicQuantity;
@property(nonatomic,copy)NSString *BasicQuantity1;
@property(nonatomic,strong)NSArray *POSDC;
@property(nonatomic,copy)NSString *InventoryQty;
@property(nonatomic,copy)NSString *E_BatchQty;
@property(nonatomic,copy)NSString *ProductSpec;
@property(nonatomic,copy)NSString *EffectiveDate;
@property(nonatomic,copy)NSString *ExpiryDate;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)NSString *SBP003;
@property(nonatomic,copy)NSString *SBP027;
@property(nonatomic,copy)NSString *SellPrice1;
@property(nonatomic,copy)NSString *SellPrice2;
@property(nonatomic,copy)NSString *IsHotGoods;
@property(nonatomic,copy)NSString *IsReceive;
@property(nonatomic,copy)NSString *ProductDesc;
@property(nonatomic,copy)NSString *DiscountMode;


//元件品号
@property(nonatomic,copy)NSString *DProductNo;
/**
 口味数据
 */
@property(nonatomic,strong)NSMutableArray *POSDIArray;
/**
 套餐子件数据
 */
@property(nonatomic,strong)NSMutableArray *DetailProductArray;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;

@end
