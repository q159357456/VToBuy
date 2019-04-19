//
//  PersonTwoTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentlable;
@property(nonatomic,copy)void(^copyBlock)();
@end
