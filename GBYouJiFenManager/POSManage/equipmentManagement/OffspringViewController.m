
//  OffspringViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 xia. All rights reserved.

#import "OffspringViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "TasteClassifyTableViewController.h"

@interface OffspringViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@end

@implementation OffspringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    
    [self editOption];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
}
-(void)setDone:(UIButton *)done
{
    _done=done;
    _done.backgroundColor=navigationBarColor;
}
-(void)editOption
{
    if ([self.chooseType isEqualToString:@"Edit"]) {
        
        _printName.text = self.OffSPModel.PrinterName;
        _printIP.text = self.OffSPModel.PrinterIP;
        _ClassList.text = self.tasteClassStr;
    }
    
    _printName.delegate = self;
    _printIP.delegate = self;
    _ClassList.delegate = self;
    
    _ClassList.tag = 918;
}

- (IBAction)doneClick:(id)sender {
    if (_printName.text.length==0||_printIP.text.length == 0 ||[_ClassList.text isEqualToString:@"--请选择大类--"]) {
        [self alertShowWithStr:@"请输入必填信息"];
    }else{
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }

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
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSPS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"PS002":_printName.text,@"PS004":_printIP.text,@"PS007":_thingsNumber}]};
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
    NSString *listString;
    if (_thingsNumber == nil) {
        listString = self.OffSPModel.BigClasses;
    }else
    {
        listString = _thingsNumber;
    }

    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSPS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"PS002":_printName.text,@"PS004":_printIP.text,@"PS007":_ClassList.text,@"PS001":self.OffSPModel.itemNo}]};
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


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 918){
        
        TasteClassifyTableViewController *TCVC = [[TasteClassifyTableViewController alloc] init];
        TCVC.tagNum = 918;
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *arr1 = [NSMutableArray array];
        TCVC.backBlock = ^(NSArray *selectArr){
            for (TasteClassifyModel *model in selectArr) {
                NSString *str = [NSString stringWithFormat:@"%@;",model.classifyName];
                NSString *str1 = [NSString stringWithFormat:@"%@;",model.classifyNo];
                [arr addObject:str];
                [arr1 addObject:str1];
            }
            NSString *listStr = [arr componentsJoinedByString:@""];
            NSString *listStr1 = [arr1 componentsJoinedByString:@""];
            _ClassList.text = listStr;
            _thingsNumber = listStr1;
        };
        [self.navigationController pushViewController:TCVC animated:YES];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
