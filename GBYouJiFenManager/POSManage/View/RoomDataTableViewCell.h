//
//  RoomDataTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "roomDataModel.h"
#import "classesModel.h"
#import "offspringPrintModel.h"
#import "rechargeModel.h"
#import "SettleBillModel.h"
//#import "QianTaiModel.h"
#import "userAccountModel.h"
#import "InternalRegisterModel.h"
@interface RoomDataTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *selectLab;
//@property(nonatomic,weak)IBOutlet UILabel *RoomNameLab;
//@property(nonatomic,weak)IBOutlet UILabel *RoomTypeLab;
//@property(nonatomic,weak)IBOutlet UILabel *FloorAreaLab;

//@property(nonatomic,strong) UILabel *selectLab;
@property(nonatomic,strong) UILabel *RoomNameLab;
@property(nonatomic,strong) UILabel *RoomTypeLab;
@property(nonatomic,strong) UILabel *FloorAreaLab;


-(void)setDataWithModel:(roomDataModel*)model;
-(void)setDataWithModel1:(classesModel *)model;
-(void)setDataWithModel2:(offspringPrintModel*)model;
-(void)setDataWithModel3:(rechargeModel *)model;
-(void)setDataWithModel4:(SettleBillModel *)model;
-(void)setDataWithModel5:(userAccountModel *)model;
-(void)setDataWithModel6:(InternalRegisterModel *)model;

@end
