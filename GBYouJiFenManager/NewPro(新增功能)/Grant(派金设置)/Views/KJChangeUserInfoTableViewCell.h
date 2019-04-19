//
//  KJChangeUserInfoTableViewCell.h
//  XGB
//
//  Created by Yonger on 2017/8/25.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sureInputContent)(NSString * input);

@interface KJChangeUserInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString * leftTitleStr;//标题

@property(nonatomic,strong)NSString * rightTitleStr;//单位

// ***** 内容 *****//
@property(nonatomic,strong)QMUITextField * contentTex;
// ***** 显示右边的图片 *****//
-(void)showRightImage:(BOOL)show;

// ***** 标题和内容间距 *****//
@property(nonatomic,assign)float midDistance;

//是否定死标题宽度
@property(nonatomic,assign)BOOL isWidTitle;

@property(nonatomic,assign)NSInteger maxLenght;//-1为不限制
@property (nonatomic,strong)UIImageView * rightImage;
@property (nonatomic,strong)UIButton * rightbtn;

@property(nonatomic,strong)UILabel *leftLable;
@property(nonatomic,strong)UILabel *rightLable;
@property(nonatomic,strong)UIView *view;
//输入结束时
-(void)didEndInput:(sureInputContent)input;
@end
