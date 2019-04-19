//
//  RechargeViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "RechargeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface RechargeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    
    [self editOption];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];

    
}
- (IBAction)doneClick:(id)sender {
    
    if (_rechargeMoney.text.length==0) {
        [self alertShowWithStr:@"请输入充值金额"];
    }else{
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }

}

-(void)editOption
{
    self.rechargeMoney.keyboardType = UIKeyboardTypeDecimalPad;
    self.presentMoney.keyboardType = UIKeyboardTypeDecimalPad;
    self.scores.keyboardType = UIKeyboardTypeDecimalPad;
    if ([self.chooseType isEqualToString:@"Edit"]) {
        
        NSArray *arr = [self.ChargeModel.CashNumber componentsSeparatedByString:@","];
        NSString *str = [arr componentsJoinedByString:@""];
        
        NSArray *arr1 = [self.ChargeModel.PresentNumber componentsSeparatedByString:@","];
        NSString *str1 = [arr1 componentsJoinedByString:@""];
        
        NSArray *arr2 = [self.ChargeModel.CreditsScore componentsSeparatedByString:@","];
        NSString *str2 = [arr2 componentsJoinedByString:@""];

        _rechargeMoney.text = str;
        _presentMoney.text = str1;
        _scores.text = str2;
    }
    
    _rechargeMoney.delegate = self;
    _presentMoney.delegate = self;
    _scores.delegate = self;
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)addItem
{
    if (self.presentMoney.text.length == 0) {
        self.presentMoney.text = @"0";
    }
    if (self.scores.text.length == 0) {
        self.scores.text = @"0";
    }
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"CRMMBR",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"MBR001":_rechargeMoney.text,@"MBR002":_presentMoney.text,@"MBR003":_scores.text}]};
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
-(void)editItem
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"CRMMBR",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"MBR001":_rechargeMoney.text,@"MBR002":_presentMoney.text,@"MBR003":_scores.text,@"MBR000":self.ChargeModel.itemNo}]};
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
    // Dispose of any resources that can be recreated.
}


@end
