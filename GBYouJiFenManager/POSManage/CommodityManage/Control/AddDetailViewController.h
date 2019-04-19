//
//  AddDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"
@interface AddDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,copy)void(^backBlock)();
@property(nonatomic,strong)ClassifyModel *clssiModel;
@property(nonatomic,copy)NSString *funType;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end
