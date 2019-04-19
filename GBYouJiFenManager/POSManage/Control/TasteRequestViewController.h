//
//  TasteRequestViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasteRequestModel.h"
@interface TasteRequestViewController : UIViewController
@property(nonatomic,weak)IBOutlet UITextField *tasteName;
@property(nonatomic,weak)IBOutlet UITextField *tasteClasses;
@property(nonatomic,weak)IBOutlet UITextField *tasteNumber;
//@property(nonatomic,weak)IBOutlet UITextField *mutualexclusion;
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,copy)NSString *str;

@property(nonatomic,retain)TasteRequestModel *TRequestModel;

@property(nonatomic,copy)NSString *tasteClassStr;
@end
