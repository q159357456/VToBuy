//
//  SweepPayOneViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/3.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "SweepPayOneViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "SBModel.h"
#import "SweepPayTableViewCell.h"
#import "ToolView.h"
#import "ScanningQRCodeVC.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface SweepPayOneViewController ()
@property(nonatomic,strong)NSMutableString *dataStr;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSArray *keyArray;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UILabel *disCountLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomH;

@end

@implementation SweepPayOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _dataStr=[NSMutableString string];
    [self creatFun];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _disCountLable.text=[NSString stringWithFormat:@"积分折扣%.1f",model.ShopDiscount.floatValue*10];
    _disCountLable.hidden = YES;
    self.bottomH.constant=screen_width;
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
}
-(NSArray *)keyArray
{
    if (!_keyArray) {
        _keyArray=@[@"1",@"2",@"3",@"x",@"4",@"5",@"6",@"c",@"7",@"8",@"9",@"收款",@"0",@".",@"+"];
    }
    return _keyArray;
}

-(void)creatFun
{
    NSInteger h;
//    if (screen_height==568)
//    {
//        h=320;
//    }else
//    {
//        h=380;
//    }
    h=screen_width;
     NSInteger k=0;
    for (NSInteger i=0; i<4; i++)
    {
        for (NSInteger j=0; j<4; j++)
        {
            if (k<=10||k==12) {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(j*((screen_width-3)/4+1),screen_height-h-64+i*((h-3)/4+1), (screen_width-3)/4, (h-3)/4);
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                if (k==3) {
                    [button setImage:[UIImage imageNamed:@"deleSweep"] forState:UIControlStateNormal];
                    
                }else
                {
                     [button setTitle:self.keyArray[k] forState:UIControlStateNormal];
                }
               
                button.titleLabel.font=[UIFont systemFontOfSize:30.0];
           
                [self.view  addSubview:button];
                button.tag=k+1;
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
              

                
            }else if (k==11)
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(j*((screen_width-3)/4+1)+(screen_width-3)/16,screen_height-h-64+i*((h-3)/4+1+10), (screen_width-3)/8, (h-3)*2/4-30);
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                [button rounded:button.width/2];
         
                
                [self.view  addSubview:button];
                button.tag=k+1;
                button.backgroundColor=navigationBarColor;
                [button setImage:[UIImage imageNamed:@"StoreManage_3"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }else if (k==13||k==14)
            {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(j*((screen_width-3)/4+1),screen_height-h-64+i*((h-3)/4+1), (screen_width-3)/4, (h-3)/4);
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                
                [button setTitle:self.keyArray[k] forState:UIControlStateNormal];
                button.titleLabel.font=[UIFont systemFontOfSize:30.0];
                
                [self.view  addSubview:button];
                button.tag=k+1;
                [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

            }
            
            
              k++;
            
        }
        
    }
}
-(void)click:(UIButton*)butt
{
    

    
    if (butt.tag==12) {
        //扫码
        if (self.priceLable.text.length==0||[self.priceLable.text floatValue]==0||[self.priceLable.text isEqualToString:@"."])
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请输入有效数值"];
        }else
        {
            //扫码
            ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
            VC.scanStyle=[NSString stringWithFormat:@"¥ %@",_dataStr];
            DefineWeakSelf;
            VC.backBlock=^(NSString *code){
                
                [weakSelf sweepCodePayWithCode:code];
                
            };
            [self.navigationController pushViewController:VC animated:YES];
            
        }

        
    }else if (butt.tag==4)
    {
        //删
        if (self.dataStr.length>0) {
            
            [self.dataStr deleteCharactersInRange:NSMakeRange(self.dataStr.length-1, 1)];
            self.priceLable.text=[NSString stringWithString:self.dataStr];
        }

        
    }else if (butt.tag==8)
    {
        //全删
        if (self.dataStr.length>0) {
            
            self.dataStr=[NSMutableString stringWithString:@""];
            self.priceLable.text=[NSString stringWithString:self.dataStr];
        }

        
    }else if(butt.tag==15)
    {
        //加
        
    }else
    {
        //
        if ([self.dataStr containsString:@"."])
        {
            
            if (![butt.titleLabel.text isEqualToString:@"."])
            {
                
                [self.dataStr appendString:butt.titleLabel.text];
            }
            
        }else if ([self.dataStr isEqualToString:@"0"])
        {
            
            if ([butt.titleLabel.text isEqualToString:@"."])
            {
                [self.dataStr appendString:butt.titleLabel.text];
            }
        }else if (self.dataStr.length==0&&[butt.titleLabel.text isEqualToString:@"."])
        {
            
            return;
        }
        
        else
        {
            
            [self.dataStr appendString:butt.titleLabel.text];
            
        }
        
        self.priceLable.text=self.dataStr;

    }
    
  
}

-(void)sweepCodePayWithCode:(NSString*)code
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];

    NSDictionary *dic=@{@"company":_model.COMPANY,@"shopid":_model.SHOPID,@"amount":_dataStr,@"authcode":code,@"CipherText":CIPHERTEXT};
 
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/MicroPay_shop" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"PAYOK"])
        {
            

            _dataStr=nil;
            _priceLable.text=nil;
            [self alertShowWithStr:@"支付成功"];
            
        }else
        {
            [self alertShowWithStr:str];
            
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
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
-(void)paySuccess
{
    
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}
-(void)dealloc
{
    NSLog(@"dealloc");
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
