//
//  StateCollectionViewCell.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatSatueModel.h"
@interface StateCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *stateImage;
@property (strong, nonatomic) IBOutlet UILabel *stateLable;
-(void)setDataWithModel:(SeatSatueModel*)model;
@end
