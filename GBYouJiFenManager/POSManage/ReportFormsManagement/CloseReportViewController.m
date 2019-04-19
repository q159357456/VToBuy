//
//  CloseReportViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 xia. All rights reserved.


#import "CloseReportViewController.h"
#import "ChooseTableViewCell.h"
#import "reportFormsTableViewCell.h"
#import "SZCalendarPicker.h"
#import "CloseReportDetailViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"

@interface CloseReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end


@implementation CloseReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  _model=[[FMDBMember shareInstance]getMemberData][0];
  _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];

    [self initArray];
    
    [self initLabel];
    
    [self initItemView];
    
    [self initCloseReportTable];
    
    [self getAllData];
    
    [self getClassData];
    
    [self getAreaData];
}

-(void)initArray
{
    self.dataArray = [NSMutableArray array];
    self.classArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
}
-(void)getClassData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSCS",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    NSLog(@"---%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
    
      _classArray = [classesModel getDataWithDic:dic1];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getAreaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        _areaArray = [FloorModel getDataWithDic:dic1];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}  

-(void)getAllData
{
    //@"PI003$>=$2016/1/1$AND$PI003$<=$2017/1/1$AND$area$LIKE$%%$AND$PI004$LIKE$%B001%"
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSString *date1 = _inLabel1.text;
    NSString *date2 = _inLabel2.text;
    NSString *areaAddress; // = _inLabel3.text;
    NSString *classNumber;  //= _inLabel4.text;
    
    for (classesModel *smodel in _classArray) {
        if ([smodel.classesName isEqualToString:_inLabel4.text]) {
            classNumber = smodel.itemNo;
        }
    }
    
    for (FloorModel *smodel in _areaArray) {
        if ([smodel.FloorInfo isEqualToString:_inLabel3.text]) {
            areaAddress = smodel.itemNo;
        }
    }
    
    NSString *conditionStr = [NSString stringWithFormat:@"PI003$>=$%@$AND$PI003$<=$%@$AND$area$LIKE$%@$AND$PI004$LIKE$%@$AND$COMPANY$=$%@$AND$SHOPID$=$%@",date1,date2,areaAddress,classNumber,self.model.COMPANY,self.model.SHOPID];
    NSDictionary *dic = @{@"FromTableName":@"POSPI",@"SelectField":@"*",@"Condition":conditionStr,@"SelectOrderBy":@"PI003",@"Page":@"0",@"PageSize":@"10",@"CipherText":CIPHERTEXT};
        NSLog(@"－－－－－---%@",dic);
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo4" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [CloseReportModel getDataWithDic:dic1];
        [_closeReportTable reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initLabel
{
    _label1.layer.borderWidth = 1;
    _label1.layer.cornerRadius = 5;
    _label1.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // _inLabel1.text=[self getCurrentTime];
    
    _label2.layer.borderWidth = 1;
    _label2.layer.cornerRadius = 5;
    _label2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _inLabel2.text=[self getCurrentTime];

    _label3.layer.borderWidth = 1;
    _label3.layer.cornerRadius = 5;
    _label3.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _label4.layer.borderWidth = 1;
    _label4.layer.cornerRadius = 5;
    _label4.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)initItemView
{
    NSArray *title = @[@"班次",@"营业日期",@"交班机器",@"单据数量"];
    _ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 145, screen_width, 40)];
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

-(void)initCloseReportTable
{
    self.closeReportTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 185, screen_width, screen_height-185) style:UITableViewStyleGrouped];
    self.closeReportTable.delegate = self;
    self.closeReportTable.dataSource = self;
    
    [self.closeReportTable registerNib:[UINib nibWithNibName:@"reportFormsTableViewCell" bundle:nil] forCellReuseIdentifier:@"reportFormsTableViewCell"];
    [self.view addSubview:_closeReportTable];
}

-(IBAction)btn1Click:(id)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
        NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
        _inLabel1.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
         [self  getAllData];
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
        _inLabel1.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        [self  getAllData];
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
        _inLabel2.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
         [self  getAllData];
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
        _inLabel2.text = [NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        [self  getAllData];
    };
}

- (IBAction)btn5Click:(id)sender {
    if (_areaTable) {
        _areaTable.hidden = !_areaTable.hidden;
    }else
    {
        [self initAreaTable];
    }
}
- (IBAction)btn6Click:(id)sender {
    if (_classTable) {
        _classTable.hidden = !_classTable.hidden;
    }else
    {
        [self initClassTable];
    }
}

-(void)initClassTable
{
    _classTable = [[UITableView alloc] init];
    _classTable.delegate = self;
    _classTable.dataSource = self;
    [self.view addSubview:_classTable];
    [_classTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label4.mas_bottom);
        make.left.mas_equalTo(_label4.mas_left);
        make.right.mas_equalTo(_label4.mas_right);
        make.height.mas_equalTo(4*40);
    }];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _classTable.tableFooterView = v;
    _classTable.layer.borderWidth = 1;
    _classTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_classTable dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];
}

-(void)initAreaTable
{
    _areaTable = [[UITableView alloc] init];
    _areaTable.delegate = self;
    _areaTable.dataSource = self;
    [self.view addSubview:_areaTable];
    
    [_areaTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label3.mas_bottom);
        make.left.mas_equalTo(_label3.mas_left);
        make.right.mas_equalTo(_label3.mas_right);
        make.height.mas_equalTo(4*40);
    }];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _areaTable.tableFooterView = v;
    _areaTable.layer.borderWidth = 1;
    _areaTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_areaTable dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_classTable) {
        return _classArray.count;
    }else if(tableView == _areaTable)
    {
        return _areaArray.count;
    }else
    {
        return _dataArray.count;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _classTable) {
        classesModel *model = _classArray[indexPath.row];
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.contentLable.font = [UIFont systemFontOfSize:13];
        cell.contentLable.text= model.classesName;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _areaTable)
    {
        FloorModel *model = _areaArray[indexPath.row];
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.contentLable.font = [UIFont systemFontOfSize:13];
        cell.contentLable.text= model.FloorInfo;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
       CloseReportModel *model = _dataArray[indexPath.row];
        static NSString *cellid = @"reportFormsTableViewCell";
        reportFormsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"reportFormsTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell setDataWithModel:model];
        //cell.label1.text = model.classesTimes;
        for (classesModel *smodel in _classArray) {
            if ([smodel.itemNo isEqualToString:model.classesTimes]) {
                cell.label1.text = smodel.classesName;
            }
        }
        
        cell.label2.text = model.operateTime;
        cell.label3.text = model.operateMachine;
        cell.label4.text = model.FormsNumber;

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _classTable) {
       
        _classTable.hidden=YES;
        
        classesModel *model = _classArray[indexPath.row];
        
        _inLabel4.text = model.classesName;
        
        [self  getAllData];
    }
    if (tableView == _areaTable){
        
        _areaTable.hidden=YES;
        
        FloorModel *model = _areaArray[indexPath.row];
        
        _inLabel3.text = model.FloorInfo;
        
        [self  getAllData];
    }
    
    if (tableView == _closeReportTable) {
        CloseReportModel *model = _dataArray[indexPath.row];
        CloseReportDetailViewController *CRDVC = [[CloseReportDetailViewController alloc] init];
        CRDVC.title = @"交班报表明细";
        CRDVC.cModel = model;
        CRDVC.CArr = self.areaArray;
        [self.navigationController pushViewController:CRDVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
           return 40.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
