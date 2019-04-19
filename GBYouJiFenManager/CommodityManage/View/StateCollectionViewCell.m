//
//  StateCollectionViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StateCollectionViewCell.h"

@implementation StateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)setDataWithModel:(SeatSatueModel*)model
{
    self.stateImage.backgroundColor=[ColorTool colorWithHexString:model.SS007];
    self.stateLable.text=model.SS002;
    if (model.isSlected)
    {
        self.stateImage.image=[UIImage imageNamed:@"seatState"];
    }else
    {
        self.stateImage.image=nil;
    }
}
@end
