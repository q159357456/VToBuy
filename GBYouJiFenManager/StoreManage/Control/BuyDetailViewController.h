//
//  BuyDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayRecordModel.h"
@interface BuyDetailViewController : UIViewController
@property(nonatomic,strong)PayRecordModel *pmodel;
@property(nonatomic,copy)void(^backBlock)();
@end
