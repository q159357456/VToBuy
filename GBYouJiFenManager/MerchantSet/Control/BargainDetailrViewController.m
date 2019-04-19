//
//  BargainDetailrViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/5.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BargainDetailrViewController.h"
#import "NSDate+Extension.h"
@interface BargainDetailrViewController ()
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UILabel *alredyJoin;
@property (strong, nonatomic) IBOutlet UILabel *alreadyBuy;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *hour;
@property (strong, nonatomic) IBOutlet UILabel *minute;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UILabel *timeOver;

@end

@implementation BargainDetailrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self getClipDetail];
    [self getMinceTime];
    // Do any additional setup after loading the view from its nib.
}
//获得时间差
-(void)getMinceTime
{

    //当前时间
    NSDate *nowDate=[NSDate date];
    //结束时间
    NSArray *array1=[_model.EndDate componentsSeparatedByString:@"/"];
 
    NSString *month=array1[1];
    if (month.length==1) {
        month=[NSString stringWithFormat:@"%02d",month.intValue];
        
    }
    NSArray *array2=[array1[2] componentsSeparatedByString:@" "];
    NSString *day=array2[0];
    if (day.length==1) {
       day=[NSString stringWithFormat:@"%02d",day.intValue];
    }
  

    NSMutableString *newTimeStr=[NSMutableString stringWithString:array1[0]];
    [newTimeStr appendString:[NSString stringWithFormat:@"-%@",month]];
    [newTimeStr appendString:[NSString stringWithFormat:@"-%@",day]];
    [newTimeStr appendString:[NSString stringWithFormat:@" %@",array2[1]]];
    NSDate *endDate=[NSDate date:newTimeStr WithFormat:@"YYYY-MM-dd HH:mm:ss"];


    //间隔时间
    NSInteger miniute=[nowDate minutesBeforeDate:endDate];
    if (miniute>0)
    {
        //转换
        NSInteger minceDay=miniute/1440;
        NSInteger minceHoure=miniute%1440/60;
        NSInteger minceMinuite=miniute%1440%60;
      
        _day.text=[NSString stringWithFormat:@"%ld",minceDay];
        _hour.text=[NSString stringWithFormat:@"%ld",minceHoure];
        _minute.text=[NSString stringWithFormat:@"%ld",minceMinuite];
       
        
    }else
    {
        _timeOver.backgroundColor=navigationBarColor;
        _timeOver.text=@"该活动已过期";
    }
    _backView.backgroundColor=navigationBarColor;
    _priceLable.text=[NSString stringWithFormat:@"产品底价:%@",_model.Amount2];
    _timeView.layer.cornerRadius=5;
    _timeView.layer.masksToBounds=YES;
    
    
   

}
#pragma mark-data
//先获取卡券的明细
-(void)getClipDetail
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"ID$=$%@",self.model.ID];
    
    NSDictionary *dic=@{@"FromTableName":@"Sales_Bargain[A]||crmMS[B]{left (A.shopid=B.shopid and A.MemberNo=B.MS001)}",@"SelectField":@"A.*,B.MS001,B.MS002",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
            NSLog(@"---%@",dic1);
        
//        _dataArray=[CouponModel getDataWithDic:dic1];
        //        NSLog(@"-----%ld",_dataArray.count);
//        [self.tableview reloadData];
        
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
