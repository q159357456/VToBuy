//
//  BusinessAreaViewController.h
//  GBYouJiFenManager
//
//  Created by chenheng on 2019/4/17.
//  Copyright © 2019年 张卫煌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessAreaViewController : UIViewController
@property(nonatomic,copy)NSString *boroCode;
@property(nonatomic,copy)void(^callBack)(NSString *circleName,NSString* circleCode);
@end

NS_ASSUME_NONNULL_END
