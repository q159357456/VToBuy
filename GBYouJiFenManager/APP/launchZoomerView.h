//
//  launchZoomerView.h
//  Restaurant
//
//  Created by 张帆 on 16/9/26.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface launchZoomerView : UIView
+ (instancetype)addToView:(UIView *)view withImage:(UIImage *)image backgroundColor:(UIColor *)backgroundColor;

- (void)startAnimation;
@end
