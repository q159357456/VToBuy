//
//  ClassesInfoViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "classesModel.h"
@interface ClassesInfoViewController : UIViewController
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;
@property(nonatomic,weak)IBOutlet UITextField *classes;
@property(nonatomic,weak)IBOutlet UITextField *Begin;
@property(nonatomic,weak)IBOutlet UITextField *End;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();



@property(nonatomic,retain)classesModel *ClassModel;
@end
