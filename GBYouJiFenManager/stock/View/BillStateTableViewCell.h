//
//  BillStateTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBillModel.h"
@interface BillStateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *billNoLable;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UILabel *payModel;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonView_Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button1_wideth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button2_wideth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button3_wideth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *button4_wideth;
@property(nonatomic,copy)void(^touBlock)(NSInteger);
-(void)setDataWithMode:(ADBillModel*)model;
@end
