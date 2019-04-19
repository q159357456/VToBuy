//
//  SalseReturnView.m
//  YiJieGou
//
//  Created by 工博计算机 on 17/4/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SalseReturnView.h"
#import "ReasonTableViewCell.h"
#import "ResonModel.h"
@interface SalseReturnView ()
@property(nonatomic,copy)NSString *item;
@property(nonatomic,copy)NSString *reasonStr;
@end
@implementation SalseReturnView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
        self.layer.cornerRadius=8;
        self.layer.masksToBounds=YES;
        self.minNum=1;
      

    }
    return self;
}
-(void)getModelDataWithModel:(SBPModel *)model
{
   
    float count=model.leftCount;
    NSString *conutStr=[NSString stringWithFormat:@"%.0f",count];
    _productName.text=[NSString stringWithFormat:@"%@(共%@件)",model.SBP005,conutStr];
    self.maxNum=count;
    self.item=model.SBP003;
    //判断按钮隐藏

    if (self.maxNum>self.minNum)
    {
        _pluseButton.hidden=NO;
        _minceButton.hidden=YES;
    }else
    {
        _pluseButton.hidden=YES;
        _minceButton.hidden=YES;
    }
  
}
-(void)setTableview:(UITableView *)tableview
{
    _tableview=tableview;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self getReturnReason];
    
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;
    _doneButton.backgroundColor=MainColor;
    _doneButton.layer.cornerRadius=10;
    _doneButton.layer.masksToBounds=YES;
    
}
-(void)setCountLable:(UILabel *)countLable
{
    _countLable=countLable;
    self.countLable.text=[NSString stringWithFormat:@"%ld",self.minNum];
}
-(void)setPluseButton:(UIButton *)pluseButton
{

    _pluseButton=pluseButton;
}
-(void)setMinceButton:(UIButton *)minceButton
{
    _minceButton=minceButton;
}
-(void)setProductName:(UILabel *)productName
{
    _productName=productName;
    

  
}
#pragma mark-table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reasonArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"ReasonTableViewCell";
    ResonModel *model=_reasonArray[indexPath.row];
    ReasonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"ReasonTableViewCell" owner:nil options:nil][0];
  
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (model.isSelected==YES)
    {
        cell.selectImage.image=[UIImage imageNamed:@"slected_2"];
        
    }else
    {
         cell.selectImage.image=[UIImage imageNamed:@"slected_1"];
    }
    cell.resonLable.text=model.CauseName_CN;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    for (NSInteger i=0; i<_reasonArray.count; i++)
    {
        ResonModel *model=_reasonArray[i];
        if (i==indexPath.row)
        {
            model.isSelected=YES;
            self.reasonStr=model.CauseName_CN;
        }else
        {
             model.isSelected=NO;
            
        }
    }
    [self.tableview reloadData];
   
    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{


}
- (IBAction)pluse:(UIButton *)sender
{
  
    self.minNum++;
    self.countLable.text=[NSString stringWithFormat:@"%ld",self.minNum];
    self.minceButton.hidden=NO;
    if (self.minNum==self.maxNum) {
        self.pluseButton.hidden=YES;
    }
    
    
    
}
- (IBAction)mince:(UIButton *)sender
{
    self.minNum--;
    self.countLable.text=[NSString stringWithFormat:@"%ld",self.minNum];
    self.pluseButton.hidden=NO;
    if (self.minNum==1) {
        self.minceButton.hidden=YES;
    }
    
}
- (IBAction)done:(UIButton *)sender
{
    NSLog(@"确定退品");
    if (self.reasonStr.length==0) {
        self.reasonStr=@"";
    }
    [self salsereturnWithItem:self.item quantity:self.countLable.text reason:self.reasonStr];
}
- (IBAction)close:(UIButton *)sender {
    [self removeFromSuperview];
    self.closeBlock();
}
//退菜原因
-(void)getReturnReason
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NetDataTool *net=[NetDataTool shareInstance];
    _reasonArray=[NSMutableArray array];
    NSString *tableName=@"CMS_CAUSE";
    NSString *selectField=@"CauseName_CN";
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":selectField,@"Condition":@"",@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    
    
    [net getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic=[JsonTools getData:responseObject];
        _reasonArray=[ResonModel getDataWithDic:dic];
        
//        NSDictionary *secDic=dic[@"DataSet"];
//        
//        _reasonArray=secDic[@"Table"];
        [self.tableview reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"请求失败");
        
    }];
    
}
//退货
-(void)salsereturnWithItem:(NSString*)item quantity:(NSString*)quantity reason:(NSString*)reason
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dic=@{@"company":self.COMPANY,@"shopid":self.SHOPID,@"billno":self.orderNumber,@"item":item,@"quantity":quantity,@"reason":reason,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"posservice.asmx/MerchantDeleteBill" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
//        NSLog(@"-------%@",str);
        if ([str isEqualToString:@"true"]) {
            
            [self removeFromSuperview];
            self.doneBlock();
            
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD  showErrorWithStatus:@"退货失败稍后再试"];
        }
        
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

@end
