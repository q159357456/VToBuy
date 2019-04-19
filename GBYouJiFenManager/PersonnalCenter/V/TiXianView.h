//
//  TiXianView.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/29.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiXianView : UIView
@property(nonatomic,copy)void(^doneBlock)(NSInteger index);
@end
