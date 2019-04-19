//
//  AddProductViewController.h
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface AddProductViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,copy)NSString *funType;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,retain)ProductModel *productModel;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)void(^backBlock)();
@end
