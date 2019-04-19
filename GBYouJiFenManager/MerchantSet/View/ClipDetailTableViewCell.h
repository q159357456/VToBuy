//
//  ClipDetailTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *satteLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;

@end
