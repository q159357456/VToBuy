//
//  INV_ProductModel.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INV_ProductModel : NSObject
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *Classify_1;
@property(nonatomic,copy)NSString *Classify_2;
@property(nonatomic,copy)NSString *Classify_3;
@property(nonatomic,copy)NSString *Classify_4;

@property(nonatomic,copy)NSString *InventoryQty;
@property(nonatomic,copy)NSString *PicAddress1;
@property(nonatomic,copy)NSString *PicAddress2;
/**
 *  产品名称
 */
@property(nonatomic,copy)NSString *ProductName;
/**
 *  产品编号
 */
@property(nonatomic,copy)NSString *ProductNo;
@property(nonatomic,copy)NSString *ProductSpec;
/**
 *  零售价格
 */
@property(nonatomic,copy)NSString *RetailPrice;
/**
 *  商店id
 */
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *Unit;


@property(nonatomic,copy)NSString *SameProductNum;
/**
 *  新接口多的参数，规格数组
 */
@property(nonatomic,strong)NSArray *POSDC;

/**
 *  送单方式
 */
@property(nonatomic,copy)NSString *sendStyle;

/**
 商品属性 用来判断是否为套餐
 */
@property(nonatomic,copy)NSString *Property;

/**
 商品项次
 */
@property(nonatomic,copy)NSString *SBP003;

/**
 所属项次
 */
@property(nonatomic,copy)NSString *SBP027;

/**
 群组
 */
@property(nonatomic,copy)NSString *SBP028;

/**
 组成用量
 */
@property(nonatomic,copy)NSString *Dosage;

/**
 数量
 */
@property(nonatomic,copy)NSString *mount;

/**
 数量
 */
@property(nonatomic,copy)NSString *SBP009;
@property(nonatomic,assign)NSInteger count;

/**
口味数据
 */
@property(nonatomic,strong)NSMutableArray *POSDIArray;
/**
 套餐子件数据
 */
@property(nonatomic,strong)NSMutableArray *DetailProductArray;

/**
 套餐描述
 */
@property(nonatomic,strong)NSMutableString *detailMuStr;
@property(nonatomic,assign)float height;
+(NSMutableArray *)getDataWithDic:(NSDictionary *)dic;
@end
