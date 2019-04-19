//
//  OffspringViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.

#import <UIKit/UIKit.h>
#import "offspringPrintModel.h"
#import "TasteKindModel.h"
@interface OffspringViewController : UIViewController
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,strong)offspringPrintModel *OffSPModel;

@property(nonatomic,weak)IBOutlet UITextField *printName;
@property(nonatomic,weak)IBOutlet UITextField *printIP;
@property(nonatomic,weak)IBOutlet UITextField *ClassList;
@property(nonatomic,weak)IBOutlet UIButton *done;

@property(nonatomic,copy)NSString *thingsNumber;
@property(nonatomic,copy)NSString *tasteClassStr;


@end
