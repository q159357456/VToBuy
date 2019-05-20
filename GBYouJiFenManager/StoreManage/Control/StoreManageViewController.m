//
//  StoreManageViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/4/27.
//  Copyright © 2017年 夏盈萍. All rights reserved.
//

#import "StoreManageViewController.h"
#import "POSCollectionViewCell.h"
#import "StoreSetViewController.h"
#import "BuyRecordViewController.h"
#import "MemManagerViewController.h"
#import "AficheView.h"
#import "AfichSetTwoViewController.h"
#import "StorePreviewViewController.h"
#import "EvaluatmanagViewController.h"
#import "FinanciaManagerViewController.h"
#import "ShopCodeViewController.h"
#import "ExchangeViewController.h"
#import "OrderViewController.h"
#import "ReserveViewController.h"
#import "DownOrderViewController.h"
#import "StoreCollectionReusableView.h"
#import "CoverView.h"
#import "SetBusinessDateView.h"
#import "UUID.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "AfivchModel.h"
#import "SweepPayOneViewController.h"
#import "ProcurementViewController.h"
#import "VesionManager.h"
#import "MemberCardVC.h"
#import "ZWHSharesListViewController.h"
#import "ZWHInviteCodeViewController.h"
#import "ZWHOrderOnlineViewController.h"
#import "ZWHSystemViewController.h"
#import "ZWHGrantViewController.h"
typedef enum DownBusinessName{
    GatheringQRcode = 0,
    CollectRecorde,
    BusinessData,
    EstimateManager,
    MemberStatistics,
    ShopManager,
//    StockList,
    Invitation,
//    OnlineFetchBill,
//    PaiPaiCash
}DownBusinessName;

typedef enum UpBusinessName{
    SweepGathering=0,
//    OnlineOrder,
    ExchangeCode,
}UpBusinessName;

@interface StoreManageViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)AficheView *afichview;
@property(nonatomic,strong)CoverView *coverview;
@property(nonatomic,strong)SetBusinessDateView *businessView;
@property(nonatomic,strong)UIView *PickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *shopid;
@property(nonatomic,copy)NSString *userNo;
@end

@implementation StoreManageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;


}

#pragma mark - 检查更新
-(void)checkUpdate{
    NSString *URLString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=cn", APP_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15.0f];
    DefineWeakSelf ;
    __block NSHTTPURLResponse *urlResponse = nil;
    __block NSError *error = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if (recervedData && recervedData.length > 0) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            NSArray *infoArray = [dict objectForKey:@"results"];
            if (infoArray && infoArray.count > 0) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                
                NSLog(@"描述--%@",releaseInfo[@"version"]);
                //描述
                //self.storeVison=releaseInfo[@"version"];
                //self.releaseNotes=releaseInfo[@"releaseNotes"];
                //[weakSelf getSeverceVesion];
                if ([VERSION doubleValue] < [releaseInfo[@"version"] doubleValue]) {
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"有更新版本,请更新后使用!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", APP_ID];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                        
                    }];
                    [alert addAction:action1];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self checkUpdate];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _company=model.COMPANY;
    _shopid=model.SHOPID;
    _userNo=model.Mobile;

// _imageArray=@[@"StoreManage_3",@"StoreManage_2",@"StoreManage_13",@"StoreManage_4",@"StoreManage_14",@"StoreManage_7",@"StoreManage_8",@"StoreManage_12",@"StoreManage_10",@"WechatIMG52",@"StoreManage_4",@"32",@"grant"];
//    _titleArray=@[@"扫码收款",@"在线点单",@"兑换码验证",@"收款二维码",@"收单记录",@"营业数据",@"评价管理",@"会员统计",@"店铺设置",@"股份列表",@"邀请",@"在线取单",@"派派金"];
    //,@"邀请",@"会员充值"
 _imageArray=@[@"StoreManage_3" ,@"StoreManage_13",@"StoreManage_4",@"StoreManage_14",@"StoreManage_7",@"StoreManage_8",@"StoreManage_12",@"StoreManage_10",@"StoreManage_4"];
    _titleArray=@[@"扫码收款", @"兑换码验证",@"收款二维码",@"收单记录",@"营业数据",@"评价管理",@"会员统计",@"店铺设置",@"邀请"];
   
    [self.collectionview registerNib:[UINib nibWithNibName:@"POSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"POSCollectionViewCell"];
    self.collectionview.backgroundColor = [UIColor whiteColor];
    //注册表头
    [self.collectionview registerNib:[UINib nibWithNibName:@"StoreCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];

  
    //获取公告信息
    [self getData];
    //
    // Do any additional setup after loading the view.
}

-(void)getData
{
    //    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Notice",@"SelectField":@"*",@"Condition":@"ShopID$=$Mshop",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _dataArray=[AfivchModel getDataWithDic:dic1];
        [self.collectionview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
#pragma mark--collction
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
        
    }else
    {
        return _titleArray.count-2;
    }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    POSCollectionViewCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"POSCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section==0)
    {
        cell.backgroundColor=navigationBarColor;
        cell.name.font=[UIFont boldSystemFontOfSize:15];
        cell.name.textColor=[UIColor whiteColor];
        cell.name.text=_titleArray[indexPath.row];
         cell.img.image=[UIImage imageNamed:_imageArray[indexPath.row]];
    }else
    {
        cell.backgroundColor=[UIColor whiteColor];
        if (indexPath.row+3<_titleArray.count) {
            cell.name.text=_titleArray[indexPath.row+2];
            cell.name.font=[UIFont boldSystemFontOfSize:14];
            cell.name.textColor=[UIColor blackColor];
            cell.img.image=[UIImage imageNamed:_imageArray[indexPath.row+2]];
        }
  
    }
    

    return cell;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGSizeZero;
    }else
    {
        CGSize size = {screen_width,35};
        return size;
    }
  
    
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
//在表头内添加内容,需要创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 初始化表头
    
    StoreCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
    
    headerView.titileArray=_dataArray;
    DefineWeakSelf;
    headerView.tapClick=^(NSInteger index){
//        if (index!=0) {
//            [_dataArray exchangeObjectAtIndex:index withObjectAtIndex:0];
//        }
//        weakSelf.afichview=[[AficheView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, screen_height)];
//        weakSelf.afichview.dataArray=weakSelf.dataArray;
//        [self.view addSubview:_afichview];
        ZWHSystemViewController *vc = [[ZWHSystemViewController alloc]init];
        vc.dataArray = weakSelf.dataArray;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    return headerView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case SweepGathering:
            {
                //扫码收款
                SweepPayOneViewController*comm=[[SweepPayOneViewController alloc]init];
                comm.title=@"收款";
                
                [comm setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:comm animated:YES];
            
            }
                break;
//            case OnlineOrder:
//            {
//                //在线点餐
//                 [self isRegistMac];
//
//
//            }
//                break;
            case ExchangeCode:
            {
             
                
                //兑换验证
                ExchangeViewController *comm=[[ExchangeViewController alloc]init];
                comm.title=@"超值兑换";
                //            comm.funType=@"manager";
                [comm setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:comm animated:YES];
                
                
            }
                break;
                
            default:
                break;
        }
        
    }else
    {
        MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
            switch (indexPath.row) {
                case GatheringQRcode:
                {
                    //店铺二维码
                    ShopCodeViewController *comm=[[ ShopCodeViewController alloc]init];
                    comm.title=@"店铺二维码";
                    [comm setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:comm animated:YES];
                    
                }
                    break;
                case CollectRecorde:
                {
                    if ([model.IsReportManager isEqualToString:@"True"]) {
                        //收单单记录
                        BuyRecordViewController *comm=[[BuyRecordViewController alloc]init];
                        comm.title=@"买单记录";
                        
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
                    }else{
                        [QMUITips showInfo:@"您的权限不能访问此功能"];
                    }
                }
                    break;
                case BusinessData:
                {
                    if ([model.IsReportManager isEqualToString:@"True"]) {
                        //营业数据
                        FinanciaManagerViewController *comm=[[ FinanciaManagerViewController alloc]init];
                        comm.title=@"营业数据";
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
                    }else{
                        [QMUITips showInfo:@"您的权限不能访问此功能"];
                    }
                }
                    break;
                case EstimateManager:
                {
                    if ([model.IsSystemSet isEqualToString:@"True"]) {
                        //评价管理
                        EvaluatmanagViewController *comm=[[EvaluatmanagViewController alloc]init];
                        comm.title=@"评价管理";
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
                    }else{
                       [QMUITips showInfo:@"您的权限不能访问此功能"];
                    }
                    
                }
                    break;
                case MemberStatistics:
                {
                    if ([model.IsReportManager isEqualToString:@"True"]) {
                        //会员统计
                        MemManagerViewController *comm=[[MemManagerViewController alloc]init];
                        comm.title=@"会员统计";
                        comm.isAll=YES;
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
                    }else{
                        [QMUITips showInfo:@"您的权限不能访问此功能"];
                    }
                }
                    break;
                case ShopManager:
                {
                    if ([model.IsSystemSet isEqualToString:@"True"]) {
                        //店铺设置
                        StoreSetViewController *comm=[[StoreSetViewController alloc]init];
                        comm.title=@"店铺设置";
                        
                        [comm setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:comm animated:YES];
                    }else{
                        [QMUITips showInfo:@"您的权限不能访问此功能"];
                    }
                }
                    break;
//                case StockList:
//                {
//                    if ([model.IsSystemSet isEqualToString:@"True"]) {
//                        //股份
//                        ZWHSharesListViewController *vc = [[ZWHSharesListViewController alloc]init];
//                        [vc setHidesBottomBarWhenPushed:YES];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }else{
//                        [QMUITips showInfo:@"您的权限不能访问此功能"];
//                    }
//
//                }
//                    break;
                case Invitation:
                {
                    
                   //邀请
                    ZWHInviteCodeViewController *comm=[[ZWHInviteCodeViewController alloc]init];
                    [comm setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:comm animated:YES];
                }
                    break;
//                case OnlineFetchBill:
//                {
//
//                    //在线取单
//                    ZWHOrderOnlineViewController *comm=[[ZWHOrderOnlineViewController alloc]init];
//                    [comm setHidesBottomBarWhenPushed:YES];
//                    [self.navigationController pushViewController:comm animated:YES];
//                }
//                    break;
//                case PaiPaiCash:
//                {
//                    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
//                    if ([model.IsReportManager isEqualToString:@"True"]) {
//                        //派金设置
//                        ZWHGrantViewController *comm=[[ZWHGrantViewController alloc]init];
//                        [comm setHidesBottomBarWhenPushed:YES];
//                        [self.navigationController pushViewController:comm animated:YES];
//                    }else{
//                        [QMUITips showInfo:@"您的权限不能访问此功能"];
//                    }
//
//                }
//                    break;
                default:
                    break;
            }

            
        
    }
}
-(void)isRegistMac
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *uuid=[UUID getUUID];

    NSString *tableName=@"POSDN";
    NSString *SelectField=@"DN001,DN002,DN006";
    
    NSString *Condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$DN004$=$%@",_company,_shopid,uuid];
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:dic and:^(id responseObject)
     {
         NSDictionary *dict=[JsonTools getData:responseObject];
         NSDictionary *secDic=dict[@"DataSet"];
         NSString *status=(NSString *)dict[@"status"];
         
         if ([status integerValue] ==1) {
             
             NSArray *array=secDic[@"Table"];
             for (NSDictionary *dictionary in array) {
                 
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN001"] forKey:@"DN001"];
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN002"] forKey:@"DN002"];
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN006"] forKey:@"DN006"];
//                 NSLog(@"DN001:%@",dictionary[@"DN001"]);
//                 NSLog(@"DN002:%@",dictionary[@"DN002"]);
//                 NSLog(@"DN006:%@",dictionary[@"DN006"]);
                 [[NSUserDefaults standardUserDefaults] synchronize ];
             }
             
             [self getRunModel];
             
         }else
         {
             //直接注册
             [self addItemWithStr:uuid];
             
             
         }
         
         
     } Faile:^(NSError *error) {
         
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"注册Mac地址出错"];
     }];
}

//注册设备代码
-(void)addItemWithStr:(NSString*)str
{
   
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;

    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDN",@"Data":@[@{@"COMPANY":_company,@"SHOPID":_shopid,@"CREATOR":@"admin",@"DN002":@"admin",@"DN006":@"0001",@"DN004":str}]};
   
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
//     NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {

        NSString *str=[JsonTools getNSString:responseObject];

        if ([str isEqualToString:@"OK"])
        {
            //注册成功后重新获取设备编码
            [self isRegistMac];
            
        }else
        {
            
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getRunModel
{
    NSString *tableName=@"CMS_CommPara";
    NSString *SelectField=@"POS_RunModel";
    NSString *Condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",_company,_shopid];
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:dic and:^(id responseObject)
     {
         NSDictionary *dict=[JsonTools getData:responseObject];
         NSDictionary *secDic=dict[@"DataSet"];
         NSArray *array=secDic[@"Table"];
         for (NSDictionary *dictionary in array) {
             
             [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"POS_RunModel"] forKey:@"POS_RunModel"];
             NSLog(@"POS_RunModel:%@",dictionary[@"POS_RunModel"]);
             
             [[NSUserDefaults standardUserDefaults] synchronize ];
             
         }
         
         [self getGetBusinessDate];
         
     } Faile:^(NSError *error) {
         
     }];
    
}
-(void)getGetBusinessDate
{
    
    
    NSDictionary *dictionary=@{@"company":_company,@"shopid":_shopid};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetBusinessDate With:dictionary and:^(id responseObject)
     {
         NSString *dateStr=[JsonTools getNSString:responseObject];
         
         //         NSLog(@"date---%@",dateStr);
         [[NSUserDefaults standardUserDefaults]setValue:dateStr forKey:@"BusinessDate"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         NSLog(@"BusinessDate:%@",dateStr);
         NSArray *array=[dateStr componentsSeparatedByString:@","];
         if ([array[2] intValue]==0)
         {
             
             [SVProgressHUD dismiss];
             [self SetBusinessDate];
          
         }else
         {
             [self getClassInfo];
         }
     } Faile:^(NSError *error) {
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"获取BusinessDate出错"];
         
     }];
}
//设置营业日期
-(void)SetBusinessDate
{
    self.coverview=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.coverview];
    _businessView=[[NSBundle mainBundle]loadNibNamed:@"SetBusinessDateView" owner:nil options:nil][0];
    _businessView.layer.cornerRadius=8;
    _businessView.layer.masksToBounds=YES;
    [self.coverview addSubview:_businessView];
    
    [_businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(screen_width*0.8);
        make.height.mas_equalTo(147);
    }];
    
    __weak typeof(self)weakSelf=self;
    _businessView.doneBlock=^(NSString *str){
        [weakSelf setBusinessDataFromNetWithStr:str];
        [weakSelf.datePicker removeFromSuperview];
        [weakSelf.PickerView removeFromSuperview];
        [weakSelf.coverview removeFromSuperview];
        [weakSelf.tabBarController.tabBar setHidden:NO];
    };
    [self.tabBarController.tabBar setHidden:YES];
    [self creaPicker];
    
}
-(void)setBusinessDataFromNetWithStr:(NSString*)str
{
    NSString *deviceNo=[[NSUserDefaults standardUserDefaults]objectForKey:@"DN001"];
    NSDictionary *dic=@{@"company":_company,@"shopid":_shopid,@"userno":_userNo,@"deviceno":deviceNo,@"shopday":str};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"PosService.asmx/SetBusinessDate" With:dic and:^(id responseObject)
     {
         NSString *str=[JsonTools getNSString:responseObject];
         
         NSArray *array=[str componentsSeparatedByString:@","];
         //判断
         switch ([array[1] intValue]) {
             case 1:
             {
                 //已被其他终端设置营业
                 [self alertShowWithStr:@"已被其他终端设置营业"];
                 
             }
                 break;
             case 2:
             {
                 //营业日期设置成功
                 [SVProgressHUD showSuccessWithStatus:@"设置营业日期成功"];
                 [SVProgressHUD setMinimumDismissTimeInterval:0.5];
                 [SVProgressHUD showWithStatus:@"加载中"];
                 [self getGetBusinessDate];
             }
                 break;
             case 3:
             {
                 //营业日期已被作废，请重新选择
                 [self alertShowWithStr:@"营业日期已被作废，请重新选择"];
             }
                 break;
             case 4:
             {
                 //营业日期已经结业，请重新选择
                 [self alertShowWithStr:@"营业日期已经结业，请重新选择"];
             }
                 break;
                 
             default:
                 break;
         }
         
     } Faile:^(NSError *error) {
         
     }];
}
//创建时间选择器
-(void)creaPicker
{
    //
    _PickerView=[[UIView alloc]initWithFrame:CGRectMake(0, self.coverview.frame.size.height-250, self.coverview.frame.size.width, 250)];
    _PickerView.backgroundColor=[UIColor whiteColor];
    [self.coverview addSubview:_PickerView];
    
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
    
    //
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    
    //UIDatePicker显示样式
    
    _datePicker.datePickerMode =UIDatePickerModeDate;
    
    
    [_datePicker setLocale:[NSLocale systemLocale]];
    _datePicker.minuteInterval = 1;
    
    [_PickerView addSubview:_datePicker];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *defaultDate = [NSDate date];
    _businessView.textfield.text=[formatter stringFromDate:defaultDate];
    
    _datePicker.date = defaultDate;//设置UIDatePicker默认显示时间
    
}
-(void)commitB{
    
    
    if (_datePicker) {
        NSLog(@"_datePicker");
        
        NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        
        [forma setDateFormat:@"YYYY-MM-dd"];
        
        NSString *str = [forma stringFromDate:_datePicker.date]; //UIDatePicker显示的时间
        _businessView.textfield.text=str;
        
    }
    
    //    [self cancel];
    
}
-(void)cancel
{
    [_datePicker removeFromSuperview];
    [_PickerView removeFromSuperview];
    [_coverview removeFromSuperview];
    [self.tabBarController.tabBar setHidden:NO];
    
}
-(void)getClassInfo
{
    NSArray *dateArray= [[[NSUserDefaults standardUserDefaults]valueForKey:@"BusinessDate"] componentsSeparatedByString:@","];
    
    NSDictionary *dic=@{@"Company":_company,@"ShopID":_shopid,@"UserNo":_userNo,@"ShopDay":dateArray[1],@"DeviceNo":[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"]};
  
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetClassesInfo With:dic and:^(id responseObject)
     {
         NSString *ClassesInfo=[JsonTools getNSString:responseObject];
         
         //         NSLog(@"date---%@",ClassesInfo);
         [[NSUserDefaults standardUserDefaults]setValue:ClassesInfo forKey:@"ClassesInfo"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
//         NSLog(@"ClassesInfo:%@",ClassesInfo);
         
         NSArray *array=[ClassesInfo componentsSeparatedByString:@","];
         
         if ([array[3] intValue]==0)
         {   [SVProgressHUD dismiss];
             [self alertShowWithStr:@"资料设置不正确请联系管理员"];
             
         }else
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 
             });
             //此处判断模式
             NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
             //             runModel=@"01";
             //01餐厅 02快餐 03商超 04生鲜
             if ([runModel isEqualToString:@"01"])
             {
                 OrderViewController *combo=[[OrderViewController alloc]init];
                 
                 combo.title=@"选择房台";
                 [combo setHidesBottomBarWhenPushed:YES];
                 [self.navigationController pushViewController:combo animated:YES];
             }else if([runModel isEqualToString:@"02"])
             {
                 DownOrderViewController *combo=[[DownOrderViewController alloc]init];
                 combo.title=@"下单";
                 combo.runModel=runModel;
                 [combo setHidesBottomBarWhenPushed:YES];
                 [self.navigationController pushViewController:combo animated:YES];
                 
                 
             }else if ([runModel isEqualToString:@"03"])
             {
                 [self alertShowWithStr:@"商城模式暂未开放"];
             }else
             {
                 [self alertShowWithStr:@"生鲜模式暂未开放"];
             }
             
         }
         
         
         
         
     } Faile:^(NSError *error) {
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"获取GetClassesInfo出错"];
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
      
//        if ((indexPath.row % 3) == 0) {
//            return CGSizeMake((ScreenWidth - (int)(ScreenWidth/3.0) - (int)(ScreenWidth/3.0)), (int)ScreenWidth/3.0);
//        }
        if (indexPath.item % 2 == 1) {
            return CGSizeMake(ScreenWidth - (int)(ScreenWidth/2.0), (int)ScreenWidth/3.0);
        }
        return CGSizeMake((int)(ScreenWidth/2.0), (int)ScreenWidth/3.0);
    }else
    
    return CGSizeMake(screen_width/4 , screen_width/4);
    
}
////设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    if (section==0)
    {
        return  UIEdgeInsetsZero;
    }else
    {
      return  UIEdgeInsetsMake(0,0,20,0);
    }
    

}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
      if (section==0)
      {
          return 0;
      }else
      {
           return 0;
      }
         
  
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }else
    {
        return 0;
    }
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
