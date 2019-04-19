//
//  MobileSecondTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/5.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternalRegisterModel.h"
#import "PCRegisyerModel.h"
#import "scheduleModel.h"
#import "TasteKindModel.h"
#import "TasteRequestModel.h"

#import "FMDBMember.h"
#import "MemberModel.h"
#import "TasteClassifyModel.h"
#import "RolePemissionModel.h"
#import "ScaleModel.h"
@interface MobileSecondTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *selectLab;
//@property(nonatomic,weak)IBOutlet UILabel *number;
//@property(nonatomic,weak)IBOutlet UILabel *name;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;

@property(nonatomic,copy)TasteClassifyModel *TCModel;

@property(nonatomic,strong)UILabel *number;
@property(nonatomic,strong)UILabel *name;
//-(void)setDataWithModel:(InternalRegisterModel*)model;
-(void)setDataWithModel1:(PCRegisyerModel *)model;
-(void)setDataWithModel4:(scheduleModel *)model;
-(void)setDataWithModel2:(TasteKindModel *)model;
-(void)setDataWithModel3:(TasteRequestModel *)model;
-(void)setDataWithModel5:(RolePemissionModel *)model;
-(void)setDataWithModel6:(ScaleModel *)model;

@end
