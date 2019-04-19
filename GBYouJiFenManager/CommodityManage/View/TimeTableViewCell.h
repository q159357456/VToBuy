//
//  TimeTableViewCell.h
//  Restaurant
//
//  Created by 张帆 on 16/11/2.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "seatTimeModel.h"

@interface TimeTableViewCell : UITableViewCell

//填写订座信息
@property (nonatomic,copy)  void(^writeSeatInfoBlock)();


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;


-(void)loadDataWithModel:(seatTimeModel*)model;
@end
