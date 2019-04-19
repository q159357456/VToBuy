//
//  PayDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PayDetailViewController.h"
#import "PayDetailTableViewCell.h"
#import "PayTypeTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "PayTypeModel.h"
#import "ErWeiMaWebViewController.h"
#import "INV_ProductModel.h"
#import "POSDIModel.h"
#import "GBNavigationViewController.h"
#import "SBModel.h"
#import "ScanningQRCodeVC.h"
@interface PayDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSMutableArray *payTypeArray;
@property(nonatomic,strong)NSArray *imageArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview2;
@property(nonatomic,copy)NSString *payType;

@end

@implementation PayDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    
  
    _titleArray=@[@"单号:",@"房台:",@"应收款:"];
    self.Theight.constant=_titleArray.count*50+10;
    _tableview2.layer.cornerRadius=8;
    _tableview2.layer.masksToBounds=YES;
    _payTypeArray=[NSMutableArray array];
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _doneButton.backgroundColor=MainColor;
    [self getPayType];


    // Do any additional setup after loading the view from its nib.
}


-(NSArray *)imageArray
{
    if (!_imageArray) {
        _imageArray=@[@"xj",@"yl",@"zfb",@"wxzf"];
    }
    return _imageArray;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)done:(UIButton *)sender
{
    //此处区分快餐模式和餐厅模式
    if (!_seatNo.length)
    {
        //快餐模式
        NSLog(@"快餐模式");
      [self IsSenBill];
        
    }else
    {
        if ([self.payType isEqualToString:@"ALIPAY"]) {
            //支付宝
            //扫码
            ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
            
            VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,_seatNo,_totalPrice];
            DefineWeakSelf;
            VC.backBlock=^(NSString *code){
                
                [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                
            };
            [self.navigationController pushViewController:VC animated:YES];
            
        

//            ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//            ma.dingDanNo=self.billNo;
//            ma.zhifuStr=@"ALIPAY";
//            ma.seatNo=_seatNo;
//            ma.price=_totalPrice;
//            [self presentViewController:ma animated:YES completion:nil];
            
        }else if ([self.payType isEqualToString:@"WEIXIN"])
        {
            //扫码
            ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
            VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,_seatNo,_totalPrice];
            DefineWeakSelf;
            VC.backBlock=^(NSString *code){
                
                [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                
            };
            [self.navigationController pushViewController:VC animated:YES];
            
        

            //微信
//            ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//            ma.dingDanNo=self.billNo;
//            ma.zhifuStr=@"WEIXIN";
//              ma.seatNo=_seatNo;
//            ma.price=_totalPrice;
//            [self presentViewController:ma animated:YES completion:nil];
            
        }else if ([self.payType isEqualToString:@"0001"])
        {
          
            [self MaiDan];
        }else if ([self.payType isEqualToString:@"0002"])
        {
        
            [self MaiDan];
            
        }

    }
    

    
}
//判断单据是否存在，如果存在就不需要再送单
-(void)IsSenBill
{
   
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"POSSB",@"SelectField":@"SB004",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB002$=$%@",_model.COMPANY,_model.SHOPID,_billNo],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {
         [SVProgressHUD dismiss];
         NSDictionary *dic1=[JsonTools getData:responseObject];
         NSArray *array=[SBModel getDataWithDic:dic1];
         if (!array.count)
         {
          
             [self seatSendBill];
         }else
         {
           
             //已经送单订单状态直接买单
             if ([self.payType isEqualToString:@"ALIPAY"]) {
             
                 //支付宝
                 //扫码
                 ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
                 
                 VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,@"快餐",_totalPrice];
                 DefineWeakSelf;
                 VC.backBlock=^(NSString *code){
                     
                     [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                     
                 };
                 [self.navigationController pushViewController:VC animated:YES];
//                 ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//                 ma.dingDanNo=self.billNo;
//                 ma.zhifuStr=@"ALIPAY";
//                
//                 [self presentViewController:ma animated:YES completion:nil];
                 
             }else if ([self.payType isEqualToString:@"WEIXIN"])
             {
                 //微信
                 ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
                 VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,@"快餐",_totalPrice];
                 DefineWeakSelf;
                 VC.backBlock=^(NSString *code){
                     
                     [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                     
                 };
                 [self.navigationController pushViewController:VC animated:YES];
//                 ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//                 ma.dingDanNo=self.billNo;
//                 ma.zhifuStr=@"WEIXIN";
////               
//                 [self presentViewController:ma animated:YES completion:nil];
             }else
             {
                 [self MaiDan];
             }

         }
        
         
     } Faile:^(NSError *error) {
         
     }];

    
}
-(void)seatSendBill
{
    //房台
  
    [SVProgressHUD showWithStatus:@"加载中"];
    
    //公共参数获取
    NSString *DeviceNo =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"];
    NSString *Area =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN006"];
    NSString *ClassesInfo =[[NSUserDefaults standardUserDefaults]valueForKey:@"ClassesInfo"];
    NSArray *classArray=[ClassesInfo componentsSeparatedByString:@","];
    NSString *ClassesNo=classArray[0];
    NSString *ClassesIndex=classArray[2];
    //SB
    NSArray *bjsonArray=[NSArray array];
    bjsonArray=@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"SB016":@"0000000001",@"SB004":@"2",@"SB002":self.billNo,@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"SB001":@"P101"}];

    //SBP
    NSMutableArray *pjsonArray=[NSMutableArray array];
    for (INV_ProductModel *model in _dataArray)
    {
        NSDictionary *dic;
        if ([model isKindOfClass:[INV_ProductModel class]])
        {
            dic=@{@"SBP004":model.ProductNo,@"SBP009":[NSString stringWithFormat:@"%ld",model.count],@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP015":model.RetailPrice};
        }else
        {
            
            dic=@{@"SBP004":model.ProductNo,@"SBP009":model.Dosage,@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP027":model.SBP027,@"SBP015":model.RetailPrice};
            
        }
        
        [pjsonArray addObject:dic];
    }
    //SPT
    NSMutableArray *possbptJsonArray=[NSMutableArray array];
    
    for (POSDIModel *model in self.tastArray) {
        NSDictionary *dic=@{@"SPT003":model.SPT003,@"SPT005":model.DI001,@"SPT006":model.DI006,@"SPT007":model.DI007};
        [possbptJsonArray addObject:dic];
    }
    NSData *data1=[NSJSONSerialization dataWithJSONObject:bjsonArray options:kNilOptions error:nil];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:pjsonArray options:kNilOptions error:nil];
    NSData *data3=[NSJSONSerialization dataWithJSONObject:possbptJsonArray options:kNilOptions error:nil];
    NSString *possjsonSyr=[[NSString alloc]initWithData:data3 encoding:NSUTF8StringEncoding];
    NSString *bjsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSString *pjsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"快餐送单生成订单%@",possjsonSyr);
    NSLog(@"%@",bjsonStr);
    NSLog(@"%@",pjsonStr);
    NSDictionary *jsonDic;
    jsonDic=@{@"possbJson":bjsonStr,@"possbpJson":pjsonStr,@"possbptJson":possjsonSyr,@"posstsJson":@"",@"CipherText":CIPHERTEXT};
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url;
   
        url=@"/posservice.asmx/MerchantCreateBill";

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:url With:jsonDic and:^(id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str containsString:@"true"]) {
              [SVProgressHUD dismiss];
            if ([self.payType isEqualToString:@"ALIPAY"]) {
                //支付宝
                ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
                
                VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,@"快餐",_totalPrice];
                DefineWeakSelf;
                VC.backBlock=^(NSString *code){
                    
                    [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                    
                };
                [self.navigationController pushViewController:VC animated:YES];
//                ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//                ma.dingDanNo=self.billNo;
//                ma.zhifuStr=@"ZHIFUBAO";
//                [self presentViewController:ma animated:YES completion:nil];
                
            }else if ([self.payType isEqualToString:@"WEIXIN"])
            {
                ScanningQRCodeVC *VC = [[ScanningQRCodeVC alloc] init];
                VC.scanStyle=[NSString stringWithFormat:@"%@,%@,%@,%@",_payType,_billNo,@"快餐",_totalPrice];
                DefineWeakSelf;
                VC.backBlock=^(NSString *code){
                    
                    [weakSelf sweepCodePayWithPayType:self.payType Code:code];
                    
                };
                [self.navigationController pushViewController:VC animated:YES];
//                //微信
//                ErWeiMaWebViewController *ma=[[ErWeiMaWebViewController alloc]init];
//                ma.dingDanNo=self.billNo;
//                ma.zhifuStr=@"WEIXIN";
//                [self presentViewController:ma animated:YES completion:nil];
            }else
            {
                [self MaiDan];
            }
            
            
        }else
        {
              [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    
    } Faile:^(NSError *error)
     {
         NSLog(@"错误%@",error);
     }];
    
    
}

#pragma mark--买单请求
-(void)MaiDan
{
    
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    //公共参数
    NSString *DeviceNo =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"];
    NSString *Area =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN006"];
    NSString *ClassesInfo =[[NSUserDefaults standardUserDefaults]valueForKey:@"ClassesInfo"];
    NSArray *classArray=[ClassesInfo componentsSeparatedByString:@","];
    NSString *ClassesNo=classArray[0];
    NSString *ClassesIndex=classArray[2];
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"BusinessDate"];
    NSArray *timeArray=[time componentsSeparatedByString:@","];
    NSString* dateString=timeArray[1];
    NSMutableArray *jsonArry=[NSMutableArray array];
    NSMutableArray *bjsonArray=[NSMutableArray array];
    if (!_totalPrice.length) {
        _totalPrice=@"0";
    }
    //pc 表数据
    NSDictionary *pospcJsonDic;
    if (_seatNo.length)
    {
        pospcJsonDic=@{@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"BusinessDate":dateString,@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"PC001":PC01,@"PC002":self.billNo,@"PC003":@"1",@"PC004":self.payType,@"PC005":_model.Mobile,@"PC006":@"RMB",@"PC012":self.totalPrice,@"PC013":@"0"};

    }else
    {
        pospcJsonDic=@{@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"BusinessDate":dateString,@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"PC001":PC01,@"PC002":self.billNo,@"PC003":@"1",@"PC004":self.payType,@"PC005":_model.Mobile,@"PC006":@"RMB",@"PC012":self.totalPrice,@"PC013":@"0"};

    }
     [jsonArry addObject:pospcJsonDic];
    //SBP表数据
    NSDictionary *jdic;
    if (_seatNo.length)
    {
        jdic=@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"SB005":_seatNo,@"SB009":@"3",@"SB004":@"1",@"SB002":_billNo,@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"SB001":PC01,@"SB025":@"0",@"SB026":@"0",@"SB027":@"0",@"SB031":@"0",@"SB003":dateString,@"SB023":_totalPrice,@"SB029":_totalPrice};
    }else
    {
        jdic=@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"SB009":@"3",@"SB004":@"2",@"SB002":_billNo,@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"SB001":PC01,@"SB025":@"0",@"SB026":@"0",@"SB027":@"0",@"SB031":@"0",@"SB003":dateString,@"SB023":_totalPrice,@"SB029":_totalPrice};
    }
    
       [bjsonArray addObject:jdic];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:bjsonArray options:kNilOptions error:nil];
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonArry options:kNilOptions error:nil];
    NSString *pospcJsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *bjsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",pospcJsonStr);
    NSLog(@"%@",bjsonStr);
    NSDictionary *jsondic=@{@"possbJson":bjsonStr,@"pospcJson":pospcJsonStr,@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"/posservice.asmx/MerchantPayBill_new" With:jsondic and:^(id responseObject)
     {
         NSString *str=[JsonTools getNSString:responseObject];
      
         if ([str isEqualToString:@"OK"])
         {
                      [SVProgressHUD showSuccessWithStatus:@"付款成功"];
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [SVProgressHUD dismiss];
                          //通知中心
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil userInfo:nil];
                          NSArray *controArray=self.navigationController.viewControllers;
                          [self.navigationController popToViewController:controArray[1] animated:YES];

                          
                      });
             
         }else
         {
               [SVProgressHUD dismiss];
             [self alertShowWithStr:str];
             
         }


     } Faile:^(NSError *error)
     {
         
     }];
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)getPayType
{
    
    NSDictionary *dic=@{@"FromTableName":@"POSCM",@"SelectField":@"CM001,CM002,CM003",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@$AND$CM019$=$true$AND$CM023$=$true",@"MShop",_model.COMPANY],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {
         NSDictionary *dic1=[JsonTools getData:responseObject];
         NSLog(@"%@",dic1);
         _payTypeArray=[PayTypeModel getDatawithdic:dic1];
         [_payTypeArray removeObjectAtIndex:3];
         [self.tableview2 reloadData];
     } Faile:^(NSError *error) {
        
     }];
    
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableview)
    {
      return _titleArray.count;
        
    }else
    {
        
        return _payTypeArray.count;
    }
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableview)
    {
        static NSString *cellid=@"PayDetailTableViewCell";
        PayDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"PayDetailTableViewCell" owner:nil options:nil][0];
        }
        //            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width
        cell.titleLable.text=_titleArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                cell.contentLable.text=self.billNo;
            }
                break;
            case 1:
            {
                if (self.seatNo.length)
                {
                      cell.contentLable.text=self.seatName;
                }else
                {
                     cell.contentLable.text=@"快餐模式";
                }
                
            }
                break;
                
            default:
            {
                
                cell.contentLable.text=[NSString stringWithFormat:@"¥%@",self.totalPrice];
                
            }
                break;
        }
        return cell;
        
    }else
    {
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

    return nil;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
     if (tableView==_tableview2) {
         return 65;
     }else
        return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableview2) {
        return 0.01;
    }else
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
      if (tableView==_tableview2)
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
          [_tableview2 reloadData];
          
      }else
      {
          return;
      }
    
    
}
//扫码后回调付款
-(void)sweepCodePayWithPayType:(NSString*)str Code:(NSString*)code
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"paymode":str,@"billno":self.billNo,@"authcode":code,@"CipherText":CIPHERTEXT};
    NSLog(@"---%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/MicroPay" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"PAYOK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil userInfo:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *array=self.navigationController.viewControllers;
                [self.navigationController popToViewController:array[1] animated:YES];
            });

            
        }else
        {
            [self alertShowWithStr:str];
            
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
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
