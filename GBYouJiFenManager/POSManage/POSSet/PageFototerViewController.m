//
//  PageFototerViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/20.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "PageFototerViewController.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface PageFototerViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;

@property(nonatomic,strong)NSString *string1;
@property(nonatomic,strong)NSString *string2;
@property(nonatomic,strong)NSString *string3;
@property(nonatomic,strong)NSString *string4;
@property(nonatomic,strong)NSString *string5;
@property(nonatomic,strong)NSString *string6;
@property(nonatomic,strong)NSString *string7;

@end

@implementation PageFototerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initFootView];
    [self initTableView];
    
    NSLog(@"%f",screen_height);
    
    _titleArray = @[@"送单出品",@"交班日结",@"会员结算",@"普通结算",@"押金小票",@"开启钱箱",@"挂/取单据"];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
    [self  initString];
    
}


-(void)initString
{
    if (_tagNum == 900) {
        _string1 = self.setModel.POS_OrderPrintNum;
        _string2 = self.setModel.POS_PassWorkPrintNum;
        _string3 = self.setModel.POS_MemberReceiptPrintNum;
        _string4 = self.setModel.POS_ReceiptPrintNum;
        _string5 = self.setModel.POS_GiftPrintNum;
        _string6 = self.setModel.POS_CashBoxPrintNum;
        _string7 = self.setModel.POS_GuanDanPrintNum;
    }
    
    if (_tagNum == 901) {
        _string1 = self.setModel.POS_Ordertitle;
        _string2 = self.setModel.POS_PassWorkTitle;
        _string3 = self.setModel.POS_MemberReceiptTitle;
        _string4 = self.setModel.POS_ReceiptTitle;
        _string5 = self.setModel.POS_GiftTitle;
        _string6 = self.setModel.POS_CashBoxTitle;
        _string7 = self.setModel.POS_GuanDanTitle;
    }
}

-(void)initTableView
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-50-64) style:UITableViewStylePlain];
    _TableView.dataSource = self;
    _TableView.delegate = self;
    
    [_TableView registerNib:[UINib nibWithNibName:@"AddDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTableViewCell"];
    
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
            btn.tag = 703 +i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_footView addSubview:btn];
    }
    [self.view addSubview:_footView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.nameLable.text=_titleArray[indexPath.row];
    cell.nameLable.font = [UIFont systemFontOfSize:15];
            cell.inputText.delegate=self;
    if (_tagNum == 900) {
        cell.inputText.keyboardType = UIKeyboardTypeNumberPad;
    }
            cell.inputText.tag=indexPath.row+815;
    //cell.inputText.textAlignment = NSTextAlignmentLeft;
            [self swich:cell :indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
}
-(void)swich:(AddDetailTableViewCell*)cell :(NSInteger)index
{
    if (_tagNum == 900) {
        
        switch (index) {
            case 0:
            {
                //送单出品
                cell.inputText.text= self.string1;
                
            }
                break;
            case 1:
            {
                //交班日结
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string2;
            }
                break;
            case 2:
            {
                //会员结算
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string3;
            }
                break;
            case 3:
            {
                //普通结算
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string4;
                
            }
                break;
            case 4:
            {
                //押金小票
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string5;
                
            }
                break;
            case 5:
            {
                //开启钱箱
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string6;
                
            }
                break;
            case 6:
            {
                //挂/取单据
                //cell.inputText.text=arr[index];
                cell.inputText.text= self.string7;
            }
                break;
                
            default:
                break;
        }

    }
    
    if (_tagNum == 901) {
        
        
        switch (index) {
            case 0:
            {
                //送单出品
                cell.inputText.text=self.string1;
                
            }
                break;
            case 1:
            {
                //交班日结
                cell.inputText.text=self.string2;
            }
                break;
            case 2:
            {
                //会员结算
                cell.inputText.text=self.string3;
            }
                break;
            case 3:
            {
                //普通结算
                cell.inputText.text = self.string4;
                
            }
                break;
            case 4:
            {
                //押金小票
                cell.inputText.text=self.string5;
                
            }
                break;
            case 5:
            {
                //开启钱箱
                cell.inputText.text=self.string6;
                
            }
                break;
            case 6:
            {
                //挂/取单据
                cell.inputText.text=self.string7;
            }
                break;
                
            default:
                break;
        }

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}




-(void)btnClick:(UIButton *)btn
{
    UITextField *field1 = [self.view viewWithTag:815];
    UITextField *field2 = [self.view viewWithTag:816];
    UITextField *field3 = [self.view viewWithTag:817];
    UITextField *field4 = [self.view viewWithTag:818];
    UITextField *field5 = [self.view viewWithTag:819];
    UITextField *field6 = [self.view viewWithTag:820];
    UITextField *field7 = [self.view viewWithTag:821];
    //小票份数
    if (_tagNum == 900) {
        if (btn.tag == 703) {
            NSLog(@"保存设置....");
            if (field1.text.length==0||field2.text.length==0||field3.text.length==0||field4.text.length==0||field5.text.length==0||field6.text.length==0||field7.text.length==0){
                
                [self alertShowWithStr1:@"请完整输入设置"];
            }else
            {
                //提交并保存设置
                [SVProgressHUD showWithStatus:@"玩命加载中"];
                NSDictionary *jsonDic;
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"cms_commpara",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"POS_OrderPrintNum":field1.text,@"POS_PassWorkPrintNum":field2.text,@"POS_MemberReceiptPrintNum":field3.text,@"POS_ReceiptPrintNum":field4.text,@"POS_GiftPrintNum":field5.text,@"POS_CashBoxPrintNum":field6.text,@"POS_GuanDanPrintNum":field7.text,@"POS_OrderTitle":self.setModel.POS_Ordertitle,@"POS_PassWorkTitle":self.setModel.POS_PassWorkTitle,@"POS_MemberReceiptTitle":self.setModel.POS_MemberReceiptTitle,@"POS_ReceiptTitle":self.setModel.POS_ReceiptTitle,@"POS_GiftTitle":self.setModel.POS_GiftTitle,@"POS_CashBoxTitle":self.setModel.POS_CashBoxTitle,@"POS_GuanDanTitle":self.setModel.POS_GuanDanTitle,@"POS_SeatShowQty":self.setModel.POS_SeatShowQty,@"POS_SeatHeight":self.setModel.POS_SeatHeight,@"POS_SeatWidth":self.setModel.POS_SeatWidth,@"POS_BillHeight":self.setModel.POS_BillHeight,@"POS_BillWidth":self.setModel.POS_BillWidth,@"POS_GoodShowQty":self.setModel.POS_GoodShowQty,@"POS_SeatShowOtherQty":self.setModel.POS_SeatShowOtherQty,@"POS_RunModel":self.setModel.POS_RunModel,@"POS_RoomMode":self.setModel.POS_RoomMode,@"POS_SendBillMode":self.setModel.POS_SendBillMode,@"POS_PrintMode":self.setModel.POS_PrintMode,@"POS_CashBoxOpenWay":self.setModel.POS_CashBoxOpenWay}]};
                NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
                [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                    NSString *str=[JsonTools getNSString:responseObject];
                    if ([str isEqualToString:@"OK"])
                    {
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
                        //[self alertShowWithStr:@"请输入有效设置。。"];
                    }
                    
                } Faile:^(NSError *error) {
                    NSLog(@"失败%@",error);
                }];

                 [self.navigationController popViewControllerAnimated:YES];
            }
            
            
           
        }else
        {
            if (field1.text.length>0||field2.text.length>0||field3.text.length>0||field4.text.length>0||field5.text.length>0||field6.text.length>0||field7.text.length>0) {
                [self alertShowWithStr:@"是否取消录入信息"];
            }
        }
    }
    
    //小票页脚
    if (_tagNum == 901) {
        if (btn.tag == 703) {
            NSLog(@"提交设置...");
            if (field1.text.length==0||field2.text.length==0||field3.text.length==0||field4.text.length==0||field5.text.length==0||field6.text.length==0||field7.text.length==0){
                
                [self alertShowWithStr1:@"请完整输入设置"];
            }else{
            
                [SVProgressHUD showWithStatus:@"玩命加载中"];
                NSDictionary *jsonDic;
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"cms_commpara",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"POS_OrderPrintNum":self.setModel.POS_OrderPrintNum,@"POS_PassWorkPrintNum":self.setModel.POS_PassWorkPrintNum,@"POS_MemberReceiptPrintNum":self.setModel.POS_MemberReceiptPrintNum,@"POS_ReceiptPrintNum":self.setModel.POS_ReceiptPrintNum,@"POS_GiftPrintNum":self.setModel.POS_GiftPrintNum,@"POS_CashBoxPrintNum":self.setModel.POS_CashBoxPrintNum,@"POS_GuanDanPrintNum":self.setModel.POS_GuanDanPrintNum,@"POS_OrderTitle":field1.text,@"POS_PassWorkTitle":field2.text,@"POS_MemberReceiptTitle":field3.text,@"POS_ReceiptTitle":field4.text,@"POS_GiftTitle":field5.text,@"POS_CashBoxTitle":field6.text,@"POS_GuanDanTitle":field7.text,@"POS_SeatShowQty":self.setModel.POS_SeatShowQty,@"POS_SeatHeight":self.setModel.POS_SeatHeight,@"POS_SeatWidth":self.setModel.POS_SeatWidth,@"POS_BillHeight":self.setModel.POS_BillHeight,@"POS_BillWidth":self.setModel.POS_BillWidth,@"POS_GoodShowQty":self.setModel.POS_GoodShowQty,@"POS_SeatShowOtherQty":self.setModel.POS_SeatShowOtherQty,@"POS_RunModel":self.setModel.POS_RunModel,@"POS_RoomMode":self.setModel.POS_RoomMode,@"POS_SendBillMode":self.setModel.POS_SendBillMode,@"POS_PrintMode":self.setModel.POS_PrintMode,@"POS_CashBoxOpenWay":self.setModel.POS_CashBoxOpenWay}]};
                NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
                [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                    NSString *str=[JsonTools getNSString:responseObject];
                    if ([str isEqualToString:@"OK"])
                    {
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
                        //[self alertShowWithStr:@"请输入有效设置。。"];
                    }
                    
                } Faile:^(NSError *error) {
                    NSLog(@"失败%@",error);
                }];

            [self.navigationController popViewControllerAnimated:YES];
                
            }
        }else
        {
            if (field1.text.length>0||field2.text.length>0||field3.text.length>0||field4.text.length>0||field5.text.length>0||field6.text.length>0||field7.text.length>0) {
                [self alertShowWithStr:@"是否取消操作"];
            }
            
        }
    }
}

    
-(void)tapClick
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //if (screen_height == 568) {

    if (textField.tag == 821) {
    CGFloat offset = self.view.frame.size.height -58 - (260+textField.frame.size.height+216+20);
    NSLog(@"偏移高度为 --- %f",offset);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            //CGRect frame = self.view.frame;
            CGRect frame = self.TableView.frame;
            frame.origin.y = offset;
            //self.view.frame = frame;
            self.TableView.frame = frame;
        }];
    }
    }
    //}
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //if (screen_height == 568) {
    if (textField.tag == 821) {
//    [UIView animateWithDuration:0.3 animations:^{
//        //CGRect frame = self.view.frame;
//        CGRect frame = self.SView.frame;
//        frame.origin.y = 0.0;
//        //self.view.frame = frame;
//        self.SView.frame = frame;
//    }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.TableView.frame = CGRectMake(0, 64, self.TableView.frame.size.width,self.TableView.frame.size.height);
        }];
    }
    //}
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 815:
            self.string1 = textField.text;
            break;
        case 816:
            self.string2 = textField.text;
            break;
        case 817:
            self.string3 = textField.text;
            break;
            
        case 818:
            self.string4 = textField.text;
            break;
            
        case 819:
            self.string5 = textField.text;
            break;
            
        case 820:
            self.string6 = textField.text;
            break;
            
        case 821:
            self.string7 = textField.text;
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
