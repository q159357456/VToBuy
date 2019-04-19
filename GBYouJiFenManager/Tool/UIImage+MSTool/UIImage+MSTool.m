//
//  UIImage+MSTool.m
//  屏幕截图
//
//  Created by MaShuai on 16/5/6.
//  Copyright © 2016年 司马帅帅. All rights reserved.
//

#import "UIImage+MSTool.h"

@implementation UIImage (MSTool)

+ (instancetype)imageWithCaptureView:(UIView *)view
{
    //开启图片上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    //获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //将self.view渲染到上下文ctx中
    [view.layer renderInContext:ctx];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)headerWithImageName:(NSString *)imageName andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor
{
    //原始图片
    UIImage *originalImage = [UIImage imageNamed:imageName];
    
    CGFloat imageWidth = originalImage.size.width;
    CGFloat imageHeight = originalImage.size.height;
    //获取图片的宽度
    CGFloat pictureWidth = imageHeight>imageWidth?imageWidth:imageHeight;
    //获取上下文的宽度
    CGFloat ctxWidth = pictureWidth+borderWidth*2;
    
    
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ctxWidth, ctxWidth), NO, 0.0);
    
    //获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ctxWidth, ctxWidth)];
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    //设置边框颜色
    [borderColor setFill];
    
    //渲染
    CGContextFillPath(ctx);
    
    //添加图片
    //图片的路径
    UIBezierPath *picturePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, pictureWidth, pictureWidth)];
    //将图片路径添加到上下文中
    CGContextAddPath(ctx, picturePath.CGPath);
    //图片路径裁剪
    [picturePath addClip];
    //画图
    [originalImage drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    //获取图片上下文中的图片
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
