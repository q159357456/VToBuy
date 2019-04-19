//
//  TasteRequestViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "TasteRequestViewController.h"
#import "ChooseTypeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface TasteRequestViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation TasteRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    [self editOption];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
}


-(void)editOption
{
    _tasteClasses.tag = 301;
    _tasteClasses.delegate = self;
    _tasteName.delegate = self;
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.tasteNumber.text = self.TRequestModel.tasteNumber;
        self.tasteName.text = self.TRequestModel.tasteName;
        self.tasteClasses.text = self.tasteClassStr;
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
    if (_tasteName.text.length==0||_tasteClasses.text.length == 0) {
        [self alertShowWithStr:@"请输入必填信息"];
    }
//    else if (_str == nil)
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
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DI002":_tasteName.text,@"DI003":_str,@"DI008":_tasteNumber.text}]};
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
    NSString *classStr;
    
    if (_str==nil) {
        classStr = self.TRequestModel.tasteClasses;
    }else
    {
        classStr = _str;
    }
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DI002":self.tasteName.text,@"DI003":classStr,@"DI008":self.tasteNumber.text,@"DI001":self.TRequestModel.itemNo}]};
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 301) {
        ChooseTypeViewController *chooseVC = [[ChooseTypeViewController alloc] init];
        chooseVC.chooseType = @"chooseType";
        chooseVC.title = @"选择口味分类";
        //__weak typeof(self)weakSelf = self;
        chooseVC.tagNumber = 301;
        chooseVC.backBlock2 = ^(TasteKindModel *tmodel){
            _tasteClasses.text = tmodel.classifyName;
            _str = tmodel.itemNo;
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
     
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

//MAC地址

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
