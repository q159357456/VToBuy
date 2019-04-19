//
//  AddClipViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddClipViewController.h"
#import "AddClipOneTableViewCell.h"
#import "AddClipTwoTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "AddDetailTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "ZWHCouponTypeTableViewCell.h"
#import "ZWHSharesModel.h"


@interface AddClipViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIView *PickerView;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,assign)BOOL is;


/**
 参数
 */
@property(nonatomic,copy)NSString *Amount1;
@property(nonatomic,copy)NSString *Amount2;
@property(nonatomic,copy)NSString *Quantity1;
@property(nonatomic,copy)NSString *LimitQuantity;
@property(nonatomic,copy)NSString *StartDate;
@property(nonatomic,copy)NSString *EndDate;
@property(nonatomic,strong) UIPickerView *myPicker;
@property(nonatomic,assign)BOOL isVip;

@property(nonatomic,strong)NSString *shareholderId;

@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation AddClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerClass:[ZWHCouponTypeTableViewCell class] forCellReuseIdentifier:@"ZWHCouponTypeTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=MainColor;
    
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
            //卡券面额
            AddClipOneTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddClipOneTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textone.tag=1;
            cell.textTwo.tag=2;
            cell.textTwo.delegate=self;
            cell.textone.delegate=self;
            cell.textone.keyboardType = UIKeyboardTypeNumberPad;
            cell.textTwo.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
        }
            break;
        case 2:
        {
            //卡券数量
            AddDetailTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            cell.nameLable.text=@"卡券数量";
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.right.constant=screen_width-250+32;
            cell.nameWidth.constant=74;
            [self addLable:cell];
            cell.inputText.tag=3;
             cell.inputText.delegate=self;
            cell.inputText.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
            
        }
            break;
        case 3:
        {
            //卡券限制328
            AddDetailTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            cell.nameLable.text=@"卡券限制";
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.right.constant=screen_width-250+32;
             cell.nameWidth.constant=74;
            [self addLable:cell];
            cell.inputText.tag=4;
            cell.inputText.delegate=self;
            cell.inputText.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
            
        }
            break;
        case 4:
        {
            //有效期限
            AddClipTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddClipTwoTableViewCell" owner:nil options:nil][0];
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.endData.tag=6;
            cell.startData.tag=5;
            cell.endData.delegate=self;
            cell.startData.delegate=self;
            return cell;
            
        }
            break;
        case 5:
        {
            ZWHCouponTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHCouponTypeTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.normalBtn.tag = 10;
            cell.vipBtn.tag = 20;
            [cell.normalBtn addTarget:self action:@selector(chooseCouponTypeWith:) forControlEvents:UIControlEventTouchUpInside];
            [cell.vipBtn addTarget:self action:@selector(chooseCouponTypeWith:) forControlEvents:UIControlEventTouchUpInside];
            [cell.normalBtn setImage:_isVip?[UIImage imageNamed:@"payType_1"]:[UIImage imageNamed:@"payType_2"] forState:0];
            [cell.vipBtn setImage:_isVip?[UIImage imageNamed:@"payType_2"]:[UIImage imageNamed:@"payType_1"] forState:0];
            [cell.shareholder addTarget:self action:@selector(chooseShareholderWith:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
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


#pragma mark - 选择类型 股东列表
-(void)chooseCouponTypeWith:(QMUIButton *)btn{
    _isVip = btn.tag==10?NO:YES;
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)chooseShareholderWith:(QMUIButton *)btn{
    
    if (_isVip==NO) {
        [QMUITips showInfo:@"普通券不用选择股东"];
        return;
    }
    
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    _dataArray = [NSMutableArray array];
    NSDictionary *dict = @{@"shopid":model.SHOPID,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dict);
    [SVProgressHUD showWithStatus:@""];
    _dataArray = [NSMutableArray array];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/ShopPartnerList" With:dict and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic =[JsonTools getData:responseObject];
        if ([dic[@"message"] isEqualToString:@"OK"]) {
            [weakSelf.dataArray addObjectsFromArray:[ZWHSharesModel mj_objectArrayWithKeyValuesArray:dic[@"DataSet"][@"Table"]]];
            NSMutableArray *titleArr = [NSMutableArray array];
            if (weakSelf.dataArray.count>0) {
                for (ZWHSharesModel *shareModel in weakSelf.dataArray) {
                    [titleArr addObject:shareModel.MemberName];
                }
                
                QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
                dialogViewController.title = @"选择股东";
                dialogViewController.items = titleArr;
                [dialogViewController addCancelButtonWithText:@"取消" block:nil];
                [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
                    QMUIDialogSelectionViewController *d = (QMUIDialogSelectionViewController *)aDialogViewController;
                    if (d.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
                        [QMUITips showError:@"请至少选一个" inView:d.qmui_modalPresentationViewController.view hideAfterDelay:1.2];
                        return;
                    }
                    ZWHSharesModel *shamodel = weakSelf.dataArray[d.selectedItemIndex];
                    [btn setTitle:shamodel.MemberName forState:0];
                    weakSelf.shareholderId = shamodel.MemberID;
                    [aDialogViewController hide];
                }];
                [dialogViewController show];
            }else{
                [QMUITips showInfo:@"暂无股东"];
            }
        }else{
            [QMUITips showInfo:@"暂无股东"];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}



#pragma mark - uitableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}
#pragma mark--textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 5:
        {
           //开始日期
            _is=YES;
            [self pickView];
            
            return NO;
        }
            break;
        case 6:
        {
            //结束日期
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            //卡券面额1
            self.Amount1=textField.text;
            
        }
            break;
        case 2:
        {
            //卡券面额2
            self.Amount2=textField.text;
            
        }
            break;
        case 3:
        {
            //卡券数量
            self.Quantity1=textField.text;
            
            
        }
            break;
        case 4:
        {
            //卡券限制
            self.LimitQuantity=textField.text;
            
            
        }
            break;
            
        default:
            break;
    }
  

    
}

#pragma mark--chooser
-(void)chooser
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         
//                         self.myPicker.hidden = YES;
//                         self.myToolbar.hidden = YES;
//                         if (_isSex) {
//                             
//                             self.sex=[sexArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
//                             
//                             [self.tableview reloadData];
//                         }
//                         else{
//                             
//                             self.birthDay=[NSString stringWithFormat:@"%@/%@/%@ ",[yearArray objectAtIndex:[self.myPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.myPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.myPicker selectedRowInComponent:2]]];
//                             
//                             [self.tableview reloadData];
                         
//                             
//                         }
//                         _isSex=NO;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];

}
-(void)pickView
{
    [self createCover];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    
    //UIDatePicker显示样式
    
    _datePicker.datePickerMode =UIDatePickerModeDate;
    
    
    [_datePicker setLocale:[NSLocale systemLocale]];
    _datePicker.minuteInterval = 1;
    
    [_PickerView addSubview:_datePicker];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *defaultDate = [NSDate date];

    
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
        NSLog(@"_datePicker");
        
        NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        
        [forma setDateFormat:@"YYYY-MM-dd"];
        
        NSString *str = [forma stringFromDate:_datePicker.date]; //UIDatePicker显示的时间

        
        if (_is)
        {
            UITextField *field=(UITextField*)[self.view viewWithTag:5];
            field.text=str;
            self.StartDate=str;
        }else
        {
            UITextField *field=(UITextField*)[self.view viewWithTag:6];
            field.text=str;
            self.EndDate=str;
        }
       
        
    }
    
    [self cancel];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancel
{
    //    [_sexPicKV removeFromSuperview];
    [_datePicker removeFromSuperview];
    [_PickerView removeFromSuperview];
    [_coverView removeFromSuperview];
}
- (IBAction)done:(UIButton *)sender
{
    //判断
    if (self.Amount1.length&&self.Amount2.length&&self.Quantity1.length&&self.LimitQuantity.length&&self.StartDate.length&&self.EndDate)
    {
        //判断券类型
        if (_isVip) {
            if (!(_shareholderId.length>0)) {
                [QMUITips showError:@"未选中股东"];
                return;
            }
        }
        
        [SVProgressHUD showWithStatus:@"加载中"];
        MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
        NSDictionary *jsonDic;
        if (_isVip) {
            jsonDic=@{ @"Command":@"Add",@"TableName":@"sales_coupon",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Amount1":self.Amount1,@"Amount2":self.Amount2,@"Quantity1":self.Quantity1,@"LimitQuantity":self.LimitQuantity,@"StartDate":self.StartDate,@"EndDate":self.EndDate,@"UDF01":@"VIP",@"UDF02":_shareholderId}]};
        }else{
           jsonDic=@{ @"Command":@"Add",@"TableName":@"sales_coupon",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Amount1":self.Amount1,@"Amount2":self.Amount2,@"Quantity1":self.Quantity1,@"LimitQuantity":self.LimitQuantity,@"StartDate":self.StartDate,@"EndDate":self.EndDate,@"UDF01":@""}]};
        }
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
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCard" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else
            {
                [self alertShowWithStr:str];
            }
            
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

        
    }else
    {
        [self alertShowWithStr:@"资料没有填写完整"];
    }
   
    
}

-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
