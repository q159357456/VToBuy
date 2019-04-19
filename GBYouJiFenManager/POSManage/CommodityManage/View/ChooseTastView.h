//
//  ChooseTastView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/1.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INV_ProductModel.h"
#import "POSDCModel.h"
#import "POSDIModel.h"
@interface ChooseTastView : UIView
@property(nonatomic,copy)void(^addShopCarBlock)(NSMutableArray *array);
-(instancetype)initWithFrame:(CGRect)frame Model:(INV_ProductModel*)model;
@end
