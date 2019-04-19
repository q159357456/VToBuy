//
//  trreeTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface trreeTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *selectedButton;

@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UILabel *namelable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leding;
@property(nonatomic,copy)void(^selectedBlock)();
@end
