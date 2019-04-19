//
//  SetBusinessDateView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SetBusinessDateView.h"
@interface SetBusinessDateView()
@end
@implementation SetBusinessDateView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (IBAction)done:(UIButton *)sender {
    self.doneBlock(self.textfield.text);
}
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self=[super initWithFrame:frame];
//        if (self) {
//    
//        }
//        return self;
//    
//}

@end
