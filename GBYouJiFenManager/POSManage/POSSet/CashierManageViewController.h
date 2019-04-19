//
//  CashierManageViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cashierModel.h"
@interface CashierManageViewController : UIViewController
@property(nonatomic,strong)UITableView *MemberTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL chooseType;
@property(nonatomic,copy)void(^backBlock)(cashierModel*);
@end
