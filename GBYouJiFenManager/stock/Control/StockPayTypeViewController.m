//
//  StockPayTypeViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/21.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StockPayTypeViewController.h"
#import "PayTypeModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "PayTypeTableViewCell.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface StockPayTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *payTypeArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *payType;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@end

@implementation StockPayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _payTypeArray=[NSMutableArray array];
      _model=[[FMDBMember shareInstance]getMemberData][0];
     [self getPayType];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stockPaySucesce) name:@"stockPaySucesce" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)stockPaySucesce
{
     [self alertShowWithStr:@"支付成功"];
}
-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=@[@"xj",@"yl",@"zfb",@"wxzf"];
    }
    return _imageArray;
}
-(void)setPayButton:(UIButton *)payButton
{
    _payButton=payButton;
    _payButton.backgroundColor=MainColor;
    if (self.billModel) {
        [_payButton setTitle:[NSString stringWithFormat:@"¥%@  去支付",self.billModel.SB023] forState:UIControlStateNormal];
    }
    
}
-(void)getPayType
{
    
    NSDictionary *dic=@{@"FromTableName":@"POSCM",@"SelectField":@"CM001,CM002,CM003",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@$AND$CM019$=$true$AND$CM023$=$true",@"MShop",_model.COMPANY],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {    [SVProgressHUD dismiss];
         NSDictionary *dic1=[JsonTools getData:responseObject];
        
         _payTypeArray=[PayTypeModel getDatawithdic:dic1];
         [self.tableview reloadData];
         NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
         [self tableView:self.tableview didSelectRowAtIndexPath:path];
     } Faile:^(NSError *error) {
       
     }];
    
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
        return _payTypeArray.count;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        static NSString *cellid=@"PayTypeTableViewCell";
        PayTypeModel *model=_payTypeArray[indexPath.row];
        PayTypeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"PayTypeTableViewCell" owner:nil options:nil][0];
        }
        if (model.isSlected)
        {
            cell.selectedView.image=[UIImage imageNamed:@"payType_2"];
        }else
        {
            cell.selectedView.image=[UIImage imageNamed:@"payType_1"];
        }
        cell.imageview.image=[UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.contentLable.text=model.CM002;
        return cell;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
        return 65;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
        return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        PayTypeModel *model=_payTypeArray[indexPath.row];
        for (PayTypeModel *model1 in _payTypeArray)
        {
            if ([model.CM001 isEqualToString:model1.CM001]) {
                model1.isSlected=YES;
                self.payType=model1.CM001;
            }else
            {
                model1.isSlected=NO;
            }
        }
        [_tableview reloadData];
        
 
    
    
}
- (IBAction)pay:(UIButton *)sender
{
    NSLog(@"--%@",self.payType);
    if ([self.payType isEqualToString:@"0001"])
    {
        //人民币
        [self payWithType:self.payType];
        
    }else if ([self.payType isEqualToString:@"0002"])
    {
        //银行卡
        [self payWithType:self.payType];
        
    }else if ([self.payType isEqualToString:@"ALIPAY"])
    {
        //支付宝
        [self aliPay];
        
    }else if ([self.payType isEqualToString:@"WEIXIN"])
    {
        //微信
        [self weixinPay];
    }
    
}
#pragma mark--支付宝
-(void)aliPay
{
    NSLog(@"支付宝支付");
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [SVProgressHUD showWithStatus:@"支付中"];
    
    
    NSDictionary *dic=@{@"paymode":@"Alipay",@"billno":self.billModel.SB002,@"CipherText":CIPHERTEXT};
    NetDataTool *net=[[NetDataTool alloc]init];
    [net getNetData:ROOTPATH url:AppPay With:dic and:^(id responseObject) {
        
        NSString *retString=[JsonTools getNSString:responseObject];
        
        if(retString != nil){
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"GBalisdkdemo";
            //处理字符串
            NSString *newStr=[retString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:newStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                if([resultDic[@"resultStatus"]isEqualToString:@"6001"]) {
                    //用户中途取消
                    
                }
                
                
            }];
            
            
        }else{
            NSLog(@"服务器返回错误，未获取到json对象");
            
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"调用－－－－－失败!!");
    }];
    
    
    
}

-(void)payWithType:(NSString*)type
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dic=@{@"company":self.billModel.company,@"shopid":self.billModel.SHOPID,@"billno":self.billModel.SB002,@"paymode":type,@"CipherText":CIPHERTEXT};
//    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"MallService.asmx/MallPayBill" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
     
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"-------%@",str);
        if ([str isEqualToString:@"true"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stockPaySucesce" object:nil userInfo:nil];
          
        }else
        {
            [self alertShowWithStr:str];
        }
        
        

    } Faile:^(NSError *error) {
     
    }];
    
}
-(void)weixinPay
{
    NSLog(@"微信支付");
    
    
    
    NSDictionary *dic=@{@"paymode":@"WEIXIN",@"billno":self.billModel.SB002,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:AppPay With:dic and:^(id responseObject) {
        
        NSDictionary *dic=[JsonTools getData:responseObject];
        NSLog(@"dic---%@",dic);
        if(dic != nil){
            NSMutableString *retcode = [dic objectForKey:@"return_code"];
            if (retcode.intValue == 0){
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dic objectForKey:@"appid"];
                req.partnerId           = [dic objectForKey:@"mch_id"];
                req.prepayId            = [dic objectForKey:@"prepay_id"];
                req.nonceStr            = [dic objectForKey:@"nonce_str"];
                req.timeStamp           = [[dic objectForKey:@"timestamp"] intValue];
                req.package             = @"Sign=WXPay";
                req.sign                = [dic objectForKey:@"sign"];
                
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                
            }else{
                NSLog(@"%@", [dic objectForKey:@"return_msg"]);
            }
        }else{
            [self alertShowWithStr:@"服务器返回错误，未获取到json对象"];
            
        }
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"调用－－－－－失败!!");
    }];
    
}

-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action;
    
    action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array=self.navigationController.viewControllers;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
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
