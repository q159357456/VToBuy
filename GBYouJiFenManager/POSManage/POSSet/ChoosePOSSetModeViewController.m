//
//  ChoosePOSSetModeViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/26.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "ChoosePOSSetModeViewController.h"
#import "ChooseTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface ChoosePOSSetModeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation ChoosePOSSetModeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.tagNumber == 151 || self.tagNumber == 572) {
        

        self.model = [[FMDBMember shareInstance] getMemberData][0];
        self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
        
        [self getSettleBillCode];
        
        [self  getMachineNumber];

    }
    
    _dataArray = [NSMutableArray array];
    
    [self initTable];
    
    [self initDataArray];
    
   }

-(void)getSettleBillCode
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSCC",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        if (_tagNumber == 151) {
            _dataArray = [SettleBillClassModel getDataWith:dic1];
        }
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getMachineNumber
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSDN",@"SelectField":@"*",@"Condition":self.conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        if (_tagNumber == 572) {
            _dataArray = [PCRegisyerModel getDataWithDic:dic1];
        }
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
 
}


-(void)initDataArray
{
    if (_tagNumber == 567) {
        _dataArray = [NSMutableArray arrayWithObjects:@"01  餐厅",@"02  快餐",@"03  零售",@"04  生鲜", nil];
    }
    if (_tagNumber == 569) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0  付款前",@"1  付款后", nil];
    }if (_tagNumber == 568) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0  不显示",@"1   输入模式",@"2  选择模式", nil];
    }if (_tagNumber == 570) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0  直接打印",@"1  预览", nil];
    }if (_tagNumber == 571) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0  打印打开",@"1  直接打开", nil];
    }if (_tagNumber == 156) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0:可输入",@"1:指定面值", nil];
    }if (_tagNumber == 152) {
        _dataArray = [NSMutableArray arrayWithObjects:@"0:非营收收入",@"1:营收收入", nil];
    }
}

-(void)initTable
{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    
    _table.delegate = self;
    _table.dataSource = self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    
    [_table dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];
    [self.view addSubview:_table];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    cell.contentLable.font = [UIFont systemFontOfSize:13];
    if (_tagNumber == 151) {
        SettleBillClassModel *model = _dataArray[indexPath.row];
        cell.contentLable.text = model.billName;
    }else if (_tagNumber == 572){
        PCRegisyerModel *model = _dataArray[indexPath.row];
        cell.contentLable.text = model.PCName;
    }else{
    cell.contentLable.text= _dataArray[indexPath.row];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNumber == 151) {
        SettleBillClassModel *model = _dataArray[indexPath.row];
        for (SettleBillClassModel *model1 in _dataArray) {
            if ([model.itemNo isEqualToString:model1.itemNo]) {
                self.backBlock1(model1);
            }
        }

    }else if (_tagNumber == 572){
        PCRegisyerModel *model = _dataArray[indexPath.row];
        for (PCRegisyerModel *model2 in _dataArray) {
            if ([model.itemNo isEqualToString:model2.itemNo]) {
                self.backBlock2(model2);
            }
        }
    }else
    {
    NSString *str = _dataArray[indexPath.row];
    for (NSString *str1 in _dataArray) {
        if ([str1 isEqualToString:str]) {
            self.backBlock(str1);
        }
     }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
