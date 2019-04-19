//
//  CloseReportViewController.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseReportModel.h"
#import "classesModel.h"
#import "FloorModel.h"
@interface CloseReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *label1;
@property (weak, nonatomic) IBOutlet UIView *label2;
@property (weak, nonatomic) IBOutlet UIView *label3;
@property (weak, nonatomic) IBOutlet UIView *label4;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UILabel *inLabel1;
@property (weak, nonatomic) IBOutlet UILabel *inLabel2;
@property (weak, nonatomic) IBOutlet UILabel *inLabel3;
@property (weak, nonatomic) IBOutlet UILabel *inLabel4;

@property(nonatomic,strong)UIView *ItemView;

@property(nonatomic,strong)UITableView *classTable;
@property(nonatomic,strong)UITableView *closeReportTable;
@property(nonatomic,strong)UITableView *areaTable;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *classArray;

@property(nonatomic,strong)NSMutableArray *areaArray;

@end
