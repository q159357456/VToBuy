//
//  AddressTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic,copy)void(^deleteBlock)();
@property(nonatomic,copy)void(^editBlock)();
@property(nonatomic,copy)void(^setDefaultBlock)();

@end
