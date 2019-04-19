//
//  FirstTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADShopInfoModel.h"
@interface FirstTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *titleImage;
@property (strong, nonatomic) IBOutlet UILabel *shopLable;
@property (strong, nonatomic) IBOutlet UILabel *distanceLable;
@property (strong, nonatomic) IBOutlet UILabel *adreeLable;
-(void)setDataWithModel:(ADShopInfoModel*)model;
@end
