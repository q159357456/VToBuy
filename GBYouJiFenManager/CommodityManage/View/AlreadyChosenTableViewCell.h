//
//  AlreadyChosenTableViewCell.h
//  GBManagement
//
//  Created by 工博计算机 on 16/12/1.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPModel.h"
@interface AlreadyChosenTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Dheight;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *contLable;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *detailLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property(nonatomic,copy)void(^tuicaiBlock)();
-(void)setDataWithModel:(SBPModel*)model;
@end
