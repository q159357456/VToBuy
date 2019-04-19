//
//  ZWHAddCardViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/8.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHAddCardViewController.h"
#import "ZWHCardManTableViewCell.h"
#import "ZWHSharesModel.h"
#import "NSDate+Extension.h"

@interface ZWHAddCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableView;

@property(nonatomic,strong)QMUITextField *maxF;
@property(nonatomic,strong)QMUITextField *minF;
@property(nonatomic,strong)QMUITextField *numF;

@property(nonatomic,strong)QMUIButton *startTime;
@property(nonatomic,strong)QMUIButton *endTime;

@property(nonatomic,assign)BOOL isChooseStart;
@property(nonatomic,assign)BOOL isChooseEnd;


@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *chooseArray;

@end

@implementation ZWHAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加股东券";
    _dataArray = [NSMutableArray array];
    _chooseArray = [NSMutableArray array];
    _isChooseStart = NO;
    _isChooseEnd = NO;
    [self creatUI];
    [self getDataSource];
}

#pragma mark - 添加股东券
-(void)addCard{
    NSLog(@"%@",_chooseArray);
    [self.view endEditing:YES];
    if (_chooseArray.count==0) {
        [QMUITips showInfo:@"请选择股东"];
        return;
    }
    if (_maxF.text.length==0 || _minF.text.length==0) {
        [QMUITips showInfo:@"请输入卡券面额"];
        return;
    }
    
    if (_numF.text.length==0) {
        [QMUITips showInfo:@"请输入卡券数量"];
        return;
    }
    if (_isChooseStart == NO || _isChooseEnd == NO) {
        [QMUITips showInfo:@"请选择开始(结束)时间"];
        return;
    }
    NSString *manlist = @"";
    for (NSString *index in _chooseArray) {
        ZWHSharesModel *model = _dataArray[[index integerValue]];
        manlist = [NSString stringWithFormat:@"%@%@;",manlist,model.MemberID];
    }
    manlist = [manlist substringWithRange:NSMakeRange(0, [manlist length] - 1)];
    
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dict = @{@"SHOPID":model.SHOPID,@"COMPANY":model.COMPANY,@"StartDate":_startTime.titleLabel.text,@"EndDate":_endTime.titleLabel.text,@"Amount1":_maxF.text,@"Amount2":_minF.text,@"Quantity1":_numF.text,@"Remark":manlist};
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[dict] options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *findict = @{@"json":jsonString,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",findict);
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/CreatePartnerCoupon" With:findict and:^(id responseObject) {
        NSString *str = [JsonTools getNSString:responseObject];
        [self hideEmptyView];
        if ([str isEqualToString:@"OK"]) {
            [QMUITips showSucceed:@"添加成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCard" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [QMUITips showError:str];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}



#pragma mark - 获得股东列表
-(void)getDataSource{
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    _dataArray = [NSMutableArray array];
    NSDictionary *dict = @{@"shopid":model.SHOPID,@"CipherText":CIPHERTEXT,@"memberid":@""};
    NSLog(@"%@",dict);
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/PartnerList" With:dict and:^(id responseObject) {
        [self hideEmptyView];
        NSArray *arr=[JsonTools getArrayWithData:responseObject];
        [weakSelf.dataArray addObjectsFromArray:[ZWHSharesModel mj_objectArrayWithKeyValuesArray:arr]];
        if (weakSelf.dataArray.count>0) {
            [weakSelf.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}


-(void)creatUI{
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.separatorStyle = 0;
    [_listTableView registerClass:[ZWHCardManTableViewCell class] forCellReuseIdentifier:@"ZWHCardManTableViewCell"];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
        make.bottom.equalTo(self.view).offset(-HEIGHT_PRO(50));
    }];
    
    QMUIButton *btn = [[QMUIButton alloc]qmui_initWithImage:nil title:@"添加股东券"];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.backgroundColor = [UIColor colorWithRed:255/255.f green:115/255.f blue:15/255.f alpha:1];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_PRO(50));
    }];
    [btn addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
    
    [self setHeader];
}


-(void)setHeader{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(250))];
    
    UILabel *basicL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    basicL.text = @"基本信息";
    [header addSubview:basicL];
    [basicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(WIDTH_PRO(15));
        make.centerY.equalTo(header.mas_top).offset(HEIGHT_PRO(25));
    }];
    UIView *friLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PRO(50), SCREEN_WIDTH, 1)];
    friLine.backgroundColor = LINECOLOR;
    [header addSubview:friLine];
    
    UILabel *limitL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    limitL.text = @"卡券面额";
    [header addSubview:limitL];
    [limitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(WIDTH_PRO(15));
        make.centerY.equalTo(header.mas_top).offset(HEIGHT_PRO(75));
    }];
    
    UILabel *manL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    manL.text = @"满";
    [header addSubview:manL];
    [manL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limitL.mas_right).offset(WIDTH_PRO(15));
        make.centerY.equalTo(limitL);
    }];
    
    _maxF = [[QMUITextField alloc]init];
    _maxF.keyboardType = UIKeyboardTypeNumberPad;
    _maxF.placeholder = @"请输入金额";
    _maxF.maximumTextLength = 5;
    _maxF.font = ZWHFont(14);
    [header addSubview:_maxF];
    [_maxF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manL.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(limitL);
        make.width.mas_equalTo(WIDTH_PRO(90));
    }];
    
    UILabel *manyuanL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    manyuanL.text = @"元";
    [header addSubview:manyuanL];
    [manyuanL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_maxF.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(limitL);
    }];
    
    UILabel *jianL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    jianL.text = @"减";
    [header addSubview:jianL];
    [jianL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(manyuanL.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(limitL);
    }];
    
    _minF = [[QMUITextField alloc]init];
    _minF.keyboardType = UIKeyboardTypeNumberPad;
    _minF.placeholder = @"请输入金额";
    _minF.maximumTextLength = 5;
    _minF.font = ZWHFont(14);
    [header addSubview:_minF];
    [_minF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jianL.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(limitL);
        make.width.mas_equalTo(WIDTH_PRO(90));
    }];
    
    UILabel *jianyuanL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    jianyuanL.text = @"元";
    [header addSubview:jianyuanL];
    [jianyuanL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minF.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(limitL);
    }];
    UIView *limitLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PRO(100), SCREEN_WIDTH, 1)];
    limitLine.backgroundColor = LINECOLOR;
    [header addSubview:limitLine];
    
    UILabel *numL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    numL.text = @"卡券数量";
    [header addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(WIDTH_PRO(15));
        make.centerY.equalTo(header.mas_top).offset(HEIGHT_PRO(125));
    }];
    
    _numF = [[QMUITextField alloc]init];
    _numF.keyboardType = UIKeyboardTypeNumberPad;
    _numF.placeholder = @"请输入卡券数量";
    _numF.maximumTextLength = 5;
    _numF.font = ZWHFont(14);
    [header addSubview:_numF];
    [_numF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numL.mas_right).offset(WIDTH_PRO(15));
        make.centerY.equalTo(numL);
        make.width.mas_equalTo(WIDTH_PRO(200));
    }];
    UILabel *zhangL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor grayColor]];
    zhangL.text = @"张";
    [header addSubview:zhangL];
    [zhangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jianyuanL);
        make.centerY.equalTo(_numF);
    }];
    UIView *numLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PRO(150), SCREEN_WIDTH, 1)];
    numLine.backgroundColor = LINECOLOR;
    [header addSubview:numLine];
    
    
    UILabel *timeL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    timeL.text = @"卡券时长";
    [header addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(WIDTH_PRO(15));
        make.centerY.equalTo(header.mas_top).offset(HEIGHT_PRO(175));
    }];
    
    _startTime = [[QMUIButton alloc]qmui_initWithImage:nil title:@"开始时间"];
    [_startTime setTitleColor:[UIColor grayColor] forState:0];
    _startTime.titleLabel.font = ZWHFont(14);
    _startTime.tag = 100;
    [header addSubview:_startTime];
    [_startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(timeL.mas_right).offset(WIDTH_PRO(15));
        make.width.mas_equalTo(WIDTH_PRO(100));
        make.centerX.equalTo(_maxF);
        make.centerY.equalTo(timeL);
    }];
    
    UILabel *daoL = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    daoL.text = @"到";
    [header addSubview:daoL];
    [daoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_startTime.mas_right).offset(WIDTH_PRO(8));
        make.centerY.equalTo(_startTime);
    }];
    
    _endTime = [[QMUIButton alloc]qmui_initWithImage:nil title:@"结束时间"];
    [_endTime setTitleColor:[UIColor grayColor] forState:0];
    _endTime.titleLabel.font = ZWHFont(14);
    _endTime.tag = 101;
    [header addSubview:_endTime];
    [_endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(timeL.mas_right).offset(WIDTH_PRO(15));
        make.width.mas_equalTo(WIDTH_PRO(100));
        make.centerX.equalTo(_minF);
        make.centerY.equalTo(timeL);
    }];
    
    [_startTime addTarget:self action:@selector(chooseTimeWith:) forControlEvents:UIControlEventTouchUpInside];
    [_endTime addTarget:self action:@selector(chooseTimeWith:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *timeLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PRO(200), SCREEN_WIDTH, HEIGHT_PRO(10))];
    timeLine.backgroundColor = LINECOLOR;
    [header addSubview:timeLine];
    
    
    UILabel *gudong = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    gudong.text = @"选择股东";
    [header addSubview:gudong];
    [gudong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(WIDTH_PRO(15));
        make.top.equalTo(timeLine.mas_bottom).offset(HEIGHT_PRO(10));
    }];
    
    UIView *botLine = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PRO(249), SCREEN_WIDTH, 1)];
    botLine.backgroundColor = LINECOLOR;
    [header addSubview:botLine];
    
    _listTableView.tableHeaderView = header;
}

#pragma mark - tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHCardManTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHCardManTableViewCell" forIndexPath:indexPath];
    if (_dataArray.count>0) {
        ZWHSharesModel *model = _dataArray[indexPath.row];
        cell.name.text = model.MemberName;
        cell.isSelect = NO;
        if (_chooseArray.count>0) {
            for (NSString *index in _chooseArray) {
                if ([index integerValue] == indexPath.row) {
                    cell.isSelect = YES;
                }
            }
        }
    }
    cell.selectionStyle = 0;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_chooseArray.count>0) {
        for (NSString *index in _chooseArray) {
            if ([index integerValue] == indexPath.row) {
                [_chooseArray removeObject:index];
                [self.listTableView reloadData];
                return;
            }
        }
        [_chooseArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }else{
        [_chooseArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }
    [self.listTableView reloadData];
}



#pragma mark - 选择时间
-(void)chooseTimeWith:(QMUIButton *)btn{
    [self.view endEditing:YES];
    MJWeakSelf
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:zwhDateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        if(btn.tag==100){
            weakSelf.isChooseStart = YES;
            [btn setTitle:[selectDate stringWithFormat:@"yyyy/MM/dd"] forState:0];
        }else{
            weakSelf.isChooseEnd = YES;
            [btn setTitle:[selectDate stringWithFormat:@"yyyy/MM/dd"] forState:0];
        }
    }];
    datepicker.dateLabelColor = [UIColor clearColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = MAINCOLOR;//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    [datepicker show];
}




@end
