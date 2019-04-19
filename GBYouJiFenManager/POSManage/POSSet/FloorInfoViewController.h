//
//  FloorInfoViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorModel.h"
#import "deliveryModel.h"

@interface FloorInfoViewController : UIViewController
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;

@property(nonatomic,weak)IBOutlet UITextField *FInfo;

@property(nonatomic,weak)IBOutlet UILabel *nameLabel;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();



@property(nonatomic,retain)FloorModel *FLModel;
@property(nonatomic,retain)deliveryModel *deliModel;

@property(nonatomic)NSInteger numberOfTag;


@end
