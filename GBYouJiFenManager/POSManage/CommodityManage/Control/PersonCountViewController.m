//
//  PersonCountViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PersonCountViewController.h"
#import "DownOrderViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface PersonCountViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation PersonCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.backgroundColor=MainColor;
//    self.backView.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
//    self.backView.layer.borderWidth=1;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)done:(UIButton *)sender
{
//
    if (!self.textfield.text.length)
    {
        [self alertShowWithStr:@"请输入人数"];
    }else
    {
        DownOrderViewController *person=[[DownOrderViewController alloc]init];
        person.title=@"下单";
        person.runModel=@"01";
        person.count=_textfield.text;
        person.seatModel=self.model;
        [self.navigationController pushViewController:person animated:YES];
        
    }

}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
}
#pragma mark---解锁
-(void)openSeatWithFangTaiNo:(NSString*)fangTaiNo
{
    NSString *DeviceNo=[[NSUserDefaults standardUserDefaults]objectForKey:@"DN001"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"Company":model.COMPANY,@"ShopID":model.SHOPID,@"UserNo":model.Mobile,@"DeviceNo":DeviceNo,@"SeatNo":fangTaiNo,@"IsLock":@"N",@"LockInfo":@""};
    NSLog(@"------%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/GetLockSeatInfo" With:dic and:^(id responseObject)
     {
         NSString *str=[JsonTools getNSString:responseObject];
         
         NSArray *stateStrArray=[str componentsSeparatedByString:@","];
         if ([stateStrArray[0] containsString:@"1"])
         {
             
             [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                 [SVProgressHUD dismiss];
                 
             });
         }
         
     } Faile:^(NSError *error)
     {
         
     }];
    
    
}
-(void)dealloc
{
       [self openSeatWithFangTaiNo:_model.SI001];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
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
