//
//  FloorViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorModel.h"
#import "RoomTypeModel.h"
#import "deliveryModel.h"
@interface FloorViewController : UIViewController
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic)NSInteger tagNum;

@property(nonatomic,retain)FloorModel *fModel;
@property(nonatomic,retain)RoomTypeModel *RTModel;
@property(nonatomic,retain)deliveryModel *dModel;
@end
