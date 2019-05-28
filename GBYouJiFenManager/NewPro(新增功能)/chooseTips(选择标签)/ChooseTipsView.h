//
//  ChooseTipsView.h
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/5/27.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TipsModel;
@interface ChooseTipsView : UIView
+(void)startChooseTipsCallBack:(void(^)(NSString * values))callback;
@end

@interface TipsModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
