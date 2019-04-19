//
//  ShopCarTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INV_ProductModel.h"
@interface ShopCarTableViewCell : UITableViewCell
@property(nonatomic,copy)void(^addBlock)();
@property(nonatomic,copy)void(^minceBlock)();
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
-(void)setDataWithModel:(INV_ProductModel*)model;
@end
