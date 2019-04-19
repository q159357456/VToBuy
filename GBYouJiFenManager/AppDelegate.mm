//
//  AppDelegate.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AppDelegate.h"
#import "GBTabBarViewController.h"
#import "LoginViewController.h"
#import "FMDBMember.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BMKMapComponent.h"
#import ""

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "AVLanguage.h"
#import "VesionManager.h"
#import "VersionManagerVC.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    BMKMapManager* _mapManager;
}
@end
@implementation AppDelegate
-(void)addNetStatueNotic
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                [[NSNotificationCenter defaultCenter]postNotificationName:StatusNotReachable object:nil userInfo:nil];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                [[NSNotificationCenter defaultCenter]postNotificationName:StatusReachableViaWiFi object:nil userInfo:nil];
//                VesionManager *manager=[[VesionManager alloc]init];
//                [manager getAppSoteVison];
                break;
            }

            case AFNetworkReachabilityStatusReachableViaWWAN:{
                 [[NSNotificationCenter defaultCenter]postNotificationName:StatusReachableViaWWAN object:nil userInfo:nil];
//              VesionManager *manager=[[VesionManager alloc]init];
//                [manager getAppSoteVison];
                break;
            }
            default:
                break;
        }


    }];

    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}

/**
检测app版本判断强制更新
 */
-(void)addNotice
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noupdate) name:Noupdate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forceupdate) name:Forceupdate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(waiteupdate) name:Waiteupdate object:nil];
}
-(void)noupdate
{
    NSLog(@"--版本可用--");
}
-(void)forceupdate
{
    VersionManagerVC *vc=[[VersionManagerVC alloc]init];
    vc.index=1;
    self.window.rootViewController = vc;
    
}
-(void)waiteupdate
{
    VersionManagerVC *vc=[[VersionManagerVC alloc]init];
    vc.index=2;
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addNetStatueNotic];
//    [self addNotice];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[FMDBMember shareInstance]getMemberData].count>0)
    {
        GBTabBarViewController *GBTabVC = [[GBTabBarViewController alloc] init];
              self.window.rootViewController = GBTabVC;
    }else
    {
        
        self.window.rootViewController = [LoginViewController alloc];
    }
    [self.window makeKeyAndVisible];
 
    //向微信注册 wxc3634aeb0c228038
    [WXApi registerApp:WX_AppID enableMTA:YES];
    //注册百度地图
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if (BMKMapManager setc) {
        <#statements#>
    }
    
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:@"wDxITFfWRTVAqR1FuQTWrE4yHG110wbl" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    /*极光推送*/
    //添加初始化APNs代码
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //添加初始化JPush代码
    [JPUSHService setupWithOption:launchOptions appKey:PUSHAPPKEY
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

    return YES;
   
}
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册APNs成功");
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"1-------willPresentNotification");
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"1推送消息---%@",userInfo);
    NSLog(@"%@",userInfo[@"aps"][@"alert"]);
    AVLanguage *vo=[[AVLanguage alloc]init];
    [vo startVoiceWithStr:userInfo[@"aps"][@"alert"]];
    //通知中心
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendBillSuccess" object:nil userInfo:nil];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"2-------didReceiveNotificationResponse");
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
          NSLog(@"2推送消息---%@",userInfo);
    //userInfo {
    //    "_j_business" = 1;
    //    "_j_msgid" = 284706290;
    //    "_j_uid" = 9206836647;
    //    aps =     {
    //        alert = hjjiuybbhjjiii;
    //        badge = 1;
    //        sound = default;
    //    };
    //}
  
    //点击通知调用
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"3-------didReceiveRemoteNotification");
    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"4-------didReceiveRemoteNotification");
    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"---%@",url);
    //支付宝返回
    if ([url.host isEqualToString:@"safepay"]) {
        /*
         9000 订单支付成功
         8000 正在处理中
         4000 订单支付失败
         6001 用户中途取消
         6002 网络连接出错
         */
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
                //支付成功
                NSLog(@"--支付成功");
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"stockPaySucesce" object:nil userInfo:nil];
                
            }else if([resultDic[@"resultStatus"]isEqualToString:@"6001"]) {
                //用户中途取消
                NSLog(@"--取消支付");
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                
                [SVProgressHUD showErrorWithStatus:@"取消支付"];
                
            }else if([resultDic[@"resultStatus"]isEqualToString:@"4000"]) {
                //订单支付失败
                NSLog(@"--支付失败");
                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                
                
            }else if([resultDic[@"resultStatus"]isEqualToString:@"6002"]) {
                //网络连接出错
                NSLog(@"--网络出错");
                [SVProgressHUD showErrorWithStatus:@"网络出错"];
                
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }
    //微信返回
    NSLog(@"url absoluteString--%@",[url absoluteString]);
    if([[url absoluteString] rangeOfString:@"wxc3634aeb0c228038://pay"].location == 0)
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
      return YES;
}
#pragma wxapidelegate
-(void)onReq:(BaseReq *)req
{
    NSLog(@"什么东西");
}
//微信回调
-(void)onResp:(BaseResp *)resp
{
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功");
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"stockPaySucesce" object:nil userInfo:nil];
                
                
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                NSLog(@"支付失败");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSLog(@"取消支付");
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showErrorWithStatus:@"取消支付"];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                [SVProgressHUD showErrorWithStatus:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                [SVProgressHUD showErrorWithStatus:@"授权失败"];
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
