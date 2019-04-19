//
//  AddDetailTwoTableViewCell.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddDetailTwoTableViewCell.h"

@implementation AddDetailTwoTableViewCell

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
-(void)setChoseSegMent:(UISegmentedControl *)choseSegMent
{
    
    _choseSegMent=choseSegMent;
//     self.statuseBlock(@"true");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choseSeg:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
    case 0:
        {
        
            self.statuseBlock(@"true");
            
        }
        break;
    case 1:
        {
        
            self.statuseBlock(@"false");
          
        }
        break;
        
        
        
    }

}

@end
