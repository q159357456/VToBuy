//
//  discountViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "discountModel.h"
#import "discountClassifyModel.h"
@interface discountViewController : UIViewController
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *headView;

@property(nonatomic,retain)discountModel *dModel;

@property(nonatomic,strong)NSMutableArray *disTypeArray;

@end
