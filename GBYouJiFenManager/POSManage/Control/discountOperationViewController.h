//
//  discountOperationViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "discountModel.h"
#import "discountClassifyModel.h"
@interface discountOperationViewController : UIViewController
@property(nonatomic,weak)IBOutlet UITextField *dName;
@property(nonatomic,weak)IBOutlet UITextField *dType;
@property(nonatomic,weak)IBOutlet UITextField *dAppoint;
@property(nonatomic,weak)IBOutlet UITextField *dPrint;
@property(nonatomic,weak)IBOutlet UITextField *dMoney;

@property(nonatomic,weak)IBOutlet UIButton *finishBtn;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();


@property(nonatomic,retain)discountModel *disModel;
@property(nonatomic,retain)discountClassifyModel *disClassModel;

@property(nonatomic,copy)NSString *discountItemNo;

@property(nonatomic,copy)NSString *discountName;

@end
