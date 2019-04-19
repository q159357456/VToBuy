//
//  CommodityBtnViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/2.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface CommodityBtnViewController : UIViewController
@property(strong,nonatomic)UITableView *table;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *funType;
@property(strong,nonatomic)UICollectionView *collection;
@property(nonatomic,copy)void(^backBlock)(NSMutableArray *chooseArray);
@property(nonatomic,copy)void(^KanJiaBlock)(ProductModel *model);
/**
 套餐子件用于选择判断
 */
@property(nonatomic,strong)NSMutableArray *combArray;
@end
