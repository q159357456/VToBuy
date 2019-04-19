//
//  RoomStateViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "roomDataModel.h"
@interface RoomStateViewController : UIViewController
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;

@property(nonatomic,weak)IBOutlet UITextField *RoomName;
@property(nonatomic,weak)IBOutlet UITextField *RoomType;
@property(nonatomic,weak)IBOutlet UITextField *FloorArea;

@property(nonatomic,weak)IBOutlet UISegmentedControl *ValidSegment;
@property(nonatomic,weak)IBOutlet UISegmentedControl *BookSegment;
@property(nonatomic,copy)NSString *string1;
@property(nonatomic,copy)NSString *string2;


@property(nonatomic,copy)NSString *roomTypeStr;
@property(nonatomic,copy)NSString *floorAreaStr;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,retain)roomDataModel *RoomDModel;



@property(nonatomic,copy)void(^validateBlock)(NSString *str);
@property(nonatomic,copy)void(^bookBlock)(NSString *str);


@end
