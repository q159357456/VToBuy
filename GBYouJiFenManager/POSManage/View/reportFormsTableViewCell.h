//
//  reportFormsTableViewCell.h
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloseReportModel.h"
#import "DateFormsModel.h"
#import "commidityBigClassModel.h"
#import "DateCommidityBigClassModel.h"
#import "paymentDetailModel.h"
#import "datePaymentDetailModel.h"
@interface reportFormsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UILabel *label4;
-(void)setDataWithModel:(CloseReportModel *)model;
-(void)setDataWithModel1:(DateFormsModel *)model;
-(void)setDataWithModel2:(commidityBigClassModel *)model;
-(void)setDataWithModel3:(DateCommidityBigClassModel *)model;
-(void)setDataWithModel4:(paymentDetailModel *)model;
-(void)setDataWithModel5:(datePaymentDetailModel *)model;
@end
