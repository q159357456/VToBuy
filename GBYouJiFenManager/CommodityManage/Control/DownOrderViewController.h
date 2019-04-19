//
//  DownOrderViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatModel.h"
#import "ADShopInfoModel.h"
@interface DownOrderViewController : UIViewController
@property(nonatomic,strong)SeatModel *seatModel;
@property(nonatomic,copy)NSString *dingDanNo;
/**
 模式
 */
@property(nonatomic,copy)NSString *runModel;
/**
 人数
 */
@property(nonatomic,copy)NSString *count;
/**
 加菜
 */
@property(nonatomic,assign)BOOL isAdd;
/**
 如果是进货模式
  */
@property(nonatomic,strong)ADShopInfoModel *adModel;
@end
