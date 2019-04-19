//
//  SalseReturnView.h
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPModel.h"
@interface SalseReturnView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *countLable;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *minceButton;
@property (strong, nonatomic) IBOutlet UIButton *pluseButton;
@property(nonatomic,copy)NSString *SHOPID;
@property(nonatomic,copy)NSString *COMPANY;
@property(nonatomic,copy)NSString *orderNumber;
@property(nonatomic,copy)void(^closeBlock)();
@property(nonatomic,copy)void(^doneBlock)();
@property(nonatomic,strong)NSMutableArray *reasonArray;
@property(nonatomic,assign)NSInteger maxNum;
@property(nonatomic,assign)NSInteger minNum;

-(void)getModelDataWithModel:(SBPModel*)model;
@end
