//
//  ZWHShareCollectionViewCell.m
//  ZHONGHUILAOWU
//
//  Created by Syrena on 2018/11/26.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "ZWHShareCollectionViewCell.h"

@implementation ZWHShareCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = WIDTH_PRO(15);
        //self.layer.masksToBounds = YES;
        
        self.layer.shadowColor = [UIColor qmui_colorWithHexString:@"#e9e9e9"].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(6,6);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 1;//阴影透明度，默认0
        //self.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return self;
}

-(void)setUI{
    _backimg = [[UIImageView alloc]init];
    
    
    
    [self.contentView addSubview:_backimg];
    [_backimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [_backimg layoutIfNeeded];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backimg.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(WIDTH_PRO(15), WIDTH_PRO(15))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _backimg.bounds;
    maskLayer.path = maskPath.CGPath;
    _backimg.layer.mask = maskLayer;
    
    _QRimg = [[UIImageView alloc]init];
    [self.contentView addSubview:_QRimg];
    [_QRimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_PRO(80));
        make.width.height.mas_equalTo(HEIGHT_PRO(110));
        //make.right.equalTo(self.contentView.mas_centerX).offset(-WIDTH_PRO(6));
        make.centerX.equalTo(self.contentView);
    }];
    
    
    
//    //添加长按手势
//    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//
//    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
//    _QRimg.userInteractionEnabled = YES;
//    [_QRimg addGestureRecognizer:longPressGesture];
    
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnImg:)])
        {
            // 调用代理方法
            [self.delegate returnImg:[UIImage qmui_imageWithView:self.contentView]];
        }
        
    }
    
}


@end
