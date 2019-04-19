//
//  GBTabBarViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.
//

#import "GBTabBarViewController.h"
#import "GBNavigationViewController.h"
#import "launchZoomerView.h"
#import "StoreManageViewController.h"
#import "CommodityManageViewController.h"
#import "POSManageViewController.h"
#import "MerchantSetViewController.h"
#import "PersonCenterViewController.h"
#import "VersionManagerVC.h"

@interface GBTabBarViewController ()<UITabBarControllerDelegate>
{
    UIButton *wisdomBtn ;
}
@property(nonatomic, strong)launchZoomerView *zoomer;

@end

@implementation GBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    self.delegate = self;
    [self addNotice];
    [self createUI];
    //NOTIFY_POST(Forceupdate);
//    VersionManagerVC *vc=[[VersionManagerVC alloc]init];
//    vc.index=1;
//    UIViewController *vc = [[UIViewController alloc]init];
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    window.rootViewController = vc;
}

-(void)lauchView
{
    
    self.zoomer = [launchZoomerView addToView:self.view withImage:[UIImage imageNamed:@"slected_2"] backgroundColor:[UIColor colorWithRed:85/255.f green:172/255.f blue:238/255.f alpha:1]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.zoomer startAnimation];
    });
}

-(void)createUI
{
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    //[self.tabBar addSubview:lineView];

    
    //[self.tabBar addSubview:wisdomBtn];

    NSString *path=[[NSBundle mainBundle]pathForResource:@"MianTab" ofType:@"plist"];
    NSDictionary *rootDic=[NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *keyArray=@[@"one",@"two",@"five",@"three",@"four"];
    NSMutableArray *controllerArr=[[NSMutableArray alloc]init];
    for (int i=0; i<keyArray.count; i++) {
        NSDictionary *dic=rootDic[keyArray[i]];
        NSString *controllerName=dic[@"controllerName"];
      
        Class conClass=NSClassFromString(controllerName);
        UIViewController *vc=[[conClass alloc]init];
  
        GBNavigationViewController *nvc=[[GBNavigationViewController alloc]initWithRootViewController:vc];
        vc.navigationItem.title=dic[@"titleName"];
        nvc.tabBarItem.title=dic[@"titleName"];
        
        //设置tabBar图片
            UIImage *image=[UIImage imageNamed:dic[@"imageName"]];
            UIImage *selectImage=[UIImage imageNamed:dic[@"selectImageName"]];
            nvc.tabBarItem.image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nvc.tabBarItem.selectedImage=[[selectImage qmui_imageWithTintColor:navigationBarColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        
        [controllerArr addObject:nvc];
        
        
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navigationBarColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    self.viewControllers=controllerArr;

}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)
viewController
{
    if ([viewController.childViewControllers[0] isKindOfClass:[POSManageViewController class]] || [viewController.childViewControllers[0] isKindOfClass:[CommodityManageViewController class]] || [viewController.childViewControllers[0] isKindOfClass:[MerchantSetViewController class]]) {
        MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
        if ([model.IsGoodsAdd isEqualToString:@"True"]) {
            return YES;
        }else{
            [QMUITips showInfo:@"您的权限不能访问此功能"];
            return NO;
        }
    }
    

    return YES;
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
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
    
}
-(void)waiteupdate
{
    VersionManagerVC *vc=[[VersionManagerVC alloc]init];
    vc.index=2;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
}

@end
