//
//  TasteKindViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasteKindModel.h"
#import "TasteClassifyModel.h"
@interface TasteKindViewController : UIViewController
@property(nonatomic,weak)IBOutlet UITextField *ClassifyList;
@property(nonatomic,weak)IBOutlet UITextField *classifyName;
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();


@property(nonatomic,retain)TasteKindModel *TasteKindModel;

@property(nonatomic,copy)NSString *thingsNumber;

@property(nonatomic,copy)NSString *tasteClassStr;

@end
