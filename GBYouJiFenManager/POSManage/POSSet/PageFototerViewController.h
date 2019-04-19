//
//  PageFototerViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSSetModel.h"
@interface PageFototerViewController : UIViewController
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic)NSInteger tagNum;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)POSSetModel *setModel;

@property(nonatomic,copy)void(^backBlock)();
@end
