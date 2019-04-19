//
//  seatDetailTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seatDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIButton *ewmButton;
@property(nonatomic,copy)void (^codeBlock)();
-(void)initLabelWithArray:(NSArray*)array;
@end
