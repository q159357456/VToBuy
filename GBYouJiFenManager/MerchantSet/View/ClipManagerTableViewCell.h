//
//  ClipManagerTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipManagerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
@property (strong, nonatomic) IBOutlet UIImageView *titleImage;
@property (strong, nonatomic) IBOutlet UIImageView *statuImage;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
