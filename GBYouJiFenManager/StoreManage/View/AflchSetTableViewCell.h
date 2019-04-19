//
//  AflchSetTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AflchSetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deletButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property(nonatomic,copy)void(^deleteBlock)();
@property(nonatomic,copy)void(^editBlock)();
@end
