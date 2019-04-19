//
//  ZWHAddSharesViewController.h
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/3.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import "ZWHBaseViewController.h"
#import "ZWHSharesModel.h"

@interface ZWHAddSharesViewController : ZWHBaseViewController

//0生产 1编辑
@property(nonatomic,copy)NSString *state;

//最大分配
@property(nonatomic,assign)float maxShares;


@property(nonatomic,strong)ZWHSharesModel *mymodel;

@end
