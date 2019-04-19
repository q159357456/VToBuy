//
//  ZWHGrantViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/11/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHGrantViewController.h"
#import "KJChangeUserInfoTableViewCell.h"
#import "ZWHPaiFaTableViewCell.h"
#import "ZWHFourLabTableViewCell.h"
#import "ZWHPieModel.h"
#import "ZWHPieListModel.h"

@interface ZWHGrantViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableView;

@property(nonatomic,strong)NSString *baseStr;
@property(nonatomic,strong)NSString *payStr;
@property(nonatomic,strong)NSString *proStr;
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,strong)NSString *sumStr;
@property(nonatomic,strong)NSString *canyuStr;

@property(nonatomic,strong)ZWHPieModel *mymodel;

@end

@implementation ZWHGrantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"派派金设置";
    _timeStr = [[NSDate dateYesterday] stringWithFormat:@"yyyy/MM/dd"];
    self.baseStr = @"";
    self.payStr = @"";
    self.proStr = @"";
    self.sumStr = @"";
    self.canyuStr = @"";
    [self creatUI];
    [self getData];
}

-(void)creatUI{
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _listTableView.separatorStyle = 0;
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:@"KJChangeUserInfoTableViewCell"];
    [_listTableView registerClass:[ZWHPaiFaTableViewCell class] forCellReuseIdentifier:@"ZWHPaiFaTableViewCell"];
    [_listTableView registerClass:[ZWHFourLabTableViewCell class] forCellReuseIdentifier:@"ZWHFourLabTableViewCell"];
    
    [self.view addSubview:_listTableView];
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
        //make.width.mas_equalTo(WIDTH_PRO(800));
        //make.bottom.equalTo(self.view).offset(-HEIGHT_PRO(50));
    }];

}

//获得预览数据
-(void)getData{
    [self.view endEditing:YES];
    _mymodel = nil;
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dict = @{@"mode":@"Read",@"shopid":model.SHOPID,@"piedate":_timeStr,@"CipherText":CIPHERTEXT};
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/PieData" With:dict and:^(id responseObject) {
        //NSString *str = [JsonTools getNSString:responseObject];
        NSDictionary *dict = [JsonTools getData:responseObject];
        NSLog(@"%@",dict);
        [weakSelf hideEmptyView];
        
        if ([dict[@"message"] isEqualToString:@"OK"]) {
            [ZWHPieModel mj_objectClassInArray];
            weakSelf.mymodel = [ZWHPieModel mj_objectWithKeyValues:dict[@"DataSet"][@"Table"][0]];
            if ([weakSelf.mymodel.totalamount floatValue]==0) {
                [QMUITips showInfo:@"当天没有营业数据"];
                weakSelf.mymodel = nil;
            }else{
                weakSelf.baseStr = weakSelf.mymodel.basequantity;
                weakSelf.payStr = weakSelf.mymodel.permoney;
                weakSelf.proStr = weakSelf.mymodel.rate;
                weakSelf.sumStr = weakSelf.mymodel.totalamount;
                weakSelf.canyuStr = weakSelf.mymodel.joinquantity;
            }
        }else{
            [QMUITips showError:dict[@"message"]];
        }
        [weakSelf.listTableView reloadData];
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}


#pragma mark - uitbaleviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_PRO(50);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_PRO(40);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_mymodel) {
        return section==0?6:_mymodel.partnerlist.count+1;
    }
    return section==0?6:1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(50))];
    view.backgroundColor = [UIColor whiteColor];
    QMUILabel *lab = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(14) textColor:[UIColor blackColor]];
    lab.text = section==0?@"参数设置":@"股东列表";
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(WIDTH_PRO(8));
        make.width.mas_equalTo(WIDTH_PRO(90));
        make.height.mas_equalTo(HEIGHT_PRO(30));
        make.centerY.equalTo(view).offset(HEIGHT_PRO(10)/2);
    }];
    
    UIView *butomLineZWH = [[UIView alloc]init];\
    butomLineZWH.backgroundColor = LINECOLOR; \
    [view addSubview:butomLineZWH]; \
    [butomLineZWH mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.left.right.bottom.equalTo(view); \
        make.height.mas_equalTo(1);\
    }];\
    
    UIView *topLineZWH = [[UIView alloc]init];\
    topLineZWH.backgroundColor = LINECOLOR; \
    [view addSubview:topLineZWH]; \
    [topLineZWH mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.top.right.left.equalTo(view); \
        make.height.mas_equalTo(HEIGHT_PRO(10));\
    }];\
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row!=3) {
            KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KJChangeUserInfoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.contentTex.textAlignment = NSTextAlignmentLeft;
            cell.isWidTitle = YES;
            MJWeakSelf
            switch (indexPath.row) {
                case 0:
                {
                    cell.leftTitleStr = @"股东基数";
                    cell.rightTitleStr = @"份";
                    cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
                    cell.contentTex.placeholder = @"请输入派派金份数";
                    cell.contentTex.text = self.baseStr;
                    cell.contentTex.enabled = NO;
                }
                    break;
                case 1:
                {
                    cell.leftTitleStr = @"单价";
                    cell.rightTitleStr = @"元";
                    cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
                    cell.contentTex.placeholder = @"请输入每份派派金金额";
                    cell.contentTex.text = self.payStr;
                    [cell didEndInput:^(NSString *input) {
                        weakSelf.payStr = input;
                    }];
                }
                    break;
                case 2:
                {
                    cell.leftTitleStr = @"运算比例";
                    //cell.rightTitleStr = @"份";
                    cell.contentTex.keyboardType = UIKeyboardTypeDecimalPad;
                    cell.contentTex.placeholder = @"派派金抽出多少比例参与运算";
                    cell.contentTex.text = self.proStr;
                    [cell didEndInput:^(NSString *input) {
                        weakSelf.proStr = input;
                    }];
                }
                    break;
                case 4:
                {
                    cell.leftTitleStr = @"当天营业金额";
                    //cell.rightTitleStr = @"份";
                    cell.contentTex.text = [NSString stringWithFormat:@"¥ %@",self.sumStr];
                    cell.contentTex.textColor = [UIColor orangeColor];
                    cell.contentTex.enabled = NO;
                }
                    break;
                case 5:
                {
                    cell.leftTitleStr = @"消费者基数";
                    cell.rightTitleStr = @"份";
                    cell.contentTex.text = self.canyuStr;
                    cell.contentTex.enabled = NO;
                }
                    break;
                default:
                    break;
            }
            return cell;
        }else{
            ZWHPaiFaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHPaiFaTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = 0;
            [cell.time addTarget:self action:@selector(choosetime) forControlEvents:UIControlEventTouchUpInside];
            [cell.paisong addTarget:self action:@selector(zwhpieSong) forControlEvents:UIControlEventTouchUpInside];
            [cell.reset addTarget:self action:@selector(zwhreSet) forControlEvents:UIControlEventTouchUpInside];
            cell.reset.hidden = NO;
            cell.paisong.backgroundColor = navigationBarColor;
            [cell.paisong setTitle:@"派送" forState:0];
            if (_mymodel) {
                if ([_mymodel.status isEqualToString:@"Y"]) {
                    cell.reset.hidden = YES;
                    cell.paisong.backgroundColor = [UIColor grayColor];
                    [cell.paisong setTitle:@"已派送" forState:0];
                }else{
                    cell.reset.hidden = NO;
                    cell.paisong.backgroundColor = navigationBarColor;
                    [cell.paisong setTitle:@"派送" forState:0];
                }
            }
            [cell.time setTitle:_timeStr forState:0];
            return cell;
        }

    }else{
        ZWHFourLabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHFourLabTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        if (_mymodel.partnerlist.count >0 && indexPath.row>0) {
            cell.model = _mymodel.partnerlist[indexPath.row-1];
        }
        return cell;
    }
}


#pragma mark - 派送 重算
-(void)zwhpieSong{
    if (!_mymodel) {
        [QMUITips showError:@"当天没有营业数据"];
        return;
    }
    [self.view endEditing:YES];
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dict = @{@"mode":@"Write",@"shopid":model.SHOPID,@"piedate":_timeStr,@"CipherText":CIPHERTEXT};
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/PieData" With:dict and:^(id responseObject) {
        NSDictionary *dict = [JsonTools getData:responseObject];
        [weakSelf hideEmptyView];
        if ([dict[@"message"] isEqualToString:@"OK"]) {
            [QMUITips showSucceed:@"派送成功"];
            [weakSelf getData];
        }else{
            [QMUITips showError:dict[@"message"]];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}


-(void)zwhreSet{
    if (!_mymodel) {
        [QMUITips showError:@"当天没有营业数据"];
        return;
    }
    [self.view endEditing:YES];
    MemberModel *model = [[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *dict = @{@"shopid":model.SHOPID,@"piedate":_timeStr,@"basequantity":_baseStr,@"permoney":_payStr,@"rate":_proStr,@"CipherText":CIPHERTEXT};
    [self showEmptyViewWithLoading];
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/PieData_Recalu" With:dict and:^(id responseObject) {
        [weakSelf hideEmptyView];
        NSDictionary *dict = [JsonTools getData:responseObject];
        NSLog(@"%@",dict);
        if ([dict[@"message"] isEqualToString:@"OK"]) {
            [QMUITips showSucceed:@"重算成功"];
            [weakSelf getData];
        }else{
            [QMUITips showError:dict[@"message"]];
        }
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}



#pragma mark - 选择日期
-(void)choosetime{
    [self.view endEditing:YES];
    MJWeakSelf
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:zwhDateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        weakSelf.timeStr = [selectDate stringWithFormat:@"yyyy/MM/dd"];
        [weakSelf getData];
    }];
    datepicker.dateLabelColor = [UIColor clearColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = MAINCOLOR;//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    //datepicker.minLimitDate = [NSDate dateYesterday];
    datepicker.maxLimitDate = [NSDate dateYesterday];
    [datepicker show];
}





@end
