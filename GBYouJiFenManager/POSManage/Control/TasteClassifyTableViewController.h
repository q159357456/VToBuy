//
//  TasteClassifyTableViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 xia. All rights reserved.

#import <UIKit/UIKit.h>
#import "TasteClassifyModel.h"
#import "MenuFunctionModel.h"
#import "QianTainRoleModel.h"
@interface TasteClassifyTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)NSMutableArray *ClassifyArray;
@property(nonatomic,copy)void(^backBlock)(NSMutableArray *selectArr);
@property(nonatomic)NSInteger tagNum;
@end
