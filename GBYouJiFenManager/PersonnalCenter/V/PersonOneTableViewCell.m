//
//  PersonOneTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/11.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PersonOneTableViewCell.h"

@implementation PersonOneTableViewCell

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

-(void)setXianjinLable:(UILabel *)xianjinLable
{
//    _xianjinLable=xianjinLable;
//    _xianjinLable.backgroundColor=[ColorTool colorWithHexString:@"#14577b"];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
