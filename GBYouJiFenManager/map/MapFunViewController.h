//
//  MapFunViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapFunViewController : UIViewController
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *district;
@property(nonatomic,copy)NSString *detalAdress;
@property(nonatomic,copy)void(^backBlock)(NSString*,NSString*);
@end
