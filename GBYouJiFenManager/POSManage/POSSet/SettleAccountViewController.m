//
//  SettleAccountViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "SettleAccountViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ChoosePOSSetModeViewController.h"
@interface SettleAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
/**
 上传商品信息参数
 */
@property(nonatomic,copy)NSString *printBill;//列印账单
@property(nonatomic,copy)NSString *rerurnCharge;//找零
@property(nonatomic,copy)NSString *speedMoney;//快速付款
@property(nonatomic,copy)NSString *validCode;//有效码
@property(nonatomic,copy)NSString *scoreExchange;;//积分兑换
@property(nonatomic,copy)NSString *billName;//结账名称
@property(nonatomic,copy)NSString *BillCode;//结账分类代码
@property(nonatomic,copy)NSString *BillCodeName;//结账分类代码名称
@property(nonatomic,copy)NSString *GetCode;//营收代码
@property(nonatomic,copy)NSString *GetCodeName;//营收代码名称
@property(nonatomic,copy)NSString *insideRate;//内部兑换率
@property(nonatomic,copy)NSString *outsideRate;//外部兑换率
@property(nonatomic,copy)NSString *sortOrder;//排列顺序
@property(nonatomic,copy)NSString *faceValueType;//面值类型
@property(nonatomic,copy)NSString *faceValueTypeName;//面值类型名称
@property(nonatomic,copy)NSString *faceValueMoney;//面值金额

@end

@implementation SettleAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];

    _dataArray = [NSMutableArray array];
    
    [self getSettleBillCode];
    
    [self initUI];
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.faceValueMoney = self.SBModel.faceValueMoney;
        if ([self.SBModel.faceValueType isEqualToString:@"0"]) {
                                _faceValueTypeName = @"可输入";
                            }
                            if ([self.SBModel.faceValueType isEqualToString:@"1"]) {
                                _faceValueTypeName = @"指定面值";
                            }
                            //cell.inputText.text=self.SBModel.faceValueType;
         self.faceValueType = self.SBModel.faceValueType;
         self.sortOrder = self.SBModel.sortOrder;
        self.outsideRate = self.SBModel.outsideRate;
         self.insideRate = self.SBModel.insideRate;
        if ([self.SBModel.GetCode isEqualToString:@"0"])
        {
             _GetCodeName=@"非营收收入";
            
        }
        
        if ([self.SBModel.GetCode isEqualToString:@"1"]) {
            _GetCodeName=@"营收收入";
        }
        
       self.GetCode = self.SBModel.GetCode;
        self.BillCode = self.SBModel.BillCode;
        self.billName = self.SBModel.billName;
        self.printBill = self.SBModel.printBill;
        self.rerurnCharge = self.SBModel.rerurnCharge;
        self.speedMoney = self.SBModel.speedMoney;
        self.scoreExchange = self.SBModel.scoreExchange;
        self.validCode = self.SBModel.validCode;
    }else
    {
        self.BillCodeName=@"--请选择--";
        self.GetCodeName=@"--请选择--";
        self.faceValueTypeName=@"--请选择--";
        self.printBill = @"True";
        self.rerurnCharge = @"false";
        self.speedMoney = @"false";
        self.scoreExchange = @"false";
        self.validCode = @"True";
    }
}

-(void)getSettleBillCode
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSCC",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [SettleBillClassModel getDataWith:dic1];
        if ( [self.chooseType isEqualToString:@"Edit"])
        {
            for (SettleBillClassModel *sModel in _dataArray) {
                
              if ([self.SBModel.BillCode isEqualToString:sModel.itemNo])
              {
                    _BillCodeName= sModel.billName;
                  
              }
            
                          
            }
        }
        

        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.doneButton.backgroundColor=MainColor;
    
    _SettleBillArray = [NSMutableArray array];
    
    _titleArray = @[@"结账名称",@"结账分类",@"营收类型",@"内部兑换率",@"外部兑换率",@"排列顺序",@"面值类型",@"面值金额",@"是否找零",@"列印账单",@"快速付款",@"有效码",@"积分兑换",];
    _table.delegate = self;
    _table.dataSource = self;
    
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTableViewCell"];
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTwoTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<8) {
        static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
        
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        //AddDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            //cell = [[AddDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddDetailTableViewCell_ID];
        }
        
        cell.nameLable.text = _titleArray[indexPath.row];
        cell.nameLable.font = [UIFont systemFontOfSize:13];

        [self getCellDataWithCell:cell index:indexPath.row];
        cell.inputText.delegate=self;
        cell.inputText.tag = 150 + indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row== 8)
    {
        __weak typeof(self)weakSelf=self;
        
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"是否找零";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.rerurnCharge isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 1;
        }
        
        cell.statuseBlock=^(NSString *str){
            
            weakSelf.rerurnCharge=str;
            NSLog(@"是否找零:%@",weakSelf.rerurnCharge);
            
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.row==9)
    {
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"列印账单";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
       
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.printBill isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 0;
        }
        
        cell.statuseBlock=^(NSString *str){
            weakSelf.printBill=str;
            NSLog(@"列印账单:%@",weakSelf.printBill);
            
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if(indexPath.row==10)
    {
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"快速付款";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.speedMoney isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 1;
        }
        
        
        cell.statuseBlock=^(NSString *str){
            
                weakSelf.speedMoney=str;
        
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if(indexPath.row==11)
    {
        
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"有效码";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.validCode isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }

        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 0;
        }
        
        cell.statuseBlock=^(NSString *str){
            
            weakSelf.validCode=str;
            
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;

    }else
    {
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"积分兑换";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.scoreExchange isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }

        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 1;
        }
        
        cell.statuseBlock=^(NSString *str){
            
            weakSelf.scoreExchange=str;
            
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;

    }
}

-(void)getCellDataWithCell:(AddDetailTableViewCell*)cell index:(NSInteger)index
{
    switch (index) {
        case 0:
        {

            cell.inputText.text = self.billName;
           
        }
            break;
        case 1:
        {
      
            cell.inputText.text = self.BillCodeName;
        }
            break;
        case 2:
        {

            cell.inputText.text = self.GetCodeName;
           
        }
            break;
        case 3:
        {
            cell.inputText.text = self.insideRate;
            cell.inputText.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
            break;
        case 4:
        {
            cell.inputText.text = self.outsideRate;
            cell.inputText.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
            break;
        case 5:
        {
            
            cell.inputText.text = self.sortOrder;
            cell.inputText.keyboardType = UIKeyboardTypeNumberPad;
            
        }
            break;
        case 6:
        {

            cell.inputText.text = self.faceValueTypeName;
            
        }
            break;
        case 7:
        {

            cell.inputText.text = self.faceValueMoney;
            cell.inputText.keyboardType = UIKeyboardTypeDecimalPad;
            
        }
            break;

            
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
    switch (textField.tag) {
        case 150:
        {
            self.billName = textField.text;
        }
            break;
        case 151:
        {
            
            //self.BillCode = textField.text;
            
        }
            break;
        case 152:
        {
            //self.GetCode = textField.text;
        }
            break;
        case 153:
        {
            self.insideRate = textField.text;
        }
            break;
        case 154:
        {
            self.outsideRate = textField.text;
        }
            break;
        case 155:
        {
            self.sortOrder = textField.text;
        }
            break;
            
        case 156:
        {
            //self.faceValueType = textField.text;
        }
            break;

        case 157:
        {
            self.faceValueMoney = textField.text;
        }
            break;

            
        default:
            
            break;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


- (IBAction)sureButtonClick:(id)sender {
    NSLog(@"结账方式被提交");
    
    if (self.billName.length == 0||self.sortOrder.length==0||self.BillCode.length==0||self.GetCode.length == 0||self.insideRate.length==0||self.outsideRate.length==0) {
        [self alertShowWithStr:@"请输入必填信息"];
    }else
    {
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }
}

-(void)editItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    
    if ([self.faceValueType isEqualToString:@"1"]) {
        self.faceValueMoney = @"0";
    }
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSCM",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"CM002":self.billName,@"CM017":self.GetCode,@"CM004":self.BillCode,@"CM005":self.insideRate,@"CM006":self.outsideRate,@"CM007":self.sortOrder,@"CM008":self.printBill,@"CM011":self.faceValueType,@"CM013":self.faceValueMoney,@"CM018":self.rerurnCharge,@"CM019":self.validCode,@"CM022":self.scoreExchange,@"CM023":self.speedMoney,@"CM001":self.SBModel.itemNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.backBlock();
                
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}



-(void)addItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    
    if ([self.faceValueType isEqualToString:@"0"]) {
        self.faceValueMoney = @"0";
    }
        jsonDic=@{ @"Command":@"Add",@"TableName":@"POSCM",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"CM002":self.billName,@"CM017":self.GetCode,@"CM004":self.BillCode,@"CM005":self.insideRate,@"CM006":self.outsideRate,@"CM007":self.sortOrder,@"CM008":self.printBill,@"CM011":self.faceValueType,@"CM013":self.faceValueMoney,@"CM018":self.rerurnCharge,@"CM019":self.validCode,@"CM022":self.scoreExchange,@"CM023":self.speedMoney}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    

    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 151) {
        UITextField *field = [self.view viewWithTag:151];
        ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
        chooseVC.title = @"结账分类";
        chooseVC.tagNumber = 151;
        chooseVC.backBlock1 = ^(SettleBillClassModel *model1){
            field.text = model1.billName;
            _BillCodeName=field.text;
            self.BillCode = model1.itemNo;
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
        return NO;
    }
    //
    if (textField.tag == 152) {
        UITextField *field = [self.view viewWithTag:152];
        ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
        chooseVC.title = @"营收类型";
        chooseVC.tagNumber = 152;
        chooseVC.backBlock = ^(NSString *str){
            field.text = [str substringFromIndex:2];
            _GetCodeName=field.text;
            self.GetCode = [str substringToIndex:1];
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
        return NO;
    }

    
    if (textField.tag == 156) {
        UITextField *field = [self.view viewWithTag:156];
        ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
        chooseVC.title = @"面值类型";
        chooseVC.tagNumber = 156;
        chooseVC.backBlock = ^(NSString *str){
            field.text = [str substringFromIndex:2];
            _faceValueTypeName=field.text;
            self.faceValueType = [str substringToIndex:1];
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
        return NO;
    }
    if ([self.faceValueType isEqualToString:@"0"]&&textField.tag==157) {
        
        //self.faceValueMoney = @"0";
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
