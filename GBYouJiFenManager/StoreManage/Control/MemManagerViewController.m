//
//  MemManagerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MemManagerViewController.h"
#import "StoreTwoTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "MSModel.h"
#import "CoverView.h"
#import "ChooseTableViewCell.h"
#import "SZCalendarPicker.h"
#import "NSDate+Extension.h"
#import "MemberTableViewCell.h"
#import "BuyRecordViewController.h"
@interface MemManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
        SZCalendarPicker *calendarPicker;
    
}
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UILabel *add;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property(nonatomic,strong)MemberModel *model;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UIView *totalView;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *BottomView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UITableView *tableView2;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,assign)NSInteger seleIndex;
@property(nonatomic,copy)NSString *stateString;
@property(nonatomic,copy)NSString *endString;
@property(nonatomic,copy)NSString *CstateString;
@property(nonatomic,copy)NSString *CendString;
@property(nonatomic,copy)NSString *orderby;
@property(nonatomic,strong)PlaceholderView *placeView;
@end

@implementation MemManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    self.backView.layer.borderWidth=1;
    self.backView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.totalView.backgroundColor=navigationBarColor;
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    //获取当前日期
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    _endString = [dateFormatter stringFromDate:nowDate];
    
    
    //获取开始日期
    NSDate *startDate=[nowDate dateBySubtractingDays:30];
    _stateString=[dateFormatter stringFromDate:startDate];
    [_button1 setTitle:[NSString stringWithFormat:@"%@至%@",_stateString,_endString]forState:UIControlStateNormal];
    [_button2 setTitle:@"默认排序方式" forState:UIControlStateNormal];
    if (screen_width==320) {
        _button1.titleLabel.font=[UIFont systemFontOfSize:12];
        _button2.titleLabel.font=[UIFont systemFontOfSize:14];
    }else
    {
        _button1.titleLabel.font=[UIFont systemFontOfSize:14];
        _button2.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    if (_isAll) {
        [self getAlldCount];
    }else
        
    [self GetShopMemberCount];
    // Do any additional setup after loading the view from its nib.
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableView.frame;
    }
    return _placeView;
}
#pragma mark 统计所有买单人员的记录

-(void)getAllPeopleRecord
{
    
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID,@"PageIndex":@"0",@"PageSize":@"0",@"orderby":self.orderby,@"startDate":_stateString,@"endDate":_endString};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopAllMemberInfo" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"------%@",dic1);
        _dataArray=[MSModel getDataWithDic:dic1];
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.tableView reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getAlldCount
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopAllMemberCount" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        //        _total.text=[NSString stringWithFormat:@"本月会员%@",dic1[@"DataSet"][@"Table"][0][@"MemberAllTotal"]];
        //        _add.text=[NSString stringWithFormat:@"本月新增%@",dic1[@"DataSet"][@"Table"][0][@"MemberCurrentMonthTotal"]];
        _lable1.text=dic1[@"DataSet"][@"Table"][0][@"MemberAllTotal"];
        _lable2.text=dic1[@"DataSet"][@"Table"][0][@"MemberCurrentMonthTotal"];
        NSLog(@"%@",dic1);
        [self getAllPeopleRecord];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

        

}
- (IBAction)button1Click:(UIButton *)sender
{
    //时间选择
    calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.isAnnimation=YES;
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 175-64, self.view.frame.size.width, 352);
    DefineWeakSelf;
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        [weakSelf changeButtonWith:year :month :day];
        
    };
    calendarPicker.backBlock=^{
        [weakSelf.topView removeFromSuperview];
        [weakSelf.BottomView removeFromSuperview];
    };
    [self creatTopView];
    [self creatBottomView];

    
}
-(void)changeButtonWith:(NSInteger)year :(NSInteger)month :(NSInteger)day
{
    UIButton *start=(UIButton*)[self.view viewWithTag:1];
    UIButton *end=(UIButton*)[self.view viewWithTag:2];
    NSArray *array=@[start,end];
    for (UIButton *butt in array) {
        if (butt.selected==YES) {
            NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
            NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
            if (butt.tag==1)
            {
                [butt setTitle:[NSString stringWithFormat:@"起始时间(%ld/%@/%@)",(long)year,Tmonth,Tday] forState:UIControlStateNormal];
                _CstateString=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
                
            }else
            {
                [butt setTitle:[NSString stringWithFormat:@"结束时间(%ld/%@/%@)",(long)year,Tmonth,Tday] forState:UIControlStateNormal];
                _CendString=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
            }
            
            //            butt.titleLabel.text=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        }
    }
}

- (IBAction)button2Click:(UIButton *)sender
{
    [self creatTable];
    
    
}
-(void)creatTable
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [window addSubview:_coverView];
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.showsHorizontalScrollIndicator=NO;
    _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(0,150+64,screen_width ,48*2) style:UITableViewStylePlain];
    
    _tableView2.delegate=self;
    _tableView2.dataSource=self;
    
    
    //        _tableView2.transform=CGAffineTransformMakeTranslation(0,-44*3);
    //        [UIView animateWithDuration:0.3 animations:^{
    //
    //            _tableView2.transform=CGAffineTransformIdentity;
    //
    //        }];
    
    [_coverView addSubview:_tableView2];
    
    
    
}
-(void)creatTopView
{
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0,130-64, self.view.width, 45)];
    self.topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    NSArray *nameArray=@[[NSString stringWithFormat:@"起始时间(%@)",_stateString],[NSString stringWithFormat:@"结束时间(%@)",_endString]];
    
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(self.topView.width/nameArray.count*i,0,self.topView.width/nameArray.count-1,40);
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(self.topView.width/nameArray.count*i+20,40,self.topView.width/nameArray.count-40, 2)];
        lineView.backgroundColor=MainColor;
        lineView.tag=i+11;
        [self.topView addSubview:lineView];
        if (lineView.tag==11) {
            lineView.hidden=NO;
        }else
        {
            lineView.hidden=YES;
        }
        
        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:MainColor forState:UIControlStateSelected];
        if (screen_width==320) {
            button.titleLabel.font=[UIFont systemFontOfSize:12];
        }else
        {
            button.titleLabel.font=[UIFont systemFontOfSize:14];
        }

        button.backgroundColor=[UIColor whiteColor];
        button.tag=i+1;
        if (button.tag==1)
        {
            button.selected=YES;
            self.seleIndex=1;
        }
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        
        
    }
    
}
-(void)touch:(UIButton*)sender
{
    if (sender.tag==_seleIndex)
    {
        return;
    }else
    {
        UIButton *button=(UIButton*)[self.view viewWithTag:_seleIndex];
        button.selected=NO;
        UIView *line=[self.view viewWithTag:_seleIndex+10];
        line.hidden=YES;
        sender.selected=YES;
        self.seleIndex=sender.tag;
        UIView *Sline=[self.view viewWithTag:sender.tag+10];
        Sline.hidden=NO;

    }
    
    
    
}
-(void)creatBottomView
{
    self.BottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 175+352-64, self.view.width, 50)];
    self.BottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.BottomView];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(30,5,self.BottomView.width-60,40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:19];
    button.backgroundColor=MainColor;
    [self.BottomView addSubview:button];
    [button addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)queding
{

    if (_CstateString.length) {
        _stateString=_CstateString;
    }
    if (_CendString.length) {
        _endString=_CendString;
    }
    [_button1 setTitle:[NSString stringWithFormat:@"%@至%@",_stateString,_endString] forState:UIControlStateNormal];
    [self.topView removeFromSuperview];
    [self.BottomView removeFromSuperview];
    [calendarPicker removeFromSuperview];
    [calendarPicker.mask removeFromSuperview];
    if (_isAll) {
        [self getAlldCount];
    }else
        
        [self GetShopMemberCount];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)orderby
{
    if (!_orderby) {
        _orderby=@"";
    }
    return _orderby;
}
-(void)getMemberData
{

    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID,@"PageIndex":@"0",@"PageSize":@"20",@"orderby":self.orderby,@"startDate":_stateString,@"endDate":_endString};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopMemberInfo" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        _dataArray=[MSModel getDataWithDic:dic1];
        [self.tableView reloadData];

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)GetShopMemberCount
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopMemberCount" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        _total.text=[NSString stringWithFormat:@"本月会员%@",dic1[@"DataSet"][@"Table"][0][@"MemberAllTotal"]];
//        _add.text=[NSString stringWithFormat:@"本月新增%@",dic1[@"DataSet"][@"Table"][0][@"MemberCurrentMonthTotal"]];
        _lable1.text=dic1[@"DataSet"][@"Table"][0][@"MemberAllTotal"];
        _lable2.text=dic1[@"DataSet"][@"Table"][0][@"MemberCurrentMonthTotal"];
        NSLog(@"%@",dic1);
        [self getMemberData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    if (tableView==_tableView2)
    {
        return 2;
    }else
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tableView2)
    {
        
       ChooseTableViewCell *cell= [[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        if (indexPath.row==0)
        {
            cell.contentLable.text=@"按订单金额排序";
        }else
        {
             cell.contentLable.text=@"按订单笔数排序";
        }
        return cell;
    }else
    {
        MSModel *model=_dataArray[indexPath.row];
        static NSString *AddDetailTableViewCell_ID = @"MemberTableViewCell";
        MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"MemberTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.lable1.text=model.ms002;
        cell.lable3.text=model.Amount;
        cell.lable4.text=[NSString stringWithFormat:@"%@",model.BuyCount];
        cell.lable2.text=model.ms008;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.udf06] placeholderImage:[UIImage imageNamed:@"shzx2"]];
     
        return cell;

    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (tableView==_tableView2)
      {
          return 48;
      }else
      {
            return 80;
      }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_tableView2)
    {
        return 0.01;
    }else
    {
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView2) {
        if (indexPath.row==0)
        {
           
            self.orderby=@"amount";
             [_button2 setTitle:@"按订单金额排序" forState:UIControlStateNormal];
        }else
        {
            self.orderby=@"buycount";
             [_button2 setTitle:@"按订单笔数排序" forState:UIControlStateNormal];
        }
       
        [_tableView2 removeFromSuperview];
        [_coverView removeFromSuperview];
        if (_isAll) {
            [self getAlldCount];
        }else
            
            [self GetShopMemberCount];
    }else
    {
        MSModel *model=_dataArray[indexPath.row];
        BuyRecordViewController *buy=[[BuyRecordViewController alloc]init];
        buy.title=[NSString stringWithFormat:@"%@的买单纪录",model.ms002];
        buy.memberno=model.ms001;
        [self.navigationController pushViewController:buy animated:YES];
    }
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
