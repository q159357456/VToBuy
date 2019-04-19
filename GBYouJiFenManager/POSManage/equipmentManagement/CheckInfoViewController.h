
//  CheckInfoViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.


#import <UIKit/UIKit.h>
#import "PCRegisyerModel.h"
#import "FloorModel.h"
@interface CheckInfoViewController : UIViewController
@property(weak,nonatomic)IBOutlet UITextField *PCMAC;
@property(weak,nonatomic)IBOutlet UITextField *PCName;
@property(weak,nonatomic)IBOutlet UITextField *PCArea;
@property(weak,nonatomic)IBOutlet UIButton *finishBtn;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)void(^backBlock)();

@property(nonatomic,strong)UITableView *areaTable;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,copy)NSString *areaCode;
@property(nonatomic,copy)NSString *floorItnoString;

@property(nonatomic,retain)PCRegisyerModel *PCModel;
@end
