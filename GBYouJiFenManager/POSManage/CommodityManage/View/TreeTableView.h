//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"
@interface TreeTableView : UITableView

-(instancetype)initWithFrame:(CGRect)frame withData : (NSMutableArray *)data;
@property(nonatomic,copy)void(^backBlock)(ClassifyModel *model);
@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）
@property(nonatomic,assign)BOOL doneButt;

-(void)getData:(NSMutableArray *)data;
@end
