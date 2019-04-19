//
//  ChooseView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorModel.h"
@interface ChooseView : UIView
@property (strong, nonatomic) IBOutlet UITableView *tableiew;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic,copy)void(^backBlock)(FloorModel*);
@end
