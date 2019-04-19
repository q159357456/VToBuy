//
//  ReserveTimeViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ReserveTimeViewController.h"
#import "NSDate+Extension.h"
#import "ClassTableViewCell.h"
#import "TimeTableViewCell.h"
#import "seatTimeModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ReserveDetailViewController.h"
@interface ReserveTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
//日期表
@property(nonatomic,strong)UITableView *dateTable;
//时间表
@property(nonatomic,strong)UITableView *timeTable;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableArray *timeArray;

@property(nonatomic,copy)NSString *timeString;

@end

@implementation ReserveTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"选择预定时间";
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData
{
    _dateArray=[NSMutableArray array];
    _timeArray=[NSMutableArray array];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    
    [formatter setDateFormat:@"YYY/MM/dd"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];//将NSDate  ＊对象 转化为 NSString ＊对象。
    [_dateArray addObject:currentTime];
    for (NSInteger i=1; i<=6; i++) {
        NSDate *nextDate=[[NSDate date] dateByAddingDays:i];
        NSString *str=[formatter stringFromDate:nextDate];
        [_dateArray addObject:str];
    }
      [_dateTable reloadData];
    [self.view addSubview:_dateTable];
    [self selectFirst];
    
}
-(void)selectFirst
{
    if (_dateArray.count>0)
    {
        NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_dateTable selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
        NSIndexPath * path = [NSIndexPath indexPathForItem:0  inSection:0];
        [self tableView:_dateTable didSelectRowAtIndexPath:path];
    }
    
}
-(void)createUI
{
    
    _dateTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 120, screen_height-64) style:UITableViewStylePlain];
    _dateTable.delegate=self;
    _dateTable.dataSource=self;
    _dateTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _dateTable.showsHorizontalScrollIndicator=NO;
    _dateTable.backgroundColor=[UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1];
    [_dateTable registerNib:[UINib nibWithNibName:@"ClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"classCell"];
    
    _timeTable=[[UITableView alloc]initWithFrame:CGRectMake(120, 64, screen_width-120,screen_height-64) style:UITableViewStylePlain];
    _timeTable.delegate=self;
    _timeTable.dataSource=self;
    [_timeTable registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    _timeTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_dateTable) {
        return _dateArray.count;
    }else
    {
        return _timeArray.count;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==_dateTable) {
        return @"日期";
    }else
    {
        return @"时间";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_dateTable) {
        ClassTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
        
//        UIImageView *bgView=[[UIImageView alloc]initWithFrame:cell.frame];
//        NSString *imagePath=[[NSBundle mainBundle]pathForResource:@"cellSelect" ofType:@"png"];
//        UIImage *selImage=[UIImage imageWithContentsOfFile:imagePath];
//        bgView.image=selImage;
//        [cell setSelectedBackgroundView:bgView];
//        
//        UIImageView *bView=[[UIImageView alloc]initWithFrame:cell.frame];
//        NSString *imagePath1=[[NSBundle mainBundle]pathForResource:@"cellBg" ofType:@"png"];
//        UIImage *image1=[UIImage imageWithContentsOfFile:imagePath1];
//        bView.image=image1;
//        [cell setBackgroundView:bView];
        
        cell.classLabel.text=_dateArray[indexPath.row];
        
        
        return cell;
    }else
    {
        TimeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        seatTimeModel *model=_timeArray[indexPath.row];
        [cell loadDataWithModel:model];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        __weak typeof(self)weakSelf=self;
        cell.writeSeatInfoBlock=^(){
            NSString *string=[_timeString stringByAppendingString:[NSString stringWithFormat:@" %@",model.t1]];
            ReserveDetailViewController *detail=[[ReserveDetailViewController alloc]init];
            detail.title=@"填写预订信息";
            detail.model=_model;
            detail.timeStr=string;
            [weakSelf.navigationController pushViewController:detail animated:YES
             ];
            
        };
        
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_dateTable) {
        NSLog(@"indexPath.row-----------%ld",(long)indexPath.row);
        NSLog(@"--%@",_dateArray[indexPath.row]);
        _timeString=_dateArray[indexPath.row];
        [self getTimeDataWithDate:_dateArray[indexPath.row]];
        
    }
    
    
}

-(void)getTimeDataWithDate:(NSString *)date
{
    [_timeArray removeAllObjects];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary*dic=@{@"strCompany":model.COMPANY,@"strShopID":model.SHOPID,@"strDate":date,@"strSeat":self.model.SI001};
  
    NSString *URLPATH=[NSString stringWithFormat:@"%@/PosService.asmx/GetPreSeatInfo",ROOTPATH];
    
    [manager GET:URLPATH parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        NSDictionary *dict=[JsonTools getData:responseObject];
 
        NSDictionary *secDic=dict[@"DataSet"];
        
        NSArray *array=secDic[@"POSSTT"];
      
        for (NSDictionary *dicc in array) {
            seatTimeModel *model=[[seatTimeModel alloc]init];
            [model setValuesForKeysWithDictionary:dicc];
            [_timeArray addObject:model];
        }
    
        [_timeTable reloadData];
        [self.view addSubview:_timeTable];
        
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_dateTable) {
        return 60;
        
    }else
    {
        return 100;
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
