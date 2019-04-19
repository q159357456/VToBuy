//
//  AddressChooseTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddressChooseTableViewCell.h"

@implementation AddressChooseTableViewCell

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

//-(void)setFrame:(CGRect)frame
//{
//    frame.origin.x = 5;
//    frame.size.width -= 2*frame.origin.x;
//    frame.size.height -= 2*frame.origin.x;
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 8.0;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [super setFrame:frame];
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
