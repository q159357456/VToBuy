//
//  discountOperationViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "discountOperationViewController.h"
#import "ChooseTypeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface discountOperationViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@end

@implementation discountOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    [self initTextField];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
}

-(void)initTextField
{
    if ([_chooseType isEqualToString:@"Edit"]) {
        _dName.text = _disModel.discountName;
        _dType.text = _discountName;
        _dAppoint.text = _disModel.appointDiscount;
        _dPrint.text = _disModel.printDiscount;
        _dMoney.text = _disModel.discountMoney;
    }
    self.dName.delegate = self;
    self.dName.font = [UIFont systemFontOfSize:10];
    self.dName.tag = 401;
    self.dType.delegate = self;
    self.dType.font = [UIFont systemFontOfSize:10];
    self.dType.tag = 402;
    self.dMoney.delegate = self;
    self.dMoney.font = [UIFont systemFontOfSize:10];
    self.dMoney.tag = 405;
    self.dAppoint.delegate = self;
    self.dAppoint.font = [UIFont systemFontOfSize:10];
    self.dAppoint.tag = 403;
    self.dPrint.delegate = self;
    self.dPrint.font = [UIFont systemFontOfSize:10];
    self.dPrint.tag = 404;
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)finishBtnClick:(id)sender {
    
    if (_dName.text.length == 0||_dType.text.length==0) {
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
    NSString *stringNo;
    if (_discountItemNo==nil) {
        stringNo = self.disModel.discountType;
    }else
    {
        stringNo = _discountItemNo;
    }
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *jsonDic;
 jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DS002":_dName.text,@"DS003":stringNo,@"DS004":_dAppoint.text,@"DS005":_dPrint.text,@"DS006":_dMoney.text,@"DS001":self.disModel.itemNo}]};
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
            [self alertShowWithStr:str];
        }
    
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)addItem
{
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DS002":_dName.text,@"DS003":_discountItemNo,@"DS004":_dAppoint.text,@"DS005":_dPrint.text,@"DS006":_dMoney.text}]};
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==401) {
        return YES;
    }
     if (textField.tag == 402) {
         if ([_chooseType isEqualToString:@"Edit"]) {
             NSLog(@"此处折扣类型不可更改");
             [self alertShowWithStr:@"折扣类型不可修改"];
         }else{
         ChooseTypeViewController *CTVC = [[ChooseTypeViewController alloc] init];
         CTVC.title = @"选择折扣类型";
         CTVC.tagNumber = 402;
         CTVC.backBlock3 = ^(discountClassifyModel *model){
             _dType.text = model.VarDisPlay;
             _disClassModel.VarValue = model.VarValue;
             _disClassModel = model;
             _discountItemNo = model.VarValue;
         };
         [self.navigationController pushViewController:CTVC animated:YES];
         return NO;
         }
     }
    if ([_chooseType isEqualToString:@"Add"]) {
        if (textField.tag==403||textField.tag==404||textField.tag== 405) {
            if (_disClassModel.VarValue.length>0) {
                if (textField.tag==403) {
                    if ([_disClassModel.VarValue isEqualToString:@"1"]) {
                        self.dPrint.text = @"0";
                        self.dMoney.text = @"0";
                        return YES;
                    }
                    else
                    {
                        [self alertShowWithStr:@"此类型不可输入,默认值为0"];
                    }
                }else if (textField.tag == 404){
                    if ([_disClassModel.VarValue isEqualToString:@"2"]) {
                        _dAppoint.text = @"0";
                        _dMoney.text = @"0";
                        return YES;
                    }
                    else
                    {
                        [self alertShowWithStr:@"此类型不可输入,默认值为0"];
                    }
                }else if (textField.tag == 405)
                {
                    if ([_disClassModel.VarValue isEqualToString:@"3"]) {
                        _dAppoint.text = @"0";
                        _dPrint.text = @"0";
                        return YES;
                    }
                    else
                    {
                        [self alertShowWithStr:@"此类型不可输入,默认值为0"];
                    }
                }
                
            }else
            {
                [self alertShowWithStr:@"请选择折扣类型"];
            }
        }

    }
    
    if ([_chooseType isEqualToString:@"Edit"]) {
        if ([self.disModel.discountType isEqualToString:@"1"]&&textField.tag == 403) {
            return YES;
        }
        if ([self.disModel.discountType isEqualToString:@"2"]&&textField.tag == 404) {
            return YES;
        }
        if ([self.disModel.discountType isEqualToString:@"3"]&&textField.tag == 405) {
            return YES;
        }

    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
