//
//  FlowDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/20.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface FlowDetailViewController : UIViewController
@property(nonatomic,retain)ProductModel *model;
@property(nonatomic,copy)void(^backBlock)();
@end
