//
//  ChooseTipsView.h
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/5/27.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseTipsView : UIView
+(void)startChooseTipsCallBack:(void(^)(NSString * values))callback;
@end

NS_ASSUME_NONNULL_END
