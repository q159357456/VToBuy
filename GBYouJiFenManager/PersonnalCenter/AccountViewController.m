//
//  AccountViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AccountViewController.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    /*定时器*/
    NSTimer *_timer;
    /*设定时间*/
    NSInteger _time;
    
    
}
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString *bankCode;
@property(nonatomic,copy)NSString *accountName;
@property(nonatomic,strong)UILabel *yanLable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end
@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.backgroundColor=MainColor;
    _doneButton.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
   
    [self getHead];
    // Do any additional setup after loading the view from its nib.
//    CMS_Shop
}
-(void)getHead
{
     MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",model.COMPANY,model.SHOPID];
    
    NSDictionary *dic=@{@"FromTableName":@"CMS_Shop",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
//    NSLog(@"－－－－－%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"－－－－－%@",dic1);
        if ([dic1[@"DataSet"][@"Table"][0][@"bank_check"] isEqualToString:@"True"])
        {
              _titleArray=@[@"开户行",@"银行卡号",@"开户人"];
            _doneButton.hidden=YES;
            self.bankCode=dic1[@"DataSet"][@"Table"][0][@"bank_account"];
             self.accountName=dic1[@"DataSet"][@"Table"][0][@"bank_user"];
              self.bankName=dic1[@"DataSet"][@"Table"][0][@"bank_name"];

        }else
        {
            _doneButton.hidden=NO;
             _titleArray=@[@"开户行",@"银行卡号",@"开户人",@"验证码"];
        }
  
        [self.tableview reloadData];
    } Faile:^(NSError *error) {
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self compareTime];
}
//视图即将消失时销毁定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer=nil;
    NSLog(@"定时器已销毁");
}
-(void)compareTime
{
    NSDate *sendDate=[[NSUserDefaults standardUserDefaults]objectForKey:@"AccountsendDate"];
    
    if (sendDate)
    {
        
        //获得当前时间
        NSDate *nowDate=[NSDate date];
        //两个时间相比较
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:sendDate toDate:nowDate options:0];
        NSInteger sencond =[comps second];//时间差
        //判断
        if (sencond>60)
        {
            
            _yanLable.hidden=NO;
            _yanLable.enabled=YES;
        }else
        {
            
            //启动计时器
//             _yanLable.backgroundColor=[UIColor lightGrayColor];
//            _yanLable.hidden=YES;
            _yanLable.enabled=NO;
            [self changeButtonSataWithTime:60-sencond];
        }
    }else
    {
        
        self.yanLable.hidden=NO;
    }
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
    cell.nameLable.text=_titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (self.bankName.length) {
                 cell.inputText.text=self.bankName;
                cell.inputText.enabled=NO;
            }
           
        }
            break;
        case 1:
        {
            if (self.bankCode.length) {
                 cell.inputText.text=self.bankCode;
                 cell.inputText.enabled=NO;
                
            }
            
        }
            break;
        case 2:
        {
            if (self.accountName.length) {
                cell.inputText.text=self.accountName;
                cell.inputText.enabled=NO;
            }
            
        }
            break;
       
    }
    if (indexPath.row==3) {
        cell.right.constant=100;
        [self addButton:cell];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)addButton:(AddDetailTableViewCell*)cell
{
   
    _yanLable=[[UILabel alloc]init];
    _yanLable.font=[UIFont systemFontOfSize:14];
     [cell addSubview:_yanLable];

    [_yanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right);
        make.top.mas_equalTo(cell.mas_top).offset(1);
        make.bottom.mas_equalTo(cell.mas_bottom).offset(-1);
        make.width.mas_equalTo(100);
        
    }];
    _yanLable.textAlignment=NSTextAlignmentCenter;
    _yanLable.backgroundColor=navigationBarColor;
    _yanLable.text=@"获取验证码";
    _yanLable.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1)];
    [self.yanLable addGestureRecognizer:singleTap1];

}
-(void)buttonpress1
{
    NSLog(@"点击获取验证码");
    [self SendMobileCode];
    
    
}
-(void)SendMobileCode
{
    [SVProgressHUD showWithStatus:@"加载中"];
     MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dic=@{@"FieldType":@"X",@"mobile":model.Mobile,@"temp_id":Temp_ID,@"appmode":@"2",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/SendMobileCode_New" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        NSArray *array=[str componentsSeparatedByString:@","];
        if (![array[0] isEqualToString:@"OK"])
        {
            _yanLable.enabled=YES;
            [self alertShowWithStr:@"短信发送失败"];
            
        }else
        {
            self.code=array[1];
            _yanLable.enabled=NO;
            //保存当前的时间
            NSDate *nowDate=[NSDate date];
            [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:@"AccountsendDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self changeButtonSataWithTime:60];
            [self alertShowWithStr:@"短信已经发送成功请等待"];
            
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
-(void)changeButtonSataWithTime:(NSInteger)second
{
    
    NSLog(@"设置定时器");
    _time=second;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(jishi) userInfo:nil repeats:YES];
    
}
-(void)jishi
{
    if (_yanLable.hidden) {
        _yanLable.hidden=NO;
    }
    _time--;
    if (_time==0)
    {
        self.yanLable.userInteractionEnabled=YES;
        _yanLable.text=@"获取验证码";
        _yanLable.textColor=[UIColor blackColor];
        _yanLable.backgroundColor=navigationBarColor;
        //销毁定时器
        [_timer invalidate];
        _timer=nil;
        
    }else
    {
        _yanLable.textColor=[UIColor lightGrayColor];
        _yanLable.text=[NSString stringWithFormat:@"%lds后重新获取",_time];
        _yanLable.backgroundColor=[UIColor lightGrayColor];
        _yanLable.userInteractionEnabled=NO;
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
- (IBAction)done:(UIButton *)sender
{
    if (self.code.length&&self.bankCode.length&&self.bankName.length&&self.accountName){
        
        UITextField *field=(UITextField*)[self.view viewWithTag:4];
        NSLog(@"%@",field.text);
        if ([field.text isEqualToString:self.code])
        {
            [self upAcountInfo];
        }else
        {
            [self alertShowWithStr:@"验证码错误"];
        }
        
    }else
    {
        [self alertShowWithStr:@"请填写完信息"];
    }
    
}
-(void)upAcountInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSDictionary *dic=@{@"company":model.COMPANY,@"shopid":model.SHOPID,@"bank_name":self.bankName,@"bank_account":self.bankCode,@"bank_user":self.accountName};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"MallService.asmx/SetBankAccount" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"false"])
        {
            [self alertShowWithStr:@"操作失败"];
        }else
        {
            [self alertShowWithStr:@"操作成功"];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 1:
        {
            self.bankName=textField.text;
        }
            break;
        case 2:
        {
             self.bankCode=textField.text;
        }
            break;
        case 3:
        {
             self.accountName=textField.text;
        }
            break;
        case 4:
        {
//             self.code=textField.text;
        }
            break;
            
        default:
            break;
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
