//
//  SeatCollectionViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SeatCollectionViewCell.h"

@implementation SeatCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataWithModel:(SeatModel *)model
{
    if (model.isSelet) {
        
        
        self.contentView.layer.borderWidth=4;
          self.contentView.layer.borderColor=[UIColor redColor].CGColor;
    }else
    {
        self.contentView.layer.borderWidth=2;
          self.contentView.layer.borderColor=[ColorTool colorWithHexString:model.SS007].CGColor;
    }
//    @property(nonatomic,copy)NSString *SI003;
//    
//    /**
//     区域楼层编号
//     */
//    @property(nonatomic,copy)NSString *SI004;
    NSLog(@"%@",model.SI003);
     NSLog(@"%@",model.SI004);
    self.lable1.backgroundColor=[ColorTool colorWithHexString:model.SS007];
    self.lable1.text=model.UDF07;
    self.lable2.text=model.SI002;
    self.lable3.text=model.SI001;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
        self.contentView.layer.borderWidth=2;
        self.contentView.layer.cornerRadius=2;
        self.contentView.layer.masksToBounds=YES;
    }
    return self;
}
@end
