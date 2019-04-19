//
//  ThirdTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *phoneNu;
@property(nonatomic,copy)void(^backBlock)(NSInteger);
@end
