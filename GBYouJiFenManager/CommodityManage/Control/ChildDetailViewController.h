//
//  ChildDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "GroupModel.h"
@interface ChildDetailViewController : UIViewController
@property(nonatomic,strong)ProductModel *model;
@property(nonatomic,strong)GroupModel *groupModel;

@end