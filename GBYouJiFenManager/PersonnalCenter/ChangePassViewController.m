//
//  ChangePassViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChangePassViewController.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface ChangePassViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)NSString *old;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *agin;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleArray=@[@"旧密码",@"新密码",@"确认密码"];
    _doneButton.backgroundColor=MainColor;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
    AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
    }
    cell.inputText.delegate=self;
    cell.inputText.tag=indexPath.row+1;
    cell.inputText.textAlignment=NSTextAlignmentLeft;
    cell.nameLable.text=_titleArray[indexPath.row];
    cell.inputText.secureTextEntry=YES;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            //旧密码
            self.old=textField.text;
        }
            break;
        case 2:
        {
            //新密码
            self.password=textField.text;
            
        }
            break;
        case 3:
        {
            //确认密码
            self.agin=textField.text;
            
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)done:(UIButton *)sender {
    if (self.old.length&&self.agin.length&&self.password.length)
    {
        if ([self.password isEqualToString:self.agin])
        {
             MemberModel *model= [[FMDBMember shareInstance]getMemberData][0];
//             NSLog(@"%@",model.Mobile);
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *dic=@{@"FieldType":@"S",@"FieldValue":model.Mobile,@"oldPassword":self.old,@"newPassword":self.password};
            [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/RePassword" With:dic and:^(id responseObject) {
                [SVProgressHUD dismiss];
                NSString *str=[JsonTools getNSString:responseObject];
                if ([str isEqualToString:@"false"])
                {
                    [self alertShowWithStr:@"旧密码错误"];
                }else
                {
                    [self alertShowWithStr:@"修改成功"];
                }
                
            } Faile:^(NSError *error) {
                NSLog(@"失败%@",error);
            }];
            
        }else
        {
            [self alertShowWithStr:@"两次输入密码不一致"];
        }
    }else
    {
        [self alertShowWithStr:@"不能为空"];
    }
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
  
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
