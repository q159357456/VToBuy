//
//  FullcutViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/17.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FullcutViewController.h"
#import "AddFullViewController.h"
#import "FullcutTableViewCell.h"
#import "ClipManagerTableViewCell.h"
#import "CouponModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ClipDetailViewController.h"
#import "NSDate+Extension.h"
@interface FullcutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PlaceholderView *placeView;
@property(nonatomic,strong)NSDate *creentDate;

@end

@implementation FullcutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _done.backgroundColor=MainColor;
    _dataArray=[NSMutableArray array];
    [self getAllData];
    // Do any additional setup after loading the view from its nib.
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"SALES_Fullcut",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@",model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
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

#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponModel *model=_dataArray[indexPath.row];
    static NSString *FullcutTableViewCell_ID = @"FullcutTableViewCell_id";
    ClipManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FullcutTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ClipManagerTableViewCell" owner:nil options:nil][0];
    }
        cell.lable4.text=[NSString stringWithFormat:@"¥%@",[model.Amount2 removeZeroWithStr]];
        cell.lable3.hidden=YES;
        cell.lable1.text=[NSString stringWithFormat:@"满%@元立减%@元",model.Amount1,model.Amount2];
        cell.lable2.text=[NSString stringWithFormat:@"已领取%@/%@",model.Quantity2,model.Quantity1];
    
    if ([self.creentDate isLaterThanDate:[self endateWithStr:model.EndDate]])
    {
        //过期
        
        cell.statuImage.image=[UIImage imageNamed:@"clip_5"];
        
    }else
    {
        //没有过期
        
        cell.statuImage.image=[UIImage imageNamed:@"clip_6"];
        
    }
    DefineWeakSelf;
    cell.deletCallBack = ^{
        if (model.ID) {
             [weakSelf deletFullMinse:model.ID];
        }
    };
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

-(NSDate *)creentDate
{
    if (!_creentDate) {
        _creentDate=[NSDate date];
    }
    return _creentDate;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CouponModel *model=_dataArray[indexPath.row];
    ClipDetailViewController*comm=[[ClipDetailViewController alloc]init];
    comm.title=@"满减明细";
    comm.clipID=model.ID;
    comm.Amount1=model.Amount1;
    comm.Amount2=model.Amount2;
    comm.Quantity2=model.Quantity2;
    comm.Quantity3=model.Quantity3;
    comm.EndDate=model.EndDate;
    comm.type=@"SALES_Fullcut";
    [self.navigationController pushViewController:comm animated:YES];
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

- (IBAction)done:(UIButton *)sender {
    AddFullViewController*comm=[[AddFullViewController alloc]init];
    comm.title=@"新增卡券";
    __weak typeof(self)weakSelf=self;
    comm.backBlock=^{
        [weakSelf getAllData];
    };
    
    [self.navigationController pushViewController:comm animated:YES];

}


//删除满减
-(void)deletFullMinse:(NSString*)fullid{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Del",@"TableName":@"SALES_Fullcut",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ID":fullid}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonStr);
    DefineWeakSelf;
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakSelf getAllData];
               
            });
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:str];
            
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
