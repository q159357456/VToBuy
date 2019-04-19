//
//  ClipDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/17.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ClipDetailViewController.h"
#import "ClipDetailTableViewCell.h"
#import "CouponModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "NSString+addtion.h"
@interface ClipDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property (strong, nonatomic) IBOutlet UILabel *lable4;
@property (strong, nonatomic) IBOutlet UILabel *lable5;
@property(nonatomic,strong)MemberModel *model;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *endLable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ClipDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLable];
    
    _dataArray=[NSMutableArray array];
    [self getClipDetail];
}
-(void)initLable
{
       if ([self.type isEqualToString:@"SALES_Fullcut"])
       {
            _lable1.text=[NSString stringWithFormat:@"立减%@元",[_Amount2 removeZeroWithStr]];
       }else
       {
            _lable1.text=[NSString stringWithFormat:@"%@元优惠",[_Amount2 removeZeroWithStr]];
       }
   
    _lable2.text=[NSString stringWithFormat:@"满%@元可用",[_Amount1 removeZeroWithStr]];
    _endLable.text=[NSString stringWithFormat:@"结束时间:%@",_EndDate];
        if (![self.type isEqualToString:@"SALES_Fullcut"])
        {
            _lable4.text=[NSString stringWithFormat:@"已使用%@",_Quantity3];
            _lable3.text=[NSString stringWithFormat:@"已领取%@",_Quantity2];
       
            
        }else
        {
            if (!_Quantity3) {
                _Quantity3=@"0";
            }
              _lable3.text=[NSString stringWithFormat:@"已使用%@",_Quantity3];
        }
   
}
-(MemberModel *)model
{
    if (!_model) {
        _model=[[FMDBMember shareInstance]getMemberData][0];
        
    }
    return _model;
    
}

#pragma mark-data
//先获取卡券的明细
-(void)getClipDetail
{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@$AND$A.ID$=$%@",self.model.SHOPID,self.model.COMPANY,self.clipID];
    NSDictionary *dic;
    if ([self.type isEqualToString:@"SALES_Fullcut"])
    {
          dic=@{@"FromTableName":@"SALES_Fullcut[A]||crmMS[B]{left ( A.MemberNo=B.MS001)}",@"SelectField":@"A.*,B.MS001,B.MS002,B.UDF06",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }else
    {
          dic=@{@"FromTableName":@"sales_couponms[A]||crmMS[B]{left ( A.MemberNo=B.MS001)}",@"SelectField":@"A.*,B.MS001,B.MS002,B.UDF06 HEADIMG",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
   
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        _dataArray=[CouponModel getDataWithDic:dic1];
        if (_dataArray.count==0)
        {
              _lable5.text=@"还没有人使用优惠";
           
        }else
        {
           _lable5.text=@"以下小伙伴已经使用";
        }
        [self.tableview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponModel *model=_dataArray[indexPath.row];
    static NSString *FullcutTableViewCell_ID = @"FullcutTableViewCell_id";
    ClipDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FullcutTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ClipDetailTableViewCell" owner:nil options:nil][0];
    }

    cell.nameLable.text=model.MS002;
    cell.dateLable.text=model.GetDate;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.HEADIMG] placeholderImage:[UIImage imageNamed:@"holder"]];
    if ([model.Status isEqualToString:@"Y"])
    {
        cell.satteLable.textColor=[UIColor lightGrayColor];
        cell.satteLable.text=@"已使用";
    }else
    {
        
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}




@end
