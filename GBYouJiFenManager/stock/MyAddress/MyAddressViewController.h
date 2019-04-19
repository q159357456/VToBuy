//
//  MyAddressViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"
@interface MyAddressViewController : UIViewController
//@property(nonatomic,strong)addressModel *AModel;
@property(nonatomic,copy)NSString *ChooseType;
@property(nonatomic,copy)void(^backBlock)(addressModel *);
@end
