//
//  ScanningQRCodeView.h
//  Restaurant
//
//  Created by 张帆 on 16/11/4.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanningQRCodeView : UIView
- (instancetype)initWithFrame:(CGRect)frame outsideViewLayer:(CALayer *)outsideViewLayer withScanType:(NSString *)type WithSuperViewController:(UIViewController *)superVC;

+ (instancetype)scanningQRCodeViewWithFrame:(CGRect )frame outsideViewLayer:(CALayer *)outsideViewLayer withScanType:(NSString *)type WithSuperViewController:(UIViewController *)superVC;

/** 移除定时器(切记：一定要在Controller视图消失的时候，停止定时器) */
- (void)removeTimer;

@end
