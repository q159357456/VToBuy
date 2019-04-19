//
//  AddComboViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface AddComboViewController : UIViewController
@property(nonatomic,retain)ProductModel *model;
@property(nonatomic,copy)void(^backBlock)();
@end
