//
//  ForgetViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
{
    /*定时器*/
    NSTimer *_timer;
    /*设定时间*/
    NSInteger _time;
    
    
}
@property(nonatomic,copy)NSString *yanZhengMa;
@property (strong, nonatomic) IBOutlet UILabel *yanLable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *yanZhengNum;
@property (strong, nonatomic) IBOutlet UITextField *passNum;
@property (strong, nonatomic) IBOutlet UITextField *passAgin;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yanLable.layer.cornerRadius=4;
    self.yanLable.layer.borderWidth=1;
    self.yanLable.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.yanLable.hidden=YES;
    self.yanLable.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress1)];
    [self.yanLable addGestureRecognizer:singleTap1];

    self.doneButton.backgroundColor=MainColor;
    [self addLefttButton];
      // Do any additional setup after loading the view from its nib.
}
//视图即将消失时销毁定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer=nil;
    NSLog(@"定时器已销毁");
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self compareTime];
}
-(void)compareTime
{
    NSDate *sendDate=[[NSUserDefaults standardUserDefaults]objectForKey:@"ForgetsendDate"];
    
    if (sendDate) {
        
        //获得当前时间
        NSDate *nowDate=[NSDate date];
        //两个时间相比较
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:sendDate toDate:nowDate options:0];
        NSInteger sencond =[comps second];//时间差
        
        //判断
        
        if (sencond>60) {
            self.yanLable.hidden=NO;
            _yanLable.enabled=YES;
        }else
        {
            //启动计时器
            [self changeButtonSataWithTime:60-sencond];
        }
    }else
    {
        self.yanLable.hidden=NO;
    }
}

-(void)buttonpress1
{
    if (_phoneNum.text.length==11)
    {
        NSDictionary *dic=@{@"FromTableName":@"CMS_Shop",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"Mobile$=$%@",_phoneNum.text],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
            
            NSDictionary *dic1=[JsonTools getData:responseObject];
            NSString *str =dic1[@"message"];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"OK"]) {
                [self SendMobileCode];
            }else{
                [self alertShowWithStr:@"该账号不存在"];
            }
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
        //[self SendMobileCode];
    }else
    {
        [self alertShowWithStr:@"请输入正确的手机号"];
    }
    
    
}
-(void)SendMobileCode
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FieldType":@"X",@"mobile":self.phoneNum.text,@"temp_id":Temp_ID,@"appmode":@"2",@"CipherText":CIPHERTEXT};
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
            self.yanZhengMa=array[1];
            _yanLable.enabled=NO;
            //保存当前的时间
            NSDate *nowDate=[NSDate date];
            [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:@"ForgetsendDate"];
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
        //销毁定时器
        [_timer invalidate];
        _timer=nil;
        
    }else
    {
        _yanLable.textColor=[UIColor lightGrayColor];
        _yanLable.text=[NSString stringWithFormat:@"%lds后重新获取",_time];
        _yanLable.userInteractionEnabled=NO;
    }
}
-(NSString *)getTime
{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    return [dateFormatter stringFromDate:currentDate];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)done:(UIButton *)sender
{
    //判断

    if (_phoneNum.text.length == 11) {
        if (_passAgin.text.length>0&&_passNum.text>0) {
            
            if (_passNum.text == _passAgin.text) {
            
                
                if (self.yanZhengMa&&_yanZhengNum.text) {
                
                
        NSLog(@"确定");
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *dic=@{@"FieldType":@"S",@"FieldValue":self.phoneNum.text,@"Code":self.yanZhengMa,@"Password":self.passNum.text};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/VerifyCodeAndSetPassword" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSString *str=[JsonTools getNSString:responseObject];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"true"])
            {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    [SVProgressHUD dismiss];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else
            {
                [self alertShowWithStr:@"修改失败,稍后再试"];
            }
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
          
                    
                }else
                {
                    [self alertShowWithStr:@"验证码输入错误!"];
                }
                
                
            }else
            {
                [self alertShowWithStr:@"两次密码输入不一致!"];
            }
            
            
        }else
        {
            [self alertShowWithStr:@"请输入修改密码!"];
        }
        
    }else
    {
        [self alertShowWithStr:@"请输入正确手机号!"];
    }


    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)addLefttButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=right;
}
-(void)commit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
