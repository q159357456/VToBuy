//
//  ReserveDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatModel.h"
#import "STSModel.h"
@interface ReserveDetailViewController : UIViewController
@property(nonatomic,strong)SeatModel *model;
@property(nonatomic,copy)NSString *timeStr;
@property(nonatomic,strong)STSModel *tmoel;
@end
