//
//  CoverView.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
