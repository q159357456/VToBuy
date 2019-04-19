//
//  UIViewController+NavBarHidden.m
//  FengHuaKe
//
//  Created by 秦根 on 2018/4/19.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "UIViewController+NavBarHidden.h"
#import <objc/runtime.h>
@interface UIViewController()
@property (nonatomic,strong) UIImage  * navBarBackgroundImage;
@end
@implementation UIViewController (NavBarHidden)
#pragma mark - 通过运行时动态添加存储属性
//定义关联的Key
static const char * key = "keyScrollView";

- (UIScrollView *)keyScrollView{
    
    return objc_getAssociatedObject(self, key);
}



- (void)setKeyScrollView:(UIScrollView *)keyScrollView{
    objc_setAssociatedObject(self, key, keyScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//定义关联的Key
static const char * keytableview = "keyTableView";

-(UITableView *)keyTableView{
    return objc_getAssociatedObject(self, keytableview);
}


-(void)setKeyTableView:(UITableView *)keyTableView{
    objc_setAssociatedObject(self, keytableview, keyTableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([keyTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            keyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            keyTableView.estimatedRowHeight = 0;
            keyTableView.estimatedSectionHeaderHeight = 0;
            keyTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

//定义关联的Key
static const char * keyollectionview = "keyCollectionView";
-(UICollectionView *)keyCollectionView{
    return objc_getAssociatedObject(self, keyollectionview);
}

-(void)setKeyCollectionView:(UICollectionView *)keyCollectionView{
    objc_setAssociatedObject(self, keyollectionview, keyCollectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([keyCollectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            keyCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

//定义关联的Key
static const char * navBarBackgroundImageKey = "navBarBackgroundImage";
- (UIImage *)navBarBackgroundImage{
    return objc_getAssociatedObject(self, navBarBackgroundImageKey);
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage{
    objc_setAssociatedObject(self, navBarBackgroundImageKey, navBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}








@end
