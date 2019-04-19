//
//  discountTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "discountModel.h"
@interface discountTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet  UILabel *selectLab;

@property(nonatomic,strong)UILabel *lab1;
@property(nonatomic,strong)UILabel *lab2;
@property(nonatomic,strong)UILabel *lab3;
@property(nonatomic,strong)UILabel *lab4;
@property(nonatomic,strong)UILabel *lab5;

-(void)setDataWithModel:(discountModel *)model;

@end
