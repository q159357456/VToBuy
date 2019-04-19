//
//  DateFormsViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateFormsModel.h"
@interface DateFormsViewController : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *beginLabel;
@property(nonatomic,weak)IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIView *lab1;
@property (weak, nonatomic) IBOutlet UIView *lab2;


@property(nonatomic,weak)IBOutlet UIButton *btn1;
@property(nonatomic,weak)IBOutlet UIButton *btn2;
@property(nonatomic,weak)IBOutlet UIButton *btn3;
@property(nonatomic,weak)IBOutlet UIButton *btn4;

@property(nonatomic,strong)UIView *ItemView;

@property(nonatomic,strong)UITableView *formsTable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
