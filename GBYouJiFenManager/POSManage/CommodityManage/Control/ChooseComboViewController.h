//
//  ChooseComboViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface ChooseComboViewController : UIViewController
@property(nonatomic,copy)NSString  *productNo;
@property(nonatomic,copy)void(^backBlock)(NSMutableArray *dataArray);
@end
