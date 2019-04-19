//
//  AddFullViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/17.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddFullViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddFullViewController.h"
#import "ChooseTableViewCell.h"
#import "AddClipOneTableViewCell.h"
#import "AddClipTwoTableViewCell.h"
#import "FullCutTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"

@interface AddFullViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIView *PickerView;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,assign)NSInteger pickStyle;
@property(nonatomic,assign)BOOL is;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

/**
 canshu
 */
@property(nonatomic,copy)NSString *Amount1;
@property(nonatomic,copy)NSString *Amount2;
@property(nonatomic,copy)NSString *StartDate;
@property(nonatomic,copy)NSString *EndDate;
@property(nonatomic,copy)NSString *StartTime;
@property(nonatomic,copy)NSString *EndDTime;
@property(nonatomic,copy)NSString *LimitQuantity;
@end

@implementation AddFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=MainColor;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            //基本信息
            ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
            cell.contentLable.text=@"基本信息";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 1:
        {
            //满减面额
            AddClipOneTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddClipOneTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textone.tag=1;
            cell.textTwo.tag=2;
            cell.textTwo.delegate=self;
            cell.textone.delegate=self;
            cell.textone.tag=5;
            cell.textTwo.tag=6;
            return cell;
        }
            break;
        case 2:
        {
            //发行数量
            AddDetailTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.right.constant=screen_width-250+32;
            cell.nameWidth.constant=74;
            cell.nameLable.text=@"发行数量";
            [self addLable:cell];
            cell.inputText.tag=7;
            cell.inputText.delegate=self;
            return cell;
        }
            break;
        case 3:
        {
            //有效期限
            FullCutTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"FullCutTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.lable1.text=@"开始日期";
            cell.lable2.text=@"时间";
            cell.text1.delegate=self;
             cell.text2.delegate=self;
            cell.text1.placeholder=@"选择日期";
            cell.text1.tag=1;
            cell.text2.tag=2;
            cell.text2.placeholder=@"选择时间";
            return cell;
          
            
            
        }
            break;
        case 4:
        {
            //有效期限
            FullCutTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"FullCutTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.lable1.text=@"结束日期";
            cell.lable2.text=@"时间";
            cell.text1.placeholder=@"选择日期";
            cell.text2.placeholder=@"选择时间";
            cell.text1.tag=3;
            cell.text2.tag=4;
            cell.text1.delegate=self;
            cell.text2.delegate=self;
            return cell;
            
            
            
        }
            break;

            
        default:
            break;
    }
    
    return nil;
    
}
-(void)addLable:(AddDetailTableViewCell*)cell
{
    UILabel *lable=[[UILabel alloc]init];
    lable.text=@"张";
    lable.font=[UIFont systemFontOfSize:15];
    lable.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right).offset(250-screen_width);
        make.top.mas_equalTo(cell.mas_top);
        make.bottom.mas_equalTo(cell.mas_bottom);
        make.width.mas_equalTo(32);
    }];
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
//
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 5:
        {
            self.Amount1=textField.text;
        }
            break;
        case 6:
        {
                  self.Amount2=textField.text;
        }
            break;
        case 7:
        {
            self.LimitQuantity=textField.text;
        }
            break;

            
        default:
            break;
    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            //开始
            self.pickStyle=1;
            _is=YES;
            [self pickView];
            return NO;
        }
            break;
        case 2:
        {
            self.pickStyle=2;
            _is=YES;
            [self pickView];
            return NO;
            
        }
            break;
        case 3:
        {
            //结束
            self.pickStyle=1;
            _is=NO;
            [self pickView];
            return NO;
        }
            break;
        case 4:
        {
            self.pickStyle=2;
            _is=NO;
            [self pickView];
            return NO;
        }
            break;
            
        default:
            break;
    }

    return YES;
}
//
-(void)pickView
{
    [self createCover];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    
    //UIDatePicker显示样式
    if (_pickStyle==1)
    {
         _datePicker.datePickerMode = UIDatePickerModeDate;
        
    }else
    {
            _datePicker.datePickerMode =UIDatePickerModeTime;
        
        
            [_datePicker setLocale:[NSLocale systemLocale]];
    }


    
    
    _datePicker.minuteInterval = 1;
    
    [_PickerView addSubview:_datePicker];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *defaultDate = [NSDate date];
    //    [NSDate dateWithTimeIntervalSince1970:[@"1460598080"doubleValue]];
    
    _datePicker.date = defaultDate;//设置UIDatePicker默认显示时间
    
    
}
-(void)createCover
{
    [self hideEdit];
    _coverView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor=[UIColor blackColor];
    _coverView.alpha=0.3;
    [self.view.window addSubview:_coverView];
    _PickerView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250)];
    _PickerView.backgroundColor=[UIColor whiteColor];
    [self.view.window addSubview:_PickerView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancel.frame = CGRectMake(10, 5, 40, 40);
    
    [cancel setTitle:@"取消"forState:UIControlStateNormal];
    
    [_PickerView addSubview:cancel];
    
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    commit.frame = CGRectMake(self.view.frame.size.width-50, 5, 40, 40);
    
    [commit setTitle:@"确定"forState:UIControlStateNormal];
    
    [_PickerView addSubview:commit];
    
    [commit addTarget:self action:@selector(commitB) forControlEvents:UIControlEventTouchUpInside];
}
-(void)hideEdit
{
    
    [self.view endEditing:YES];
}
-(void)commitB{
    
    
    if (_datePicker) {
         NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        
        if (_pickStyle==1)
        {
            [forma setDateFormat:@"YYYY-MM-dd"];
              NSString *str = [forma stringFromDate:_datePicker.date];
          
            if (_is)
            {
                UITextField  *text=(UITextField*)[self.view viewWithTag:1];
                text.text=str;
                self.StartDate=str;
                
            }else
            {
                UITextField  *text=(UITextField*)[self.view viewWithTag:3];
                text.text=str;
                self.EndDate=str;
            }
            
        }else
        {
            [forma setDateFormat:@"HH:mm"];
            NSString *str = [forma stringFromDate:_datePicker.date];
            NSLog(@"%@",str);
            NSMutableString *newStr=[NSMutableString stringWithString:str];
            
            [newStr appendString:@":00"];
            if (_is)
            {
                UITextField  *text=(UITextField*)[self.view viewWithTag:2];
                text.text=newStr;
                self.StartTime=newStr;
            }else
            {
                UITextField  *text=(UITextField*)[self.view viewWithTag:4];
                text.text=newStr;
                self.EndDTime=newStr;
            }
        }
   
       
        
    
       //UIDatePicker显示的时间
   
//        NSLog(@"%@",str);
//        
   

        
        
    }
    
    [self cancel];
    
}
-(void)cancel
{
  
    [_datePicker removeFromSuperview];
    [_PickerView removeFromSuperview];
    [_coverView removeFromSuperview];
}
- (IBAction)done:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableString *start=[NSMutableString stringWithString:_StartDate];
    [start appendString:[NSString stringWithFormat:@" %@",_StartTime]];
    NSMutableString *end=[NSMutableString stringWithString:_EndDate];
    [end appendString:[NSString stringWithFormat:@" %@",_EndDTime]];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"SALES_Fullcut",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Amount1":self.Amount1,@"Amount2":self.Amount2,@"Quantity1":self.LimitQuantity,@"StartDate":start,@"EndDate":end}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
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
