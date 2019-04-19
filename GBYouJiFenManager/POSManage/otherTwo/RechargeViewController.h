//
//  RechargeViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rechargeModel.h"
@interface RechargeViewController : UIViewController
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,strong)rechargeModel *ChargeModel;

@property(nonatomic,weak)IBOutlet UITextField *rechargeMoney;
@property(nonatomic,weak)IBOutlet UITextField *presentMoney;
@property(nonatomic,weak)IBOutlet UITextField *scores;
@end
