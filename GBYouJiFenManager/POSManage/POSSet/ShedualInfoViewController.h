//
//  ShedualInfoViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scheduleModel.h"
@interface ShedualInfoViewController : UIViewController
@property(weak,nonatomic)IBOutlet UITextField *schedualBegin;
@property(weak,nonatomic)IBOutlet UITextField *schedualEnd;
@property(weak,nonatomic)IBOutlet UIButton *finishBtn;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,retain)scheduleModel *scheduModel;
@end
