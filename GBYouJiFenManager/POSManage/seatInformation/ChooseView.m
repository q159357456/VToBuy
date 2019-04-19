//
//  ChooseView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChooseView.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ReasonTableViewCell.h"

@interface ChooseView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)FloorModel *floorModel;

@end
@implementation ChooseView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius=2;
        self.layer.masksToBounds=YES;
        _model=[[FMDBMember shareInstance]getMemberData][0];
        _dataArray=[NSMutableArray array];
        [self getdata];
        
    }
    return self;
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;
    _doneButton.backgroundColor=MainColor;
}
-(void)getdata
{
    
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        self.dataArray=[FloorModel getDataWithDic:dic1];
        [self.tableiew reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
    
}

-(void)setTableiew:(UITableView *)tableiew
{
    _tableiew=tableiew;
    _tableiew.delegate=self;
    _tableiew.dataSource=self;
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellid=@"ReasonTableViewCell";
 
    ReasonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"ReasonTableViewCell" owner:nil options:nil][0];
        
    }
    FloorModel *model=_dataArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (model.selected==YES)
    {
        cell.selectImage.image=[UIImage imageNamed:@"slected_2"];
        
    }else
    {
        cell.selectImage.image=[UIImage imageNamed:@"slected_1"];
    }
    cell.resonLable.text=model.FloorInfo;
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        FloorModel *model=_dataArray[indexPath.row];
   
    for (FloorModel *smodel in _dataArray)
    {
        if ([smodel.itemNo isEqualToString:model.itemNo])
        {
            smodel.selected=YES;
            self.floorModel=smodel;
        }else
        {
            smodel.selected=NO;
        }
    }
        
    [_tableiew reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (IBAction)done:(UIButton *)sender {
    [self removeFromSuperview];
    self.backBlock(self.floorModel);
}
@end
