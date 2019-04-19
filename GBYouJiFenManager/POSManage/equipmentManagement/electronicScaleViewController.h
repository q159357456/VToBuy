//
//  electronicScaleViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleModel.h"
@interface electronicScaleViewController : UIViewController
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,retain)ScaleModel *SModel;

@end
