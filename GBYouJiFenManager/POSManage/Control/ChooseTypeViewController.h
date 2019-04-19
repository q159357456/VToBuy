//
//  ChooseTypeViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.


#import <UIKit/UIKit.h>
#import "FloorModel.h"
#import "RoomTypeModel.h"
#import "TasteKindModel.h"
#import "discountClassifyModel.h"
#import "roomDataModel.h"
@interface ChooseTypeViewController : UIViewController
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *HeadView;
@property(nonatomic)NSInteger tagNumber;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,strong)UIButton *sureBtn;


@property(nonatomic,strong)NSMutableArray *floorArray;


@property(nonatomic,retain)RoomTypeModel *tModel;
@property(nonatomic,copy)void(^backBlock)(RoomTypeModel *RTModel);


@property(nonatomic,retain)FloorModel *FModel;
@property(nonatomic,copy)void(^backBlock1)(FloorModel *flModel);

@property(nonatomic,retain)TasteKindModel *kModel;
@property(nonatomic,copy)void(^backBlock2)(TasteKindModel *kindModel);

@property(nonatomic,retain)discountClassifyModel *dcModel;
@property(nonatomic,copy)void(^backBlock3)(discountClassifyModel *DCModel);

@property(nonatomic,retain)roomDataModel *RDModel;
@property(nonatomic,copy)void(^backBlock4)(roomDataModel *rdModel);

@property(nonatomic,copy)NSString *floorStr;
@end
