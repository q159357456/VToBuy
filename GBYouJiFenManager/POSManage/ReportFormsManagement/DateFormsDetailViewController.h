
//  DateFormsDetailViewController.h
//  GBYouJiFenManager

//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.

#import <UIKit/UIKit.h>
#import "DateFormsModel.h"
@interface DateFormsDetailViewController : UIViewController

@property(nonatomic,strong)UIScrollView *ReportScrollView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,retain)DateFormsModel *dModel;

@end
