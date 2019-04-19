//
//  InternalRegisterViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternalRegisterModel.h"
@interface InternalRegisterViewController : UIViewController
@property(weak,nonatomic)IBOutlet UILabel *lab1;
@property(weak,nonatomic)IBOutlet UILabel *lab2;


@property(weak,nonatomic)IBOutlet UITextField *equipmentName;
@property(weak,nonatomic)IBOutlet UITextField *roomName;
@property(weak,nonatomic)IBOutlet UIButton *finishBtn;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();


@property(nonatomic,copy)NSString *string;
@property(nonatomic,copy)NSString *roomStr;

@property(nonatomic,retain)InternalRegisterModel *internalModel;
@end
