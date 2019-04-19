//
//  RoomTypeViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomTypeModel.h"
#import "deliveryModel.h"
#import "FloorModel.h"
@interface RoomTypeViewController : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *nameLab;
@property(nonatomic,weak)IBOutlet UIButton *finishBtn;
@property(nonatomic,weak)IBOutlet UITextField *TypeName;

@property(nonatomic,weak)IBOutlet UITextField *FloorArea;

@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,copy)NSString *floorItnoString;

@property(nonatomic,retain)RoomTypeModel *RTypeModel;
@property(nonatomic,retain)deliveryModel *deliModel;

@property(nonatomic)NSInteger numberOfTag;
@property(nonatomic,copy)NSString *floorItNoStr;

@property(nonatomic,strong)UITableView *areaTable;

@property(nonatomic,strong)NSMutableArray *AreaArray;

//@property(nonatomic,strong)UITextField *areaField;

@end
