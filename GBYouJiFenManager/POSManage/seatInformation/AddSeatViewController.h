//
//  AddSeatViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "roomDataModel.h"
@interface AddSeatViewController : UIViewController
@property(nonatomic,strong)roomDataModel *seatModel;
@property(nonatomic,copy)void(^backBlock)();
@end
