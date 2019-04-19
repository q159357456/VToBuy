//
//  FloorTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloorModel.h"
#import "RoomTypeModel.h"
#import "deliveryModel.h"
@interface FloorTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *selectLab;
//@property(nonatomic,weak)IBOutlet UILabel *floorLab;

//@property(nonatomic,strong)UILabel *selectLab;
@property(nonatomic,strong)UILabel *floorLab;
-(void)setDataWithModel:(FloorModel*)model;

-(void)setDataWithModel1:(RoomTypeModel*)model;

-(void)setDataWithModel2:(deliveryModel *)model;
@end
