//
//  ErWeiMaWebViewController.m
//  GBManagement
//
//  Created by 工博计算机 on 16/12/21.
//  Copyright © 2016年 工博计算机. All rights reserved.
//

#import "ErWeiMaWebViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
typedef void(^doneBlock)();
@interface ErWeiMaWebViewController ()<UIWebViewDelegate>
{
    NSInteger k;
}
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) IBOutlet UIButton *giveup;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *headLable;
@property(nonatomic,strong)MemberModel *model;


@end

@implementation ErWeiMaWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _done.backgroundColor=MainColor;
    _giveup.backgroundColor=MainColor;
    self.view.backgroundColor=navigationBarColor;
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _priceLable.text=[NSString stringWithFormat:@"¥%@",_price];
    k=0;
    if ([self.zhifuStr isEqualToString:@"WEIXIN"]) {
        self.title=@"微信付款";
        self.headLable.text=@"微信支付";
         self.headImage.image=[UIImage imageNamed:@"wxzf"];
        _headLable.textColor=[ColorTool colorWithHexString:@"#4bc348"];
     
    }else
    {
         self.title=@"支付宝付款";
        self.headLable.text=@"支付宝支付";
        self.headImage.image=[UIImage imageNamed:@"zfb"];
        _headLable.textColor=[ColorTool colorWithHexString:@"#00aaef"];
    }
    NSString *urlStr=[NSString stringWithFormat:@"%@posservice.asmx/GeneratePayQRCode?paymode=%@&billno=%@&CipherText=6you7QLfbASAFzt0HYAaRJA4yHwAIS4uY3OmqkaeXsSdjcP8cEBrQQ==",ROOTPATH,self.zhifuStr,self.dingDanNo];
    NSLog(@"%@",urlStr);
    DefineWeakSelf;
    [_imageview sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
//        NSLog(@"%@",image);
        if (!image) {
            [weakSelf alertShowWithStr:@"订单异常,联系管理员"];
        }else
        {
            [weakSelf getPayInfoDatawithBlock:^{
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //通知中心
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CodepaySuccess" object:nil userInfo:@{@"SI001":_seatNo}];
                   
                        NSArray *array=self.navigationController.viewControllers;
                        [self.navigationController popToViewController:array[1] animated:YES];
                  
                }];
                [alert addAction:action];
                [alert addAction:action1];
                
                [self presentViewController:alert animated:YES completion:nil];

            }];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}
//获取支付信息
-(void)getPayInfoDatawithBlock:(doneBlock)done
{
   
    NSDictionary *dic=@{@"FromTableName":@"POSSB",@"SelectField":@"SB004",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB002$=$%@",_model.COMPANY,_model.SHOPID,_dingDanNo],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {
     
         NSDictionary *dic1=[JsonTools getData:responseObject];
         NSString *sb004=dic1[@"DataSet"][@"Table"][0][@"SB004"];
         NSLog(@"%@",sb004);
         if (sb004.intValue==4)
         {
             if (done) {
                 done();
             }
             return;
         }else
         {

             [self performSelector:@selector(delayMethod:) withObject:done afterDelay:1.0];
             
         }
         
     } Faile:^(NSError *error) {
         
     }];

}
-(void)delayMethod:(doneBlock)done
{
     [self getPayInfoDatawithBlock:done];
}
- (IBAction)back:(UIButton *)sender
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"放弃本次支付?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //通知中心
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)done:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"POSSB",@"SelectField":@"SB004",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB002$=$%@",_model.COMPANY,_model.SHOPID,_dingDanNo],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
     NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {
         [SVProgressHUD dismiss];
         NSDictionary *dic1=[JsonTools getData:responseObject];
         NSString *sb004=dic1[@"DataSet"][@"Table"][0][@"SB004"];
          NSLog(@"%@",sb004);
         if (sb004.intValue==4)
         {
             //支付成功后直接返回到房台
             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功!" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
             UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 //通知中心
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CodepaySuccess" object:nil userInfo:@{@"SI001":_seatNo}];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }];
             [alert addAction:action];
             [alert addAction:action1];
             
             [self presentViewController:alert animated:YES completion:nil];

         }else
         {
             [self alertShowWithStr:@"此次支付未成功"];
         }
     } Faile:^(NSError *error) {
         
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
-(void)dealloc
{
  
    
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
