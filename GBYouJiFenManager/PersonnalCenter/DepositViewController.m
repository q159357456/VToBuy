//
//  DepositViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "DepositViewController.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ApplyDepViewController.h"
#import "AccountViewController.h"
#import "CoverView.h"
#import "TiXianView.h"
#import "NSString+addtion.h"
@interface DepositViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)TiXianView*tixianView;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)NSString* bank_account;
@property(nonatomic,copy)NSString*bank_name;
@property(nonatomic,strong)UILabel *bottomLable;
@end

@implementation DepositViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self GetShopAmount];
}
-(UILabel *)bottomLable
{
    if (!_bottomLable) {
        _bottomLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        _bottomLable.text=@"提现手续费率0.6%";
        _bottomLable.font=[UIFont systemFontOfSize:13];
        _bottomLable.textColor=[UIColor lightGrayColor];
    }
    return _bottomLable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.backgroundColor=MainColor;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableview.tableFooterView=self.bottomLable;
    [self addRightButton];
    _doneButton.enabled=NO;
    // Do any additional setup after loading the view from its nib.
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)commit
{
    ApplyDepViewController *aply=[[ApplyDepViewController alloc]init];
    aply.title=@"申请提现";
    [self.navigationController pushViewController:aply animated:YES];
}

-(void)GetShopAmount
{
    
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dic=@{@"company":model.COMPANY,@"shopid":model.SHOPID,@"mode":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"MallService.asmx/GetShopAmount" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        self.bank_account=dic1[@"DataSet"][@"Table"][0][@"bank_account"];
        self.bank_name=dic1[@"DataSet"][@"Table"][0][@"bank_name"];
        NSString *bank_user=dic1[@"DataSet"][@"Table"][0][@"bank_user"];
        if (self.bank_account.length&&self.bank_name.length&&bank_user.length)
        {
            self.dic=dic1;
            _doneButton.enabled=YES;
            [self.tableview reloadData];
        }else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"还没有设置提现账户,去设置?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1;
            
            action1=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *action2;
            
            action2=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                AccountViewController *acount=[[AccountViewController alloc]init];
                acount.title=@"提现账户";
                [self.navigationController pushViewController:acount animated:YES];
                
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
        
      
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    

}
-(void)getTixianViewWithDic:(NSDictionary*)dic
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    _coverView.frame=[UIScreen mainScreen].bounds;
    [window addSubview:_coverView];
    _tixianView=[[NSBundle mainBundle]loadNibNamed:@"TiXianView" owner:nil options:nil][0];
    _tixianView.frame=CGRectMake(30, self.view.centerY-296/2, screen_width-60, 296);
    [_coverView addSubview:_tixianView];
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
    
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)sendData:(UIButton *)sender
{
      UITextField *texfied=(UITextField*)[self.view viewWithTag:100];//提现金额
//      UITextField *texfied1=(UITextField*)[self.view viewWithTag:101];//提现中金额
     UITextField *texfied3=(UITextField*)[self.view viewWithTag:102];//账户中金额

 
    if (texfied.text.intValue>[texfied3.text zhuanhuan].floatValue)
    {
        [self alertShowWithStr:@"超过可提金额"];
    }else if (texfied.text.intValue<5)
    {
        [self alertShowWithStr:@"提现金额最少5元"];
    }
    else
    {
         [self tixian];
    }
}
-(void)tixian
{
     UITextField *texfied=(UITextField*)[self.view viewWithTag:100];//提现金额
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    
    NSDictionary *dic=@{@"company":model.COMPANY,@"shopid":model.SHOPID,@"mode":@"1",@"withdrawcash":texfied.text};
    //        NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"MallService.asmx/SendShopWithdrawData" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"false"])
        {
            [self alertShowWithStr:@"提现失败"];
        }else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"提现成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action;
            
            action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                texfied.text=@"";
                [self GetShopAmount];
            }];
            
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
#pragma mark--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)
    {
        return 4;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
    AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
            cell.nameLable.text=@"商户名称";
            cell.inputText.enabled=NO;
            cell.inputText.text=model.ShopName;
            
        }else if (indexPath.row==1)
        {
            cell.nameLable.text=@"账户余额";
             cell.inputText.enabled=NO;
            cell.inputText.text=self.dic[@"DataSet"][@"Table"][0][@"cash1"];
            
        }else if (indexPath.row==2)
        {
            cell.nameLable.text=@"提现中金额";
            cell.inputText.enabled=NO;
            cell.inputText.text=self.dic[@"DataSet"][@"Table"][0][@"cash2"];
            cell.inputText.tag=101;
        }
        else
        {
            cell.nameLable.text=@"可提余额";
             cell.inputText.enabled=NO;
            cell.inputText.text=self.dic[@"DataSet"][@"Table"][0][@"cash3"];
            cell.inputText.tag=102;
       
        }
        
    }else
    {
        cell.nameLable.text=@"提现金额";
        cell.inputText.tag=100;
        if (screen_width==320) {
            cell.inputText.font=[UIFont systemFontOfSize:15];
        }
        cell.inputText.placeholder=@"提现金额单笔不得小于5元";
        cell.inputText.keyboardType=UIKeyboardTypeNumberPad;
        cell.inputText.returnKeyType=UIReturnKeyDone;
    }
    
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
