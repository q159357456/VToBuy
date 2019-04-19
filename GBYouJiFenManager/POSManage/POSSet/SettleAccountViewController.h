//
//  SettleAccountViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettleBillModel.h"
@interface SettleAccountViewController : UIViewController
@property(nonatomic,weak)IBOutlet UIButton *doneButton;
@property(nonatomic,weak)IBOutlet UITableView *table;

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *SettleBillArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,strong)SettleBillModel *SBModel;

@end
