//
//  AreaSetView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorModel.h"
@interface AreaSetView : UIView
@property (strong, nonatomic) IBOutlet UITextField *areaName;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)FloorModel *floorModel;
@property (nonatomic,copy)void(^backBlock)();
@property (nonatomic,copy)void(^tastBlock)(NSString*);
@property (strong, nonatomic) IBOutlet UILabel *lNameable;
@property(nonatomic,copy)NSString *funType;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@end
