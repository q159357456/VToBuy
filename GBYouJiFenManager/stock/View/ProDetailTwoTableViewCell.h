//
//  ProDetailTwoTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADShopInfoModel.h"
@interface ProDetailTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *shopImage;
@property (strong, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic) IBOutlet UILabel *adressLable;
@property (strong, nonatomic) IBOutlet UIButton *butt;
-(void)setDataWithModel:(ADShopInfoModel*)model;
@end
