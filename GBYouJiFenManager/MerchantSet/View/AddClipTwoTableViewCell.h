//
//  AddClipTwoTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClipTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *startData;
@property (strong, nonatomic) IBOutlet UITextField *endData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TWidth;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;

@end
