//
//  DownOrderTableViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INV_ProductModel.h"
@interface DownOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UIButton *pluseButton;
@property (strong, nonatomic) IBOutlet UIButton *minceButton;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
@property (strong, nonatomic) IBOutlet UIButton *TastButton;
@property(nonatomic,copy)void(^pluseBlock)(UIImageView *headImage,UIButton *);
@property(nonatomic,copy)void(^minceBlock)();
@property(nonatomic,copy)void(^chooseBlock)(NSString *str);
@property(nonatomic,assign)NSInteger style;
-(void)setDataWithModel:(INV_ProductModel*)model;
@end
