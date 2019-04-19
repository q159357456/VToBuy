//
//  ZWHOrderOnlineViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/14.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHOrderOnlineViewController.h"
#import "ZWHOrderOnlineTableViewCell.h"
#import "ZWHNorSearchViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "ZWHOrderOnlineModel.h"
#import "UUID.h"
#import <IQKeyboardManager.h>

@interface ZWHOrderOnlineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)ZWHOrderOnlineModel *onlneModel;

@end

@implementation ZWHOrderOnlineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线取单";
    _type = [[NSUserDefaults standardUserDefaults] objectForKey:@"POS_RunModel"];
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    [self setUI];
    [self setRefresh];
    
}

-(void)getDataSource{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@([_type integerValue]) forKey:@"posmode"];
    [dict setValue:_model.COMPANY forKey:@"company"];
    [dict setValue:_model.SHOPID forKey:@"shopid"];
    [dict setValue:@(_index) forKey:@"page"];
    [dict setValue:@(10) forKey:@"pagesize"];
    
    [dict setValue:_searchStr.length>0?_searchStr:@"" forKey:@"ft"];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/GetBillList" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"%@",resdict);
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            NSArray *ary = resdict[@"DataSet"][@"Table"];
            if (ary.count == 0) {
                [weakSelf.listTable.mj_header endRefreshing];
                weakSelf.listTable.mj_footer.hidden = YES;
            }else{
                [weakSelf.dataArray addObjectsFromArray:[ZWHOrderOnlineModel mj_objectArrayWithKeyValuesArray:ary]];
                [weakSelf.listTable.mj_header endRefreshing];
                [weakSelf.listTable.mj_footer endRefreshing];
                weakSelf.listTable.mj_footer.hidden = NO;
            }
            [weakSelf.listTable reloadData];
            if (weakSelf.dataArray.count==0) {
                [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"nodata"] text:@"" detailText:@"" buttonTitle:@"" buttonAction:nil];
            }else{
                [weakSelf hideEmptyView];
            }
        }else{
            [QMUITips showError:@"获取失败"];
        }
    } Faile:^(NSError *error) {
        
    }];
}

-(void)setRefresh{
    MJWeakSelf
    _listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [NSMutableArray array];
        weakSelf.index = 1;
        [weakSelf getDataSource];
    }];
    _listTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getDataSource];
    }];
    [_listTable.mj_header beginRefreshing];
}


-(void)setUI{
    _dataArray = [NSMutableArray array];
    _index = 1;
    
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-(ZWHNavHeight)-100) style:UITableViewStylePlain];
    [self.view addSubview:_listTable];
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.separatorStyle = 0;
    _listTable.backgroundColor = [UIColor whiteColor];
    [_listTable registerClass:[ZWHOrderOnlineTableViewCell class] forCellReuseIdentifier:@"ZWHOrderOnlineTableViewCell"];
    _listTable.showsVerticalScrollIndicator = NO;
    self.keyTableView = _listTable;
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(zwhsearch)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    if (_searchStr.length > 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark - 搜索
-(void)zwhsearch{
    ZWHNorSearchViewController *vc = [[ZWHNorSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}



#pragma mark - <uitabledelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_PRO(125);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHOrderOnlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHOrderOnlineTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.takeOrder.tag = indexPath.row;
    cell.cancelOrder.tag = indexPath.row;
    [cell.cancelOrder addTarget:self action:@selector(zwhCancelOrderWith:) forControlEvents:UIControlEventTouchUpInside];
    [cell.takeOrder addTarget:self action:@selector(zwhTakeOrderWith:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - 作废
-(void)zwhCancelOrderWith:(QMUIButton *)btn{
    ZWHOrderOnlineModel *cancelmodel = _dataArray[btn.tag];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:cancelmodel.SB002 forKey:@"billno"];
    [dict setValue:_model.COMPANY forKey:@"company"];
    [dict setValue:_model.SHOPID forKey:@"shopid"];
    [dict setValue:_model.Mobile forKey:@"loginuser"];
    
    [SVProgressHUD showWithStatus:@""];
    MJWeakSelf
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/InvalidBill" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"%@",resdict);
        [SVProgressHUD dismiss];
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            [QMUITips showError:@"作废成功"];
            [weakSelf.listTable.mj_header beginRefreshing];
        }else{
            [QMUITips showError:resdict[@"message"]];
        }
    } Faile:^(NSError *error) {
        [SVProgressHUD dismiss];
        [QMUITips showError:@"作废失败"];
    }];
}



#pragma mark - 取单
-(void)zwhTakeOrderWith:(QMUIButton *)btn{
    ZWHOrderOnlineModel *ordermodel = _dataArray[btn.tag];
    _onlneModel = ordermodel;
    if (ordermodel.SB005.length>0) {
        
        [self isRegistMac];
    }else{
        [QMUITips showInfo:@"该订单异常,无法取单"];
    }
}

-(void)isRegistMac
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *uuid=[UUID getUUID];
    
    NSString *tableName=@"POSDN";
    NSString *SelectField=@"DN001,DN002,DN006";
    
    NSString *Condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$DN004$=$%@",_model.COMPANY,_model.SHOPID,uuid];
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:dic and:^(id responseObject)
     {
         NSDictionary *dict=[JsonTools getData:responseObject];
         NSDictionary *secDic=dict[@"DataSet"];
         NSString *status=(NSString *)dict[@"status"];
         
         if ([status integerValue] ==1) {
             
             NSArray *array=secDic[@"Table"];
             for (NSDictionary *dictionary in array) {
                 
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN001"] forKey:@"DN001"];
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN002"] forKey:@"DN002"];
                 [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"DN006"] forKey:@"DN006"];
                 [[NSUserDefaults standardUserDefaults] synchronize ];
             }
             
             [self getRunModel];
             
         }else
         {
             //直接注册
             [self addItemWithStr:uuid];
         }
     } Faile:^(NSError *error) {
         
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"注册Mac地址出错"];
     }];
}

//注册设备代码
-(void)addItemWithStr:(NSString*)str
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDN",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"DN002":@"admin",@"DN006":@"0001",@"DN004":str}]};
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    //     NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            //注册成功后重新获取设备编码
            [self isRegistMac];
            
        }else
        {
            [SVProgressHUD dismiss];
            [QMUITips showInfo:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

-(void)getRunModel
{
    NSString *tableName=@"CMS_CommPara";
    NSString *SelectField=@"POS_RunModel";
    NSString *Condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",_model.COMPANY,_model.SHOPID];
    
    NSDictionary *dic=@{@"FromTableName":tableName,@"SelectField":SelectField,@"Condition":Condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetCommSelectDataInfo3 With:dic and:^(id responseObject)
     {
         NSDictionary *dict=[JsonTools getData:responseObject];
         NSDictionary *secDic=dict[@"DataSet"];
         NSArray *array=secDic[@"Table"];
         for (NSDictionary *dictionary in array) {
             
             [[NSUserDefaults standardUserDefaults]setValue:dictionary[@"POS_RunModel"] forKey:@"POS_RunModel"];
             NSLog(@"POS_RunModel:%@",dictionary[@"POS_RunModel"]);
             
             [[NSUserDefaults standardUserDefaults] synchronize ];
             
         }
         
         [self getGetBusinessDate];
         
     } Faile:^(NSError *error) {
         
     }];
    
}


-(void)getGetBusinessDate
{
    
    [SVProgressHUD showWithStatus:@""];
    NSDictionary *dictionary=@{@"company":_model.COMPANY,@"shopid":_model.SHOPID};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetBusinessDate With:dictionary and:^(id responseObject)
     {
         NSString *dateStr=[JsonTools getNSString:responseObject];
         
         //         NSLog(@"date---%@",dateStr);
         [[NSUserDefaults standardUserDefaults]setValue:dateStr forKey:@"BusinessDate"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         NSLog(@"BusinessDate:%@",dateStr);
         NSArray *array=[dateStr componentsSeparatedByString:@","];
         if ([array[2] intValue]==0)
         {
             [SVProgressHUD dismiss];
             //[self SetBusinessDate];
             [QMUITips showInfo:@"没有营业时期，请到POS机上操作"];
         }else
         {
             [self getClassInfo];
         }
     } Faile:^(NSError *error) {
         [SVProgressHUD dismiss];
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"获取BusinessDate出错"];
     }];
}

-(void)getClassInfo
{
    NSArray *dateArray= [[[NSUserDefaults standardUserDefaults]valueForKey:@"BusinessDate"] componentsSeparatedByString:@","];
    
    NSDictionary *dic=@{@"Company":_model.COMPANY,@"ShopID":_model.SHOPID,@"UserNo":_model.Mobile,@"ShopDay":dateArray[1],@"DeviceNo":[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"]};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:GetClassesInfo With:dic and:^(id responseObject)
     {
         NSString *ClassesInfo=[JsonTools getNSString:responseObject];
         
         //         NSLog(@"date---%@",ClassesInfo);
         [[NSUserDefaults standardUserDefaults]setValue:ClassesInfo forKey:@"ClassesInfo"];
         
         [[NSUserDefaults standardUserDefaults] synchronize];
         //         NSLog(@"ClassesInfo:%@",ClassesInfo);
         
         NSArray *array=[ClassesInfo componentsSeparatedByString:@","];
         
         if ([array[3] intValue]==0)
         {   [SVProgressHUD dismiss];
             [QMUITips showInfo:@"资料设置不正确请联系管理员"];
         }else
         {
             [self zwhfintakeOrderOnline];
         }
     } Faile:^(NSError *error) {
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showErrorWithStatus:@"获取GetClassesInfo出错"];
     }];
}

//取单
-(void)zwhfintakeOrderOnline{
    
    NSArray *dateArr= [[[NSUserDefaults standardUserDefaults]valueForKey:@"BusinessDate"] componentsSeparatedByString:@","];
    
    NSArray *classArr= [[[NSUserDefaults standardUserDefaults]valueForKey:@"ClassesInfo"] componentsSeparatedByString:@","];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_onlneModel.SB002 forKey:@"billno"];
    [dict setValue:@([_type integerValue]) forKey:@"posmode"];
    [dict setValue:_model.COMPANY forKey:@"company"];
    [dict setValue:_model.SHOPID forKey:@"shopid"];
    [dict setValue:dateArr[1] forKey:@"BusinessDate"];
    [dict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"DN006"] forKey:@"Area"];
    [dict setValue:classArr[0] forKey:@"ClassesNo"];
    [dict setValue:classArr[2] forKey:@"ClassesSqe"];
    [dict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"] forKey:@"DreviceNo"];
    [dict setValue:_model.Mobile forKey:@"LoginUserNo"];
    
    NSLog(@"%@",dict);
    MJWeakSelf
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"PosService.asmx/ConfirmBill" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"%@",resdict);
        [SVProgressHUD dismiss];
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            [QMUITips showSucceed:@"取单成功"];
            [weakSelf.listTable.mj_header beginRefreshing];
        }else{
            [QMUITips showError:resdict[@"message"]];
        }
    } Faile:^(NSError *error) {
        [SVProgressHUD dismiss];
        [QMUITips showError:@"取单失败"];
    }];
}



@end
