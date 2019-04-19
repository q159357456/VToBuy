
//  FloorInfoViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "FloorInfoViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface FloorInfoViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@end

@implementation FloorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    [self editOption];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    

}

-(void)editOption
{
    if (_numberOfTag == 102) {
        self.nameLabel.text = @"楼层区域*:";
    }
    if (_numberOfTag == 110) {
        self.nameLabel.text = @"配送时间:";
        self.FInfo.placeholder = @"12:00";
    }
    
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        if (_numberOfTag == 102) {
            self.FInfo.text = self.FLModel.FloorInfo;
        }
        if (_numberOfTag == 110) {
            self.FInfo.text = self.deliModel.deliveryTime;
        }
        
    }
    self.FInfo.delegate = self;
}


-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)FinishBtnClick:(id)sender{
    
    if (_FInfo.text.length==0) {
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


-(void)addItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    if (_numberOfTag==102) {
        jsonDic=@{ @"Command":@"Add",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":_FInfo.text}]};
    }
        if (_numberOfTag == 110){
            jsonDic=@{ @"Command":@"Add",@"TableName":@"POSSTT1",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":_FInfo.text}]};
        }
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
    if (_numberOfTag == 102) {
        jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":_FInfo.text,@"AF001":self.FLModel.itemNo}]};
    }
        if (_numberOfTag == 110){
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSSTT1",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":_FInfo.text,@"STT001":self.deliModel.itemNo}]};
        }
    
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
    
}


@end
