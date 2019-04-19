//
//  ScanningQRCodeVC.h
//  Restaurant
//
//  Created by 张帆 on 16/11/4.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanningQRCodeVC : UIViewController

//判断 扫描目的（扫座位还是扫商品）,然后 进行相对应的动作
@property(nonatomic,strong)NSString *scanStyle;
@property(nonatomic,copy)void(^backBlock)(NSString *code);
@end
