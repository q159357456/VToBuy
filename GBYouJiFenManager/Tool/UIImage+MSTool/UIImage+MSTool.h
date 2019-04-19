//
//  UIImage+MSTool.h
//  屏幕截图
//
//  Created by MaShuai on 16/5/6.
//  Copyright © 2016年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MSTool)

/**
 *  获取视图截屏
 *
 *  @param view 被截屏的视图
 *
 *  @return 截屏图片
 */
+ (instancetype)imageWithCaptureView:(UIView *)view;

/**
 *  获取圆形带边框的图片
 *
 *  @param imageName   图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 圆形带边框的图片
 */
+ (instancetype)headerWithImageName:(NSString *)imageName andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor;

@end




