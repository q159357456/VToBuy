//
//  GBNavigationViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.


#import "GBNavigationViewController.h"

@interface GBNavigationViewController ()

@end

@implementation GBNavigationViewController

+ (void)initialize {
    //设置bar背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:navigationBarColor];
    QMUICMI.navBarTintColor = [UIColor whiteColor];
    QMUICMI.navBarTitleFont = ZWHFont(13);
    QMUICMI.navBarTitleColor = [UIColor whiteColor];
    QMUICMI.navBarShadowImage = [UIImage qmui_imageWithColor:LINECOLOR];
    //设置文字样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    attrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    attrs[NSFontAttributeName] =[UIFont boldSystemFontOfSize:20];
    
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    //[navBar setTitleTextAttributes:attrs];
    //设置黑线
//    navBar.clipsToBounds=YES;
//    [navBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [navBar  setShadowImage:[[UIImage alloc] init]];
//    if (navBar.translucent)
//    {
//        navBar.subviews[0].subviews[1].hidden = YES;
//    }else
//    {
//        navBar.subviews[0].subviews[0].hidden = YES;
//        
//    }
//    
    
}
/*- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    
    
    if (self.viewControllers.count > 0) {//除了根视图控制器以外的所有控制，以压栈的方式push进来，就隐藏tabbar
        
        //导航栏返回手势
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
        
        
        viewController.navigationItem.leftBarButtonItem=leftItem;
 
    }
    
    [super pushViewController:viewController animated:animated];
    
    viewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
    viewController.navigationController.interactivePopGestureRecognizer.delegate = nil;
}*/


- (void)back {
    if (_isRoot)
    {
        [self popToRootViewControllerAnimated:YES];
    }else
    {
        [self popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
