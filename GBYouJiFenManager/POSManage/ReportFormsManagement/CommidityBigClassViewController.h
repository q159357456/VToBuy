//
//  CommidityBigClassViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettleBillModel.h"
@interface CommidityBigClassViewController : UIViewController
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITableView *commidityTable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *billTypeArray;
@property(nonatomic,copy)NSString *str1;
@property(nonatomic,copy)NSString *str2;

@property(nonatomic)NSInteger tagNumber;
@property(nonatomic,strong)NSArray *titleArr;
@end
