//
//  ProcurChildViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCViewController.h"
@interface ProcurChildViewController : CCViewController
@property(nonatomic,copy)NSString *classiNo;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)NSInteger flag;
@end
