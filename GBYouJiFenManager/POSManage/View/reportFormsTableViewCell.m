//
//  reportFormsTableViewCell.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.


#import "reportFormsTableViewCell.h"

@implementation reportFormsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initLabel];
}

-(void)initLabel
{
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width/4, 40)];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/4, 0, screen_width/4, 40)];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label2];
    
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(2*(screen_width/4), 0, screen_width/4, 40)];
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label3];
    
    self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(3*(screen_width/4), 0, screen_width/4, 40)];
    self.label4.textAlignment = NSTextAlignmentCenter;
    self.label4.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label4];
}

-(void)setDataWithModel:(CloseReportModel *)model
{
    _label1.text = model.classesTimes;
    _label2.text = model.operateTime;
    _label3.text = model.operateMachine;
    _label4.text = model.FormsNumber;
}

-(void)setDataWithModel1:(DateFormsModel *)model
{
    _label1.text = model.operateTime;
    _label2.text = [model.classesTimes substringFromIndex:model.classesTimes.length-8];
    _label3.text = model.operateMachine;
    _label4.text = model.FormsNumber;
}


-(void)setDataWithModel2:(commidityBigClassModel *)model
{
    _label1.text = model.classesNamePI;
    _label2.text = model.orderMoneyPI;
    _label3.text = model.discountMoneyPI;
    _label4.text = model.actuallyMoneyPI;
}


-(void)setDataWithModel3:(DateCommidityBigClassModel *)model
{
    _label1.text = model.classesNameEI;
    _label2.text = model.orderMoneyEI;
    _label3.text = model.discountMoneyEI;
    _label4.text = model.actuallyMoneyEI;
}

-(void)setDataWithModel4:(paymentDetailModel *)model
{
    _label1.text = model.dateTime;
    _label2.text = model.billType;
    _label3.text = model.payMoneyPPP;
    _label4.text = model.changeMoneyPPP;
}

-(void)setDataWithModel5:(datePaymentDetailModel *)model
{
    _label1.text = model.dateTime;
    _label2.text = model.BillType;
    _label3.text = model.payMoneyPEP;
    _label4.text = model.changeMoneyPEP;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
