//
//  TimeTableViewCell.m
//  Restaurant
//
//  Created by 张帆 on 16/11/2.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "TimeTableViewCell.h"


@implementation TimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)loadDataWithModel:(seatTimeModel *)model
{
    self.timeLabel.text=model.pretime;
    
    [self.stateBtn setTitle:model.msg forState:UIControlStateNormal];
    [self.stateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.stateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.stateBtn.layer.cornerRadius=10;
    self.stateBtn.layer.borderWidth=1;

    self.stateBtn.layer.masksToBounds=YES;
    if ([model.preok isEqualToString:@"True"]) {
        self.stateBtn.enabled=NO;
        self.stateBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }else
    {
        self.stateBtn.enabled=YES;
        self.stateBtn.layer.borderColor=[UIColor redColor].CGColor;

    }
   
}
- (IBAction)stateBtnClick:(id)sender {
    
    self.writeSeatInfoBlock();
}

@end
