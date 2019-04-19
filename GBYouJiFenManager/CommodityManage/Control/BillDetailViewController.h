//
//  BillDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatModel.h"
#import "ADBillModel.h"
@interface BillDetailViewController : UIViewController
@property(nonatomic,retain)SeatModel *model;
@property(nonatomic,copy)NSString *dingDanNo;
/**
 如果是进货模式
 */
@property(nonatomic,strong)ADBillModel *billModel;
@end
