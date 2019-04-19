//
//  addCashierViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cashierModel.h"
@interface addCashierViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,copy)void(^backBlock)();
@property(nonatomic,strong)cashierModel *cashModel;
@property(nonatomic,copy)NSString *typeString;
@end
