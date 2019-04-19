//
//  DateFormsViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "DateFormsViewController.h"
#import "reportFormsTableViewCell.h"
#import "SZCalendarPicker.h"
#import "DateFormsDetailViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface DateFormsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@end

@implementation DateFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    [self initLabel];
    
    [self initItemView];
    
    [self initFormsTable];
    
    [self getAllData];
}

-(void)getAllData
{
    //@"EI003$>=$2016/1/1$AND$EI003$<=$2017/1/1"
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
        NSString *date1 = _beginLabel.text;
        NSString *date2 = _endLabel.text;
    NSString *conditionString = [NSString stringWithFormat:@"EI003$>=$%@$AND$EI003$<=$%@$AND$COMPANY$=$%@$AND$SHOPID$=$%@",date1,date2,self.model.COMPANY,self.model.SHOPID];
    NSDictionary *dic = @{@"FromTableName":@"POSEI",@"SelectField":@"*",
                          @"Condition":conditionString,@"SelectOrderBy":@"EI003",@"Page":@"0",@"PageSize":@"10",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo4" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [DateFormsModel getDataWithDic:dic1];
        [_formsTable reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)initLabel
{
    _lab1.layer.borderWidth = 1;
    _lab1.layer.cornerRadius = 5;
    //_beginLabel.text=[self getCurrentTime];
    _lab1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lab2.layer.borderWidth = 1;
    _lab2.layer.cornerRadius = 5;
    _lab2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _endLabel.text=[self getCurrentTime];
}
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)initItemView
{
    NSArray *title = @[@"营业日期",@"结业时间",@"交班机器",@"单据数量"];
    _ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, screen_width, 40)];
    _ItemView.backgroundColor = navigationBarColor;
    
    for (int i = 0; i<title.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((screen_width/4)*i, 0, screen_width/4, 40)];
        lab.text = title[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [self.ItemView addSubview:lab];
    }
    [self.view addSubview:_ItemView];
}

-(void)initFormsTable
{
    self.formsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 144, screen_width, screen_height-144) style:UITableViewStyleGrouped];
    self.formsTable.delegate = self;
    self.formsTable.dataSource = self;
    
    [self.formsTable registerNib:[UINib nibWithNibName:@"reportFormsTableViewCell" bundle:nil] forCellReuseIdentifier:@"reportFormsTableViewCell"];
    [self.view addSubview:_formsTable];
}

- (IBAction)btn1Click:(id)sender {
    NSLog(@"日历弹出按钮被点击");
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
        NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
        _beginLabel.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        [self getAllData];
    };
}
- (IBAction)btn2Click:(id)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
        NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
        _beginLabel.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        [self getAllData];
    };
}
- (IBAction)btn3Click:(id)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
        NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
        _endLabel.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        [self getAllData];
    };
}
- (IBAction)btn4Click:(id)sender {

    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
        NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
        _endLabel.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DateFormsModel *model = _dataArray[indexPath.row];
    static NSString *cellid = @"reportFormsTableViewCell";
    reportFormsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"reportFormsTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel1:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DateFormsModel *model = _dataArray[indexPath.row];
    DateFormsDetailViewController *DFDVC = [[DateFormsDetailViewController alloc] init];
    DFDVC.title = @"日结报表明细";
    DFDVC.dModel = model;
    [self.navigationController pushViewController:DFDVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
