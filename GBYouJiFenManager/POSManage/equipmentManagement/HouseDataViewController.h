//
//  HouseDataViewController.h
//  GBYouJiFenManager

//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "roomDataModel.h"
#import "classesModel.h"
#import "RoomTypeModel.h"
#import "FloorModel.h"
#import "offspringPrintModel.h"
#import "rechargeModel.h"
#import "TasteClassifyModel.h"
#import "SettleBillModel.h"
#import "userAccountModel.h"
#import "QianTainRoleModel.h"
#import "MenuFunctionModel.h"
#import "InternalRegisterModel.h"
#import "InternalRegisterViewController.h"
@interface HouseDataViewController : UIViewController
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *dataBillArray;
@property(nonatomic,strong)UIView *headView;

@property(nonatomic)NSInteger tagNum;

@property(nonatomic,strong)NSMutableArray *roomTypeArray;
@property(nonatomic,strong)NSMutableArray *floorAreaArray;

@property(nonatomic,retain)roomDataModel *RDModel;
@property(nonatomic,retain)classesModel *cModel;
@property(nonatomic,retain)InternalRegisterModel *internalModel
;

@property(nonatomic,retain)offspringPrintModel *OffModel;
@property(nonatomic,retain)rechargeModel *ReModel;
@property(nonatomic,retain)SettleBillModel *SettleModel;
@property(nonatomic,retain)userAccountModel *QModel;

@property(nonatomic,strong)NSMutableArray *tasteBigClassArray;

@property(nonatomic,strong)NSMutableArray *roleArr;
@property(nonatomic,strong)NSMutableArray *allMenuArr;

@property(nonatomic,strong)NSMutableArray *roleRightArr;
@property(nonatomic,strong)NSMutableArray *MenuRightArr;


@property(nonatomic,strong)NSMutableArray *roomInfoArr;


@end
