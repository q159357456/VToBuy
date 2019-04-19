//
//  PayDetailViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Theight;
@property(nonatomic,copy)NSString  *billNo;
@property(nonatomic,copy)NSString  *seatNo;
@property(nonatomic,copy)NSString  *seatName;
@property(nonatomic,copy)NSString  *totalPrice;

/**
 规格
 */
@property(nonatomic,strong)NSMutableArray *tastArray;

/**
 商品
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
