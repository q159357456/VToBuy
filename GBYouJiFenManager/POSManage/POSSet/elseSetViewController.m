//
//  elseSetViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/22.
//  Copyright © 2017年 xia. All rights reserved.


#import "elseSetViewController.h"
#import "ChoosePOSSetModeViewController.h"
#import "AddDetailTableViewCell.h"
#import "POSSetDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "PCRegisyerModel.h"
@interface elseSetViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@property(nonatomic,copy)NSString *string1;
@property(nonatomic,copy)NSString *string2;
@property(nonatomic,copy)NSString *string3;
@property(nonatomic,copy)NSString *string4;
@property(nonatomic,copy)NSString *string5;
@property(nonatomic,copy)NSString *string6;
@property(nonatomic,copy)NSString *string7;
@property(nonatomic,copy)NSString *string8;
@property(nonatomic,copy)NSString *strings8;
@property(nonatomic,copy)NSString *string9;
@property(nonatomic,copy)NSString *strings9;
@property(nonatomic,copy)NSString *string10;
@property(nonatomic,copy)NSString *strings10;
@property(nonatomic,copy)NSString *string11;
@property(nonatomic,copy)NSString *strings11;
@property(nonatomic,copy)NSString *string12;
@property(nonatomic,copy)NSString *strings12;
@property(nonatomic,copy)NSString *string13;

@property(nonatomic,strong)NSMutableArray *tableArray1;
@property(nonatomic,strong)NSMutableArray *tableArray2;
@property(nonatomic,strong)NSMutableArray *tableArray3;
@property(nonatomic,strong)NSMutableArray *tableArray4;
@property(nonatomic,strong)NSMutableArray *tableArray5;
@property(nonatomic,strong)NSMutableArray *tableArray6;
@end

@implementation elseSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    
    [self initFootView];
    [self initTableView];
    
    [self initArray];
    
    [self getMachineNumber];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    _titleArray = @[@"房台分页数量",@"房台控件高度",@"房台控件宽度",@"账单控件高度",@"账单控件宽度",@"商品显示分页数量",@"其他房台分页数量",@"POS模式",@"桌台显示模式",@"送单方式",@"打印模式",@"钱箱打开方式",@"微单处理设备"];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    
    self.string1 = self.modelSet.POS_SeatShowQty;
    self.string2 = self.modelSet.POS_SeatHeight;
    self.string3 = self.modelSet.POS_SeatWidth;
    self.string4 = self.modelSet.POS_BillHeight;
    self.string5 = self.modelSet.POS_BillWidth;
    self.string6 = self.modelSet.POS_GoodShowQty;
    self.string7 = self.modelSet.POS_SeatShowOtherQty;
    if (self.modelSet.POS_RunModel ==nil) {
        self.string8 = @"--请选择--";
    }else{
        self.string8 = self.modelSet.POS_RunModel;
    }
    if (self.modelSet.POS_RoomMode ==nil) {
        self.string9 = @"--请选择--";
    }else{
        self.string9 = self.modelSet.POS_RoomMode;
    }
    if (self.modelSet.POS_RunModel ==nil) {
        self.string10 = @"--请选择--";
    }else{
        self.string10 = self.modelSet.POS_SendBillMode;
    }
    if (self.modelSet.POS_RunModel ==nil) {
        self.string11 = @"--请选择--";
    }else{
        self.string11 = self.modelSet.POS_PrintMode;
    }
    if (self.modelSet.POS_RunModel ==nil) {
        self.string12 = @"--请选择--";
    }else{
        self.string12 = self.modelSet.POS_CashBoxOpenWay;
    }
    
    if (self.modelSet.UDF01 ==nil) {
        self.string13 = @"--请选择--";
    }else{
        self.string13 = self.modelSet.UDF01;
    }
}

-(void)getMachineNumber
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSDN",@"SelectField":@"*",@"Condition":self.conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _tableArray6 = [PCRegisyerModel getDataWithDic:dic1];
        [_TableView reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
//你好，是数夫软件的大 boss吗？我是贵公司研发部高级程序员阮平的。。。，
-(void)initTableView
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-50-64) style:UITableViewStylePlain];
    _TableView.dataSource = self;
    _TableView.delegate = self;
    
    [_TableView registerNib:[UINib nibWithNibName:@"POSSetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"POSSetDetailTableViewCell"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _TableView.tableFooterView = v;
    
    [self.view addSubview:_TableView];
    
}

-(void)initFootView
{
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-50, screen_width, 50)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_footView addSubview:line];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(screen_width/2, 3, 1, 44)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [_footView addSubview:line1];
    
    for (int i = 0; i<2; i++) {
        NSArray *title = @[@"确定",@"取消"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(screen_width/2), 0, screen_width/2, 50)];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 700 +i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
    }
    [self.view addSubview:_footView];
}

-(void)initArray
{
     _tableArray1 = [NSMutableArray arrayWithObjects:@"01  餐厅",@"02  快餐",@"03  零售",@"04  生鲜", nil];
    
    
    _tableArray3 = [NSMutableArray arrayWithObjects:@"0  付款前",@"1  付款后", nil];
    
    _tableArray2 = [NSMutableArray arrayWithObjects:@"0  不显示",@"1   输入模式",@"2  选择模式", nil];
    
    _tableArray4 = [NSMutableArray arrayWithObjects:@"0  直接打印",@"1  预览", nil];
    
    _tableArray5 = [NSMutableArray arrayWithObjects:@"0  打印打开",@"1  直接打开", nil];
    
    _tableArray6 = [NSMutableArray array];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *AddDetailTableViewCell_ID = @"POSSetDetailTableViewCell";
    AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"POSSetDetailTableViewCell" owner:nil options:nil][0];
    }
    cell.nameLable.text=_titleArray[indexPath.row];
    cell.inputText.delegate=self;
    cell.inputText.keyboardType = UIKeyboardTypeNumberPad;
    cell.inputText.tag=indexPath.row+560;
    
    [self swich:cell :(indexPath.row+560)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)swich:(AddDetailTableViewCell*)cell :(NSInteger)index
{
    
           switch (index) {
            case 560:
            {
                //房台分页数量
                //cell.inputText.text=title[0];
                cell.inputText.text = _string1;
                
            }
                break;
            case 561:
            {
                //房台控件高度
                cell.inputText.text=_string2;
            }
                break;
            case 562:
            {
                //房台控件宽度
                cell.inputText.text=_string3;
            }
                break;
            case 563:
            {
                //账单控件高度
                cell.inputText.text=_string4;
                
            }
                break;
            case 564:
            {
                //账单控件宽度
                cell.inputText.text=_string5;
                
            }
                break;
            case 565:
            {
                //商品显示分页数量
                cell.inputText.text=_string6;
               
                
            }
                break;
            case 566:
            {
                //其他房台分页数量
                cell.inputText.text=_string7;
                
            }
                break;
               case 567:
               {
                   //pos模式
                   for (NSString *str  in _tableArray1) {
                       if ([_string8 isEqualToString:[str substringToIndex:2]]) {
                           cell.inputText.text = [str substringFromIndex:2];
                       }
                   }
                   //cell.inputText.text=_string8;
                   
               }
                   break;
               case 568:
               {
                   //桌台显示模式
                   for (NSString *str  in _tableArray2) {
                       if ([_string9 isEqualToString:[str substringToIndex:1]]) {
                           cell.inputText.text = [str substringFromIndex:1];
                       }
                   }

                  // cell.inputText.text=_string9;
                   
               }
                   break;
               case 569:
               {
                   //送单方式
                   for (NSString *str  in _tableArray3) {
                       if ([_string10 isEqualToString:[str substringToIndex:1]]) {
                           cell.inputText.text = [str substringFromIndex:1];
                       }
                   }
                   //cell.inputText.text=_string10;
                   
               }
                   break;
               case 570:
               {
                   //打印方式
                   for (NSString *str  in _tableArray4) {
                       if ([_string11 isEqualToString:[str substringToIndex:1]]) {
                           cell.inputText.text = [str substringFromIndex:1];
                       }
                   }
                   //cell.inputText.text=_string11;
                   
               }
                   break;
               case 571:
               {
                   //钱箱打开方式
                   for (NSString *str  in _tableArray5) {
                       if ([_string12 isEqualToString:[str substringToIndex:1]]) {
                           cell.inputText.text = [str substringFromIndex:1];
                       }
                   }
                  // cell.inputText.text=_string12;
                   
               }
                   break;
                   
                   
               case 572:
               {
                   //微单处理设备
                   for (PCRegisyerModel *model in _tableArray6) {
                       if ([_string13 isEqualToString:model.itemNo]) {
                           cell.inputText.text = model.PCName;
                       }
                   }
                   //cell.inputText.text = _string13;
                   
               }
                   break;
            default:
                break;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



-(void)btnClick:(UIButton *)btn
{

    if (btn.tag==700) {
        NSLog(@"提交按钮被点击");
        if (_string1== nil||_string2 == nil||_string3 == nil||_string4 == nil ||_string5 == nil||_string6 == nil ||_string7 == nil ||_string8 == nil ||_string9 == nil || _string10 == nil ||_string11 == nil ||_string12 == nil||_string13 == nil) {
            [self alertShowWithStr1:@"请完整填写设置选项"];
        }else
        {
            
            [SVProgressHUD showWithStatus:@"玩命加载中"];
            NSDictionary *jsonDic;

jsonDic=@{ @"Command":@"Edit",@"TableName":@"cms_commpara",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"POS_OrderPrintNum":self.modelSet.POS_OrderPrintNum,@"POS_PassWorkPrintNum":self.modelSet.POS_PassWorkPrintNum,@"POS_MemberReceiptPrintNum":self.modelSet.POS_MemberReceiptPrintNum,@"POS_ReceiptPrintNum":self.modelSet.POS_ReceiptPrintNum,@"POS_GiftPrintNum":self.modelSet.POS_GiftPrintNum,@"POS_CashBoxPrintNum":self.modelSet.POS_CashBoxPrintNum,@"POS_GuanDanPrintNum":self.modelSet.POS_GuanDanPrintNum,@"POS_OrderTitle":self.modelSet.POS_Ordertitle,@"POS_PassWorkTitle":self.modelSet.POS_PassWorkTitle,@"POS_MemberReceiptTitle":self.modelSet.POS_MemberReceiptTitle,@"POS_ReceiptTitle":self.modelSet.POS_ReceiptTitle,@"POS_GiftTitle":self.modelSet.POS_GiftTitle,@"POS_CashBoxTitle":self.modelSet.POS_CashBoxTitle,@"POS_GuanDanTitle":self.modelSet.POS_GuanDanTitle,@"POS_SeatShowQty":_string1,@"POS_SeatHeight":_string2,@"POS_SeatWidth":_string3,@"POS_BillHeight":_string4,@"POS_BillWidth":_string5,@"POS_GoodShowQty":_string6,@"POS_SeatShowOtherQty":_string7,@"POS_RunModel":_string8,@"POS_RoomMode":_string9,@"POS_SendBillMode":_string10,@"POS_PrintMode":_string11,@"POS_CashBoxOpenWay":_string12,@"UDF01":_string13}]};

            NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
            [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                NSString *str=[JsonTools getNSString:responseObject];
                if ([str isEqualToString:@"OK"])
                {
                    [[NSUserDefaults standardUserDefaults]setValue:_string8 forKey:@"POS_RunModel"];
                    [[NSUserDefaults standardUserDefaults] synchronize ];
                    [SVProgressHUD showSuccessWithStatus:@"设置提交成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        self.backBlock();
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

            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self alertShowWithStr:@"是否取消操作"];
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 567:
        {
            UITextField *field = [self.view viewWithTag:567];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"POS模式";
            chooseVC.tagNumber = 567;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:2];
                _string8 = [str substringToIndex:2];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
        case 568:
        {
            UITextField *field = [self.view viewWithTag:568];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"桌台显示模式";
            chooseVC.tagNumber = 568;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:1];
                _string9 = [str substringToIndex:1];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
        case 569:
        {
            UITextField *field = [self.view viewWithTag:569];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"送单方式";
            chooseVC.tagNumber = 569;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:1];
                _string10 = [str substringToIndex:1];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
        case 570:
        {
            UITextField *field = [self.view viewWithTag:570];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"打印模式";
            chooseVC.tagNumber = 570;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:1];
                _string11 = [str substringToIndex:1];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
        case 571:
        {
            UITextField *field = [self.view viewWithTag:571];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"钱箱打开方式";
            chooseVC.tagNumber = 571;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:1];
                _string12 = [str substringToIndex:1];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
        case 572:
        {
            UITextField *field = [self.view viewWithTag:572];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"微单处理设备";
            chooseVC.tagNumber = 572;
            chooseVC.backBlock2 = ^(PCRegisyerModel *model) {
                field.text = model.PCName;
                _string13 = model.itemNo;
            };
        [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 560:
            self.string1 = textField.text;
            break;
        case 561:
            self.string2 = textField.text;
            break;
        case 562:
            self.string3 = textField.text;
            break;

        case 563:
            self.string4 = textField.text;
            break;

        case 564:
            self.string5 = textField.text;
            break;

        case 565:
            self.string6 = textField.text;
            break;

        case 566:
            self.string7 = textField.text;
            break;

        default:
            break;
    }
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)alertShowWithStr1:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
   
    [self presentViewController:alert animated:YES completion:nil];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
