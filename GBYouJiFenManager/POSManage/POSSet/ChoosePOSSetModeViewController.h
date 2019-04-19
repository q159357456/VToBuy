//
//  ChoosePOSSetModeViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/26.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettleBillClassModel.h"
#import "PCRegisyerModel.h"
@interface ChoosePOSSetModeViewController : UIViewController
@property(nonatomic)NSInteger tagNumber;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,copy)void(^backBlock)(NSString *str);
@property(nonatomic,copy)void(^backBlock1)(SettleBillClassModel *model);
@property(nonatomic,copy)void(^backBlock2)(PCRegisyerModel *model);
@end
