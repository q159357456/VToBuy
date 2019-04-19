//
//  AddDetailTwoTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDetailTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *choseSegMent;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Twidth;
@property(nonatomic,copy)void(^statuseBlock)(NSString *str);
@end
