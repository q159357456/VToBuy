//
//  ReserveDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ReserveDetailViewController.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface ReserveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)NSString *contrct;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *detail;
@end

@implementation ReserveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"预定时间",@"台号",@"联系人",@"联系电话",@"人数",@"备注"];
    _doneButton.backgroundColor=MainColor;
    
    // Do any additional setup after loading the view from its nib.
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleArray.count;;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    static NSString *cellid=@"AddDetailTableViewCell";
    AddDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        
    }
        cell.nameLable.text=_titleArray[indexPath.row];
    if (_tmoel)
    {
        cell.inputText.enabled=NO;
        [self getCellDataWithCell:cell index:indexPath.row];
        
    }else
    {
        if (indexPath.row==0) {
            cell.inputText.text=_timeStr;
        }else if (indexPath.row==1)
        {
            cell.inputText.text=_model.SI002;
        }else
        {
            cell.inputText.textColor=[UIColor blackColor];
        }
        if (indexPath.row==3||indexPath.row==4) {
            cell.inputText.keyboardType=UIKeyboardTypeNumberPad;
        }
   
        cell.inputText.tag=indexPath.row+1;
        cell.inputText.delegate=self;
 
    }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
  
    return cell;
    
    
    
}
-(void)getCellDataWithCell:(AddDetailTableViewCell*)cell index:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            cell.inputText.text=_tmoel.STS003;
        }
            break;
        case 1:
        {
              cell.inputText.text=_tmoel.STS010;
        }
            break;
        case 2:
        {
             cell.inputText.text=_tmoel.STS008;
        }
            break;
        case 3:
        {
              cell.inputText.text=_tmoel.STS007;
        }
            break;
        case 4:
        {
              cell.inputText.text=_tmoel.STS009;
        }
            break;
        case 5:
        {
              cell.inputText.text=_tmoel.STS012;
        }
            break;
            
        default:
            break;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
//
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            return NO;
        }
            break;
        case 2:
        {
            return NO;
            
        }
            break;
            
        default:
            break;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 3:
        {
           //联系人
            self.contrct=textField.text;
            
        }
            break;
        case 4:
        {
           //联系电话
            self.phone=textField.text;
            
        }
            break;
        case 5:
        {
            
            //人数
            self.count=textField.text;
        }
            break;
        case 6:
        {
            //备注
            self.detail=textField.text;
            
        }
            break;
    }
    

    
}
- (IBAction)doen:(UIButton *)sender
{
    if (_count.length&&_phone.length&&_contrct.length)
    {
        if (!_detail.length) {
            _detail=@"";
        }
        MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
        NSArray *possbJsonArray=@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"SB001":PC01,@"SB005":_model.SI001,@"SB009":_count}];
        NSArray *posstsJsonArray=@[@{@"STS003":_timeStr,@"STS007":_phone,@"STS008":_contrct,@"STS009":_count,@"STS010":_model.SI001,@"STS012":_detail}];
        //生成预订信息
        NSData *data1=[NSJSONSerialization dataWithJSONObject:possbJsonArray options:kNilOptions error:nil];
        NSData *data2=[NSJSONSerialization dataWithJSONObject:posstsJsonArray options:kNilOptions error:nil];
        NSString *possbJsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSString *posstsJsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",possbJsonStr);
        NSLog(@"%@",posstsJsonStr);
        NSDictionary *dic=@{@"possbJson":possbJsonStr,@"posstsJson":posstsJsonStr,@"CipherText":CIPHERTEXT};
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:@"加载中"];
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"posservice.asmx/CreatePreOrderBill" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSString *str=[JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"true"])
            {
                [SVProgressHUD showSuccessWithStatus:@"预订成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    //通知中心
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"yuDingSuccess" object:nil userInfo:nil];
                    NSArray *controArray=self.navigationController.viewControllers;
                    [self.navigationController popToViewController:controArray[1] animated:YES];
                    
                });

            }else
            {
                [self alertShowWithStr:@"预订失败"];
            }
            
            
        } Faile:^(NSError *error)
         {
             NSLog(@"错误%@",error);
         }];

        
    }else
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请填写完资料"];
    }

    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
