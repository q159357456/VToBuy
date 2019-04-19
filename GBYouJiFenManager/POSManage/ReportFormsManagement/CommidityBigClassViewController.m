//
//  CommidityBigClassViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 xia. All rights reserved.

#import "CommidityBigClassViewController.h"
#import "reportFormsTableViewCell.h"
#import "commidityBigClassModel.h"
#import "DateCommidityBigClassModel.h"
#import "paymentDetailModel.h"
#import "datePaymentDetailModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface CommidityBigClassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionString;
@end

@implementation CommidityBigClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conditionString = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    
    [self initArr];
    
    [self initHeadView];
    
    [self initCommidityTable];
    
    [self getAllData];
    
    [self getBillType];
}

-(void)initArr
{
    _dataArray = [[NSMutableArray alloc] init];
    _titleArr = [NSArray array];
    _billTypeArray = [NSMutableArray array];
}

-(void)getBillType
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSCM",@"SelectField":@"*",@"Condition":_conditionString,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
     
    _billTypeArray = [SettleBillModel getDataWith:dic1];
        
        [_commidityTable reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    if (_tagNumber == 850) {
        NSString *conditionStr = [NSString stringWithFormat:@"PPI001$=$%@$AND$PPI002$=$%@",_str1,_str2];
        dic= @{@"FromTableName":@"POSPPI",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"Page":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    }
    if (_tagNumber == 851) {
        NSString *conditionStr = [NSString stringWithFormat:@"PEI001$=$%@$AND$PEI002$=$%@",_str1,_str2];
        dic= @{@"FromTableName":@"POSPEI",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"Page":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNumber == 852) {
        NSString *conditionStr = [NSString stringWithFormat:@"PPP001$=$%@$AND$PPP002$=$%@",_str1,_str2];
        dic= @{@"FromTableName":@"POSPPP",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"Page":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    }
    if (_tagNumber == 853) {
        NSString *conditionStr = [NSString stringWithFormat:@"PEP001$=$%@$AND$PEP002$=$%@",_str1,_str2];
        dic= @{@"FromTableName":@"POSPEP",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"",@"Page":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    }
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo4" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        if (_tagNumber == 850) {
            _dataArray = [commidityBigClassModel getDataWithDic:dic1];
        }
        if (_tagNumber == 851) {
            _dataArray = [DateCommidityBigClassModel getDataWithDic:dic1];
        }
        if (_tagNumber == 852) {
            _dataArray = [paymentDetailModel getDataWithDic:dic1];
        }
        if (_tagNumber == 853) {
            _dataArray = [datePaymentDetailModel getDataWithDic:dic1];
        }
        [_commidityTable reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, screen_width, 40)];
    _headView.backgroundColor = navigationBarColor;
    if (_tagNumber==850||_tagNumber==851) {
        _titleArr = @[@"商品大类名称",@"下单金额",@"折扣金额",@"实付金额"];
    }
    if (_tagNumber ==852||_tagNumber==853) {
        _titleArr = @[@"营业日期",@"结账类型",@"收款金额",@"找零金额"];
    }
    for (int i = 0; i<4; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*(screen_width/4), 0, screen_width/4, 40)];
        lab.text = _titleArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        [_headView addSubview:lab];
    }
    [self.view addSubview:_headView];
}

-(void)initCommidityTable
{
    _commidityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, screen_width, screen_height-110) style:UITableViewStylePlain];
    _commidityTable.delegate = self;
    _commidityTable.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _commidityTable.tableFooterView = v;
    
    [_commidityTable registerNib:[UINib nibWithNibName:@"reportFormsTableViewCell" bundle:nil] forCellReuseIdentifier:@"reportFormsTableViewCell"];
    [self.view addSubview:_commidityTable];
    
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
   
    static NSString *cellid = @"reportFormsTableViewCell";
    reportFormsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"reportFormsTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_tagNumber == 850) {
         commidityBigClassModel *model = _dataArray[indexPath.row];
        [cell setDataWithModel2:model];
    }
    
    if (_tagNumber == 851) {
        DateCommidityBigClassModel *model = _dataArray[indexPath.row];
        [cell setDataWithModel3:model];
    }
    
    if (_tagNumber == 852) {
        paymentDetailModel *model = _dataArray[indexPath.row];
        [cell setDataWithModel4:model];
         //cell.label1.text = model.dateTime;
//        for (SettleBillModel *model1 in self.billTypeArray) {
//            if ([model.billType isEqualToString:model1.BillCode]) {
//                cell.label2.text = model1.billName;
//            }
//        }
//        cell.label2.text = model.billType;
//        cell.label3.text = model.payMoneyPPP;
//        cell.label4.text = model.changeMoneyPPP;
    }
    
    if (_tagNumber == 853) {
        datePaymentDetailModel *model = _dataArray[indexPath.row];
        [cell setDataWithModel5:model];
    }
    return cell;
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
