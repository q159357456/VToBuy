//
//  ClipManagerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ClipManagerViewController.h"
#import "AddClipViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "CouponModel.h"
#import "ClipDetailViewController.h"
#import "BargainManagerViewController.h"
#import "BargainDetailrViewController.h"
#import "ClipManagerTableViewCell.h"
#import "NSDate+Extension.h"
#import "ZWHAddCardViewController.h"
#import "ZWHShareQRViewController.h"


@interface ClipManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PlaceholderView *placeView;
@property(nonatomic,strong)NSDate *creentDate;
@end

@implementation ClipManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    _doneButton.backgroundColor=MainColor;
    
    if ([_funType isEqualToString:@"KanJia"])
    {
        [_doneButton setTitle:@"添加砍价商品" forState:UIControlStateNormal];
        [self getKanJiaData];
    }else
    {
         [self getAllData];
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllData) name:@"refreshCard" object:nil];
}
-(NSDate *)creentDate
{
    if (!_creentDate) {
        _creentDate=[NSDate date];
    }
    return _creentDate;
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
-(void)getKanJiaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"Sales_Bargain",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@",model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _dataArray=[CouponModel getDataWithDic:dic1];
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.tableview reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
      MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSLog(@"%@",model.SHOPID);
    NSDictionary *dic=@{@"FromTableName":@"sales_coupon",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@",model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"----%@",dic1);
        _dataArray=[CouponModel getDataWithDic:dic1];
        
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.tableview reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

#pragma mark - 分享二维码
-(void)shareQRWith:(QMUIButton *)btn{
    ZWHShareQRViewController *vc = [[ZWHShareQRViewController alloc]init];
    vc.coumodel = _dataArray[btn.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponModel *model=_dataArray[indexPath.row];
    static NSString *ClipManagerTableViewCell_ID = @"ClipManagerTableViewCell_id";
    ClipManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClipManagerTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ClipManagerTableViewCell" owner:nil options:nil][0];
    }
   
       if ([_funType isEqualToString:@"KanJia"])
       {
           cell.titleImage.image=[UIImage imageNamed:@"kanjia"];
            cell.lable1.text=[NSString stringWithFormat:@"%@砍价活动,最低砍至%@元",model.ProductName, model.Price2];
      
       }else
       {
        cell.lable4.text=[NSString stringWithFormat:@"¥%@",[model.Amount2 removeZeroWithStr]];
           cell.lable1.text=[NSString stringWithFormat:@"满%@元立减%@元",model.Amount1,model.Amount2];
           if (model.UDF01.length>0) {
               cell.shareBtn.hidden = NO;
               cell.shareBtn.tag = indexPath.row;
               [cell.shareBtn addTarget:self action:@selector(shareQRWith:) forControlEvents:UIControlEventTouchUpInside];
           }
           
       }
    
    if ([self.creentDate isLaterThanDate:[self endateWithStr:model.EndDate]])
    {
        //过期

        cell.statuImage.image=[UIImage imageNamed:@"clip_5"];
        
    }else
    {
        //没有过期

        cell.statuImage.image=[UIImage imageNamed:@"clip_6"];
        
    }
    cell.lable2.text=[NSString stringWithFormat:@"已领取%@/%@",model.Quantity2,model.Quantity1];
    cell.lable3.text=[NSString stringWithFormat:@"已使用%@/%@",model.Quantity3,model.Quantity2];
   

    return cell;
    
}
-(NSDate*)endateWithStr:(NSString*)end;
{
 
    //结束时间
    NSArray *array1=[end componentsSeparatedByString:@"/"];
    
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
    return endDate;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       if ([_funType isEqualToString:@"KanJia"])
       {
           CouponModel *model=_dataArray[indexPath.row];
           BargainDetailrViewController*comm=[[BargainDetailrViewController alloc]init];
           comm.title=@"砍价明细";
           comm.model=model;
           
           [self.navigationController pushViewController:comm animated:YES];
           
       }else
       {
           CouponModel *model=_dataArray[indexPath.row];
           ClipDetailViewController*comm=[[ClipDetailViewController alloc]init];
           comm.title=@"卡券明细";
           comm.clipID=model.ID;
           comm.Amount1=model.Amount1;
           comm.Amount2=model.Amount2;
           comm.Quantity2=model.Quantity2;
           comm.Quantity3=model.Quantity3;
           comm.EndDate=model.EndDate;
           [self.navigationController pushViewController:comm animated:YES];
       }
  
}
- (IBAction)zwhAddCard:(id)sender {
    ZWHAddCardViewController *vc = [[ZWHAddCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)add:(UIButton *)sender
{
       if (![_funType isEqualToString:@"KanJia"])
       {
           AddClipViewController*comm=[[AddClipViewController alloc]init];
           comm.title=@"新增卡券";
           __weak typeof(self)weakSelf=self;
           comm.backBlock=^{
               [weakSelf getAllData];
           };
           
           [self.navigationController pushViewController:comm animated:YES];

       }else
       {
                       BargainManagerViewController*combo=[[BargainManagerViewController alloc]init];
                       combo.title=@"砍价管理";
           DefineWeakSelf;
           combo.backBlock=^{
               [weakSelf getKanJiaData];
           };
           
                       [self.navigationController pushViewController:combo animated:YES];

       }


}



@end
