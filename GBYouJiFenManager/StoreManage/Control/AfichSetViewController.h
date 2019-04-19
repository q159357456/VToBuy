//
//  AfichSetViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfivchModel.h"
@interface AfichSetViewController : UIViewController
@property(nonatomic,retain)AfivchModel * model;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)void(^backBlock)();
@end
