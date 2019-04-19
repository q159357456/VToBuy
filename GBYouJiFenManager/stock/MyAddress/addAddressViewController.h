//
//  addAddressViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"
@interface addAddressViewController : UIViewController
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,strong)addressModel *addressModel;
@property(nonatomic,copy)void(^backBlock)();
@end
