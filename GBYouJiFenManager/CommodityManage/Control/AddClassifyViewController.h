//
//  AddClassifyViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"
@interface AddClassifyViewController : UIViewController
@property(nonatomic,copy)NSString *funType;
@property(nonatomic,copy)void(^backBlock)(ClassifyModel *model);
@end
