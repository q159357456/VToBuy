//
//  elseSetViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSSetModel.h"
@interface elseSetViewController : UIViewController
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)UIView *footView;


@property(nonatomic,strong)POSSetModel *modelSet;

@property(nonatomic,copy)void(^backBlock)();

@end
