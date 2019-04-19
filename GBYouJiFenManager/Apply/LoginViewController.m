//
//  LoginViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/3.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterNav.h"
#import "ForgetViewController.h"
#import "AppDelegate.h"
#import "GBTabBarViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "MarketingInforViewController.h"
#import "RegisterViewController.h"
#import "JPUSHService.h"
//加入网络监听

@interface LoginViewController ()
@property(weak,nonatomic)IBOutlet UITextField *numberField;
@property(weak,nonatomic)IBOutlet UITextField *secretField;
@property(weak,nonatomic)IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoH;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property(weak,nonatomic)IBOutlet UIButton *forgetButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numberField.keyboardType = UIKeyboardTypePhonePad;
    
    if (screen_width==320) {
        
        _logoH.constant=100;
        _logoW.constant=100;
        [_headImage rounded:50];
    }else
    {
         [_headImage rounded:75];
    }
         
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusNotReachable) name:StatusNotReachable object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusReachableViaWiFi) name:StatusReachableViaWiFi object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusReachableViaWWAN) name:StatusReachableViaWWAN object:nil];
    

    // Do any additional setup after loading the view from its nib.
}
-(void)statusNotReachable
{
      [self alertShowWithStr:@"没有检测到网络,请检查网络设置后再进行下一步操作"];
}
-(void)statusReachableViaWiFi
{
      [self getIp];
}
-(void)statusReachableViaWWAN
{
      [self getIp];
}
-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;
    _doneButton.backgroundColor=MAINCOLOR;
}

-(void)getIp
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[NetDataTool shareInstance]getNetData:ENTERIP url:@"SystemCommService.asmx/GetDataIP" With:nil and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"requstIP"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self getImageIP];
    } Faile:^(NSError *error) {
     
    }];
}
-(void)getImageIP
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[NetDataTool shareInstance]getNetData:ENTERIP url:@"SystemCommService.asmx/GetImageServerIP" With:nil and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"imageIP"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [SVProgressHUD dismiss];
    } Faile:^(NSError *error) {
        
    }];
}
    

- (IBAction)registerAction:(id)sender {
    NSLog(@"加盟注册");
    RegisterViewController *regis=[[RegisterViewController alloc]init];
    regis.modalPresentationStyle=UIModalTransitionStyleFlipHorizontal;
    regis.title=@"注册";
    RegisterNav *nav=[[RegisterNav alloc]initWithRootViewController:regis];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)forgetAction:(id)sender {
    NSLog(@"忘记密码");
    
    ForgetViewController *forget=[[ForgetViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:forget];
    [navigation.navigationBar setBarTintColor:navigationBarColor];
    forget.title=@"重置密码";
    [self presentViewController:navigation animated:YES completion:nil];
 
}

- (IBAction)login:(UIButton *)sender
{
    if (_numberField.text.length>0&&_secretField.text>0)
    {
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *dic=@{@"UserNo":_numberField.text,@"Password":_secretField.text};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/CRMInfoService.asmx/IsLoginAndGetShopInfo" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic1=[JsonTools getData:responseObject];
            NSLog(@"--%@",dic1);
              NSArray *arry=[MemberModel getDataWithDic:dic1];
            if (arry.count>0)
            {
                MemberModel *model=arry[0];
              
                if ([model.Status isEqualToString:@"True"])
                {
                    [[FMDBMember shareInstance]insertUser:model];
                    //存入模式
                    [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"IsPreOrder"] forKey:@"IsPreOrder"];
                     [[NSUserDefaults standardUserDefaults] synchronize ];
                    [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"pos_runmodel"] forKey:@"POS_RunModel"];
                    [[NSUserDefaults standardUserDefaults]setValue:dic1[@"DataSet"][@"Shop"][0][@"ShopType"] forKey:@"ShopType"];
                    [[NSUserDefaults standardUserDefaults] synchronize ];
                    //设置别名
                    [JPUSHService setAlias:dic1[@"DataSet"][@"Shop"][0][@"SHOPID"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                        
                    } seq:2];

                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                    [SVProgressHUD showWithStatus:@"加载中"];
                    
                    [self page];
                
                }else if (model.SHOPID == nil){
                    
                    //号码已注册 但资料未填写完整
                    MarketingInforViewController  *userInfo = [[MarketingInforViewController  alloc] init];
                    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:userInfo];
                    [navigation.navigationBar setBarTintColor:navigationBarColor];
                    userInfo.phoneNum=self.numberField.text;
                    userInfo.passWordNum=self.secretField.text;
                    userInfo.title=@"填写营业信息";
                    [self presentViewController:navigation animated:YES completion:nil];
                    
                }
            else
               {
                    [self alertShowWithString:@"账号在审核中"];
               }

            }else
            {
                [self alertShowWithStr:@"账号或密码错误"];
            }

        
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
    }else
    {
        [self alertShowWithStr:@"账号或密码不能为空"];
    }
}

-(void)page
{
    [UIView animateWithDuration:0.5 animations:^
     {
         self.view.alpha = 0.9;
     } completion:^(BOOL finished)
     {
       
         
         //做翻页动画
         [UIView transitionWithView:self.view.window duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
         
         // 根据是否登录 显示不同的界面
         AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         GBTabBarViewController *GBTabVC = [[GBTabBarViewController alloc] init];
         appDelegate.window.rootViewController=GBTabVC;
         
     }];

}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;

        action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];

    
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)alertShowWithString:(NSString*)string
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
    
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *dic;
        dic=@{@"FromTableName":@"CMS_Company",@"SelectField":@"telphone",@"Condition":@"",@"SelectOrderBy":@"telphone",@"CipherText":CIPHERTEXT};
        
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic1=[JsonTools getData:responseObject];
            
            NSArray *arr = dic1[@"DataSet"][@"Table"];
            NSString *telString = arr[0][@"telphone"];
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telString];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

    }];
    
    
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
