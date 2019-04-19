//
//  electronicScaleViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 秦根. All rights reserved.

#import "electronicScaleViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface electronicScaleViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,copy)NSString *IPAddress;//IP地址
@property(nonatomic,copy)NSString *sataus;//是否启用
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;

@end

@implementation electronicScaleViewController
-(void)setFinishBtn:(UIButton *)finishBtn
{
    _finishBtn=finishBtn;
    _finishBtn.backgroundColor=navigationBarColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.IPAddress = self.SModel.IPAddress;
        self.sataus = self.SModel.StartUsing;
    }else
    {
        self.sataus = @"False";
    }
    
    [self initUI];
}

-(void)initUI
{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _table.delegate = self;
    _table.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTableViewCell"];
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTwoTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
        
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        }
        
        cell.nameLable.text = @"IP地址";
        cell.nameLable.font = [UIFont systemFontOfSize:13];
        cell.nameLable.textAlignment = NSTextAlignmentCenter;
        
       [self getCellDataWithCell:cell index:indexPath.row];
        cell.inputText.delegate=self;
        cell.inputText.tag = indexPath.row;
        cell.inputText.placeholder = @"192.168.2.78";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        __weak typeof(self)weakSelf=self;
        
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"是否启用";
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.sataus isEqualToString:@"True"])
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
            
            weakSelf.sataus=str;
            NSLog(@"是否启用:%@",weakSelf.sataus);
            
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
            
            cell.inputText.text = self.IPAddress;
            
        }
            break;
            
        default:
            break;
    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 0:
            self.IPAddress = textField.text;
            break;
            
        default:
            break;
    }
}
- (IBAction)done:(id)sender {
    
    if (self.IPAddress.length==0) {
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
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POS_ScaleMachine",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"IP":self.IPAddress,@"status":self.sataus,@"ID":self.SModel.itemNo}]};
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
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POS_ScaleMachine",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"IP":self.IPAddress,@"status":self.sataus}]};
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
