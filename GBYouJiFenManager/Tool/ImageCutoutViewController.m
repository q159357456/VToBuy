//
//  ImageCutoutViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/1.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ImageCutoutViewController.h"
#import "YKCutView.h"
@interface ImageCutoutViewController ()<UIScrollViewDelegate>
{
     YKCutView *_cutView;
    CAShapeLayer *_fillLayer;
    CGFloat _startX;
    CGFloat _startY;
    CGFloat _endX;
    CGFloat _endY;
    int _moveCorner;
}
@property(nonatomic,strong)UIView *shadowView;
@end

@implementation ImageCutoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setImageView];
    // Do any additional setup after loading the view from its nib.
}
-(UIView *)shadowView
{
    if (!_shadowView) {
        if (!_shadowView) {
            _shadowView.hidden = NO;
            _shadowView.userInteractionEnabled = NO;
            _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64*2)];
        }

    }
     return _shadowView;
}
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(UIButton *)sender
{
    UIImage *newImage = [self screenView:self.view];
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0f);
    if (self.delegate) {
        [self.delegate getBackCutPhotos:data];
    }
    [self dismissToRootViewController];
}
-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
-(void)setImageView
{
    UIImageView *bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.cutImage.size.height * screen_width/ self.cutImage.size.width)];
    bigImage.center=CGPointMake(screen_width/2, screen_height/2);
    bigImage.image = self.cutImage;
    [self.view addSubview:bigImage];
    _cutView = [[YKCutView alloc] initWithFrame:CGRectMake(0, 0,screen_width, screen_width *23/36)];
    _cutView.emptyView.userInteractionEnabled = NO;
    _cutView.center = CGPointMake(screen_width / 2, screen_height  / 2);
    [self.view addSubview:_cutView];
    _fillLayer = [CAShapeLayer layer];
    _fillLayer.hidden = NO;
    [self.view.layer addSublayer:_fillLayer];
    // 添加裁剪区
    [self changeShadowWithFrame];
    
}

#pragma mark - 截取
- (UIImage*)screenView:(UIView *)view{
    CGRect rect = CGRectMake(0, 0, screen_width,screen_height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect newRect = CGRectMake(_cutView.frame.origin.x + 2 + 8, _cutView.frame.origin.y + 2 + 8, _cutView.frame.size.width - 4 - 16, _cutView.frame.size.height - 4 - 16);
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, newRect)];
}
- (void)changeShadowWithFrame
{
    //中间镂空的矩形框
    CGRect myRect = CGRectMake(_cutView.frame.origin.x , _cutView.frame.origin.y, _cutView.frame.size.width , _cutView.frame.size.height );
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 64,screen_width,screen_height - 64*2) cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    _fillLayer.path = path.CGPath;
    _fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    _fillLayer.fillColor = [UIColor blackColor].CGColor;
    _fillLayer.opacity = 0.75;
    [self.view bringSubviewToFront:_cutView];

}
// 触碰时的坐标,来判断是否是4个角
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    _moveCorner = [self judgeIsFourCornerTouch:touchPoint];
}
// 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat origenX = _cutView.frame.origin.x;
    CGFloat origenY = _cutView.frame.origin.y;
//    CGFloat origenW = _cutView.frame.size.width;
//    CGFloat origentH = _cutView.frame.size.height;
    if (_moveCorner==5) {
        //以前的point
        CGPoint preP = [touch previousLocationInView:self.view];
        //x轴偏移的量
        CGFloat offsetX = touchPoint.x - preP.x;
        //Y轴偏移的量
        CGFloat offsetY = touchPoint.y - preP.y;
        
        
        CGFloat finalX = origenX;
        CGFloat finalY = origenY;
        
        finalX = origenX + offsetX;
        finalY = origenY + offsetY;
        
        if (finalX < 0) {
            finalX = 0;
        }
        if (finalY < 64) {
            finalY = 64;
        }
        if (finalX > screen_width - _cutView.frame.size.width) {
            finalX = screen_width - _cutView.frame.size.width;
        }
        if (finalY > screen_height - 64- _cutView.frame.size.height) {
            finalY = screen_height- 64- _cutView.frame.size.height;
        }
        
        _cutView.frame = CGRectMake(finalX, finalY, _cutView.frame.size.width, _cutView.frame.size.height);
        //
        [self changeShadowWithFrame];

    }
    
}
// 判断是否位于四个角的触摸
- (int)judgeIsFourCornerTouch:(CGPoint)point
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if (x > [self getFirstCorner].x - 50 && x < [self getFirstCorner].x + 50 && y > [self getFirstCorner].y - 50 && y < [self getFirstCorner].y + 50) {
        return 1;
    } else if (x > [self getSecondCorner].x - 50 && x < [self getSecondCorner].x + 50 && y > [self getSecondCorner].y - 50 && y < [self getSecondCorner].y + 50) {
        return 2;
    } else if (x > [self getThirdCorner].x - 50 && x < [self getThirdCorner].x + 50 && y > [self getThirdCorner].y - 50 && y < [self getThirdCorner].y + 50) {
        return 3;
    } else if (x > [self getFourthCorner].x - 50 && x < [self getFourthCorner].x + 50 && y > [self getFourthCorner].y - 50 && y < [self getFourthCorner].y + 50) {
        return 4;
    } else if (x > [self getFirstCorner].x + 50 && y > [self getFirstCorner].y + 50 && x < [self getSecondCorner].x - 50 && y < [self getFourthCorner].y - 50) {
        return 5;
    };
    return 0;
}
- (CGPoint)getFirstCorner
{
    return CGPointMake(_cutView.frame.origin.x, _cutView.frame.origin.y);
}

- (CGPoint)getSecondCorner
{
    return CGPointMake(CGRectGetMaxX(_cutView.frame), CGRectGetMinY(_cutView.frame));
}

- (CGPoint)getThirdCorner
{
    return CGPointMake(CGRectGetMinX(_cutView.frame), CGRectGetMaxY(_cutView.frame));
}

- (CGPoint)getFourthCorner
{
    return CGPointMake(CGRectGetMaxX(_cutView.frame), CGRectGetMaxY(_cutView.frame));
}
//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
