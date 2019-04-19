//
//  TasteKindViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.

#import "TasteKindViewController.h"
//#import "AddClassifyViewController.h"
#import "TasteClassifyTableViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface TasteKindViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end

@implementation TasteKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    [self editOption];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
}
-(void)editOption
{
    _ClassifyList.tag = 300;
    _ClassifyList.delegate = self;
    _classifyName.delegate = self;
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.ClassifyList.text = self.tasteClassStr;
        self.classifyName.text = self.TasteKindModel.classifyName;
    }
}


-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)FinishBtnClick:(id)sender {
    if (_classifyName.text.length==0||_ClassifyList.text.length == 0) {
        [self alertShowWithStr:@"请输入必填信息"];
    }
//    else if (_thingsNumber == nil)
//    {
//        [self alertShowWithStr:@"请修改需选择项目"];
//    }
    else
    {
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }
    
}

-(void)addItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DC002":_classifyName.text,@"DC003":_thingsNumber}]};
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
    
    NSString *listString;
    if (_thingsNumber == nil) {
        listString = self.TasteKindModel.classifyList;
    }else
    {
        listString = _thingsNumber;
    }
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DC002":_classifyName.text,@"DC003":listString,@"DC001":self.TasteKindModel.itemNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
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


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 300){
//        AddClassifyViewController *add=[[AddClassifyViewController alloc]init];
//        add.backBlock = ^(ClassifyModel *model){
//            _ClassifyList.text = model.classifyName;
//        };
//        [self.navigationController pushViewController:add animated:YES];
        TasteClassifyTableViewController *TCVC = [[TasteClassifyTableViewController alloc] init];
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *arr1 = [NSMutableArray array];
        TCVC.backBlock = ^(NSMutableArray *selectArr){
            for (TasteClassifyModel *model in selectArr) {
                NSString *str = [NSString stringWithFormat:@"%@;",model.classifyName];
                NSString *str1 = [NSString stringWithFormat:@"%@;",model.classifyNo];
                [arr addObject:str];
                [arr1 addObject:str1];
            }
          NSString *listStr = [arr componentsJoinedByString:@""];
            NSString *listStr1 = [arr1 componentsJoinedByString:@""];
            _ClassifyList.text = listStr;
            _thingsNumber = listStr1;
        };
        TCVC.tagNum = 300;
        [self.navigationController pushViewController:TCVC animated:YES];
        return NO;
    }
    
    return YES;
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
