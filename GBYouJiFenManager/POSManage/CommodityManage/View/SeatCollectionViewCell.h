//
//  SeatCollectionViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatModel.h"
@interface SeatCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property(nonatomic,strong)SeatModel *model;
-(void)setDataWithModel:(SeatModel*)model;
@end
