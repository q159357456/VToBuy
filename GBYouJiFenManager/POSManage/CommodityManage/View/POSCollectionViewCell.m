//
//  POSCollectionViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "POSCollectionViewCell.h"

@implementation POSCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setNameTop:(NSLayoutConstraint *)nameTop
{
    _nameTop=nameTop;
     if (screen_width==320) {
         self.nameTop.constant=1;
     }
    
}

@end
