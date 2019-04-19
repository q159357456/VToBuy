//
//  RegisterViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "RegisterViewController.h"
#import "MarketingInforViewController.h"
#import "ForgetViewController.h"

@interface RegisterViewController ()
{
    /*定时器*/
    NSTimer *_timer;
    /*设定时间*/
    NSInteger _time;


}
@property (strong, nonatomic) IBOutlet UILabel *yanLable;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(strong,nonatomic)NSString *yanZhengMa;

@end

@implementation RegisterViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
         [self compareTime];
}
-(void)buttonpress1
{

    if (_phoneNumField.text.length!=11)
    {
        [self alertShowWithStr:@"请输入正确的手机号"];
    }else
    {
        NSDictionary *dic=@{@"FromTableName":@"CMS_Shop",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"Mobile$=$%@",_phoneNumField.text],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
            
            NSDictionary *dic1=[JsonTools getData:responseObject];
            NSString *str =dic1[@"message"];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"OK"]) {
                [self alertShowWithStr:@"该账号已被注册"];
            }else{
                [self sendNumberCode];
            }
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
        
        
    }

}

-(void)sendNumberCode{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FieldType":@"S",@"FieldValue":self.phoneNumField.text,@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/ExistAndCreateCode_New" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        
        if (str.length==4)
        {
            [self SendMobileCode];
        }else
        {
            [self alertShowWithStr:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}


//视图即将消失时销毁定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer=nil;
    NSLog(@"定时器已销毁");
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
-(void)compareTime
{
    NSDate *sendDate=[[NSUserDefaults standardUserDefaults]objectForKey:@"sendDate"];

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


-(void)SendMobileCode
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FieldType":@"S",@"mobile":self.phoneNumField.text,@"temp_id":Temp_ID,@"appmode":@"2",@"CipherText":CIPHERTEXT};
//    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/SendMobileCode_New" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        NSArray *array=[str componentsSeparatedByString:@","];
        if (![array[0] isEqualToString:@"OK"])
        {
            _yanLable.enabled=YES;
            [self alertShowWithStr:@"获取失败,稍后再试"];
            
        }else
        {
            self.yanZhengMa=array[1];
            _yanLable.enabled=NO;
            //保存当前的时间
            NSDate *nowDate=[NSDate date];
            [[NSUserDefaults standardUserDefaults]setObject:nowDate forKey:@"sendDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self changeButtonSataWithTime:60];
            [self alertShowWithStr:@"短信已经发送成功请稍后"];
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
- (IBAction)done:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FieldType":@"S",@"FieldValue":self.phoneNumField.text,@"Password":self.passWordField.text};
            NSLog(@"dic==>%@",dic);
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"crminfoservice.asmx/UpdateRegInfo" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"]) {
            NSLog(@"资料保存成功");
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
        MarketingInforViewController  *userInfo = [[MarketingInforViewController  alloc] init];

        userInfo.phoneNum=self.phoneNumField.text;
        userInfo.passWordNum=self.passWordField.text;
        userInfo.title=@"填写营业信息";
        [self.navigationController pushViewController:userInfo animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
