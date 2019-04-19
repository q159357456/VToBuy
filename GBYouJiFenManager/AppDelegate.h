//
//  AppDelegate.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarDelegate,WXApiDelegate,BMKGeneralDelegate>
@property (strong, nonatomic) UIWindow *window;


@end

