//
//  launchZoomerView.m
//  Restaurant
//
//  Created by 张帆 on 16/9/26.
//  Copyright © 2016年 工博计算机. All rights reserved.

#import "launchZoomerView.h"

@interface launchZoomerView ()
@property (weak, nonatomic) UIView *view;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation launchZoomerView


+ (instancetype)addToView:(UIView *)view withImage:(UIImage *)image backgroundColor:(UIColor *)backgroundColor {
    launchZoomerView *zoomer = [[launchZoomerView alloc] initWithFrame:view.frame];
    zoomer.view = view;
    zoomer.imageView = [[UIImageView alloc] initWithImage:image];
    zoomer.imageView.frame = CGRectMake(0, 0, 160, 170);
    zoomer.imageView.center = view.center;
    zoomer.backgroundColor = backgroundColor;
    [zoomer addSubview:zoomer.imageView];
    [view addSubview:zoomer];
    return zoomer;
}

- (void)startAnimation {
    [self zoomOut];
}

- (void)zoomOut {
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake(0, 0, 60, 60);
        self.imageView.center = self.view.center;
    } completion:^(BOOL finished) {
        [self zoomIn];
    }];
}

- (void)zoomIn {
    [UIView animateWithDuration:0.4 animations:^{
        self.imageView.frame = CGRectMake(0, 0, 4000, 4000);
        self.imageView.center = self.view.center;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self animationFinished];
    }];
}

- (void)animationFinished {
    [self removeFromSuperview];
}

@end
