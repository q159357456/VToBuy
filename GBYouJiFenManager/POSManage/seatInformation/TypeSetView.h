//
//  TypeSetView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomTypeModel.h"
#import "ClassifyModel.h"
@interface TypeSetView : UIView
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property(nonatomic,strong)RoomTypeModel *roomModel;
@property(nonatomic,copy)NSString *floorName;
@property(nonatomic,copy)NSString *floorNo;
@property (nonatomic,copy)void(^backBlock)();
@property (nonatomic,copy)void(^combBlock)(ClassifyModel*,NSString*);
@property(nonatomic,copy)NSString *funType;
@end
