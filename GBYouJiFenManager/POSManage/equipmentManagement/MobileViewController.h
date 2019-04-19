//
//  MobileViewController.h
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
#import "RolePemissionModel.h"
#import "MenuFunctionModel.h"
#import "QianTainRoleModel.h"
#import "ScaleModel.h"
@interface MobileViewController : UIViewController
@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *tasteRequestArray;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic)NSInteger tagNum;

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSMutableArray *tasteClassArray;
@property(nonatomic,strong)NSMutableArray *tasteBigClassArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *RoleRightArr;
@property(nonatomic,strong)NSMutableArray *menuAllArr;
@property(nonatomic,strong)NSMutableArray *roleRightArr;


@property(nonatomic,retain)InternalRegisterModel *internalModel;
@property(nonatomic,retain)PCRegisyerModel *PCModel;
@property(nonatomic,retain)scheduleModel *scheduModel;
@property(nonatomic,retain)TasteKindModel *tasteModel;
@property(nonatomic,retain)TasteRequestModel *TRModel;
@property(nonatomic,retain)RolePemissionModel *roleModel;
@property(nonatomic,retain)ScaleModel *scaleModel;
@end
