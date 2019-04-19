//
//  CoverView.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverView : UIView

@property(nonatomic,copy)void(^click)();
@property(nonatomic,assign)BOOL isClick;
@end
