//
//  InternalRegisterViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "InternalRegisterViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ChooseTypeViewController.h"
@interface InternalRegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
/*
 上传参数

@property(nonatomic,copy)NSString *posNum;
@property(nonatomic,copy)NSString *equipName;

 */
@end

@implementation InternalRegisterViewController
-(void)setFinishBtn:(UIButton *)finishBtn
{
    _finishBtn=finishBtn;
    _finishBtn.backgroundColor=navigationBarColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    
    [self editOption];
    
    self.roomName.delegate = self;
    self.equipmentName.delegate = self;
    self.equipmentName.tag = 203;
    self.roomName.tag = 204;
}

-(void)editOption
{
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.string = self.internalModel.roomName;
        self.roomName.text = self.roomStr;
        self.equipmentName.text = self.internalModel.equipmentName;
    }else{
    self.roomName.text = @"--请选择房台--";
    }
}
//
-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)FinishBtnClick:(id)sender{
    
    if (_string.length==0||self.equipmentName.text.length == 0) {
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
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDV",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DV002":_equipmentName.text,@"DV006":_string}]};
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
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDV",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DV006":_roomName.text,@"DV002":_equipmentName.text,@"DV001":self.internalModel.itemNo}]};
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
    switch (textField.tag) {
        case 204:
        {
            //房台名称
            ChooseTypeViewController *chooseVC = [[ChooseTypeViewController alloc] init];
            chooseVC.chooseType = @"chooseType";
            chooseVC.title = @"选择房台";
            
            chooseVC.tagNumber = 204;
            chooseVC.backBlock4 = ^(roomDataModel *rdModel) {
                _roomName.text = rdModel.roomName;
               _string = rdModel.itemNo;
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
