//
//  AddDetailTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UITextField *inputText;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (strong, nonatomic) IBOutlet UIView *seprateView;

@end
