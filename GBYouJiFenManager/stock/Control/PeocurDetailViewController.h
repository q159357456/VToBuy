//
//  PeocurDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "CCViewController.h"
@interface PeocurDetailViewController : CCViewController
@property(nonatomic,strong)ProductModel *proModel;
@property(nonatomic,assign)BOOL shop;
@end
