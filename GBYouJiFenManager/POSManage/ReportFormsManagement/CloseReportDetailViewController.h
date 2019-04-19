//
//  CloseReportDetailViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseReportModel.h"
#import "FloorModel.h"
@interface CloseReportDetailViewController : UIViewController
@property(nonatomic,strong)UIScrollView *ReportScrollView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,retain)CloseReportModel *cModel;

@property(nonatomic,strong)NSMutableArray *CArr;


@end
