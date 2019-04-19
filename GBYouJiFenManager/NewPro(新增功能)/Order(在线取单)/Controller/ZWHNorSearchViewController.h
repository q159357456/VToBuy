//
//  ZWHNorSearchViewController.h
//  FengHuaKe
//
//  Created by Syrena on 2018/8/24.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "ZWHBaseViewController.h"

typedef void (^searchWithStr)(NSString *context);

@interface ZWHNorSearchViewController : ZWHBaseViewController

@property (nonatomic,strong)searchWithStr contextBlock;


//0 取单搜索
@property(nonatomic,assign)NSInteger state;




@end
