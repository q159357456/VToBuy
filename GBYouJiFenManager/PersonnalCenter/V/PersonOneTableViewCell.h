//
//  PersonOneTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/11.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonOneTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *scoreLable;
@property (strong, nonatomic) IBOutlet UILabel *crashLable;
@property (strong, nonatomic) IBOutlet UILabel *jifenLable;
@property (strong, nonatomic) IBOutlet UILabel *xianjinLable;
@property (strong, nonatomic) IBOutlet UIView *baGroundView;
@property (weak, nonatomic) IBOutlet UILabel *zwhxian;

@end
