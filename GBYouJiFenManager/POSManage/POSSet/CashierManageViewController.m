//
//  CashierManageViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "CashierManageViewController.h"
#import "addCashierViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "cashierTableViewCell.h"
#import "addCashierViewController.h"
@interface CashierManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation CashierManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    self.dataArray = [NSMutableArray array];
    
    [self initTableView];
    [self getAllData];
    [self addRightButton];
}

-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"CMS_Accounts",@"SelectField":@"*",@"Condition":self.conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [cashierModel getDataWithDic:dic1];
        [_MemberTableView reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initTableView
{
    UISearchBar *search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(10, 6, screen_width-20, 50);
    
    self.MemberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64) style:UITableViewStylePlain];
    self.MemberTableView.delegate = self;
    self.MemberTableView.dataSource = self;
    
    self.MemberTableView.tableHeaderView = search;
    
    [self.view addSubview:self.MemberTableView];
    
    [self.MemberTableView registerNib:[UINib nibWithNibName:@"cashierTableViewCell" bundle:nil] forCellReuseIdentifier:@"cashierTableViewCell"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _MemberTableView.tableFooterView = v;
    
}
-(void)addRightButton
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClick)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)addButtonClick
{
   
    addCashierViewController *add = [[addCashierViewController alloc] init];
    add.title = @"添加收银员";
    add.backBlock = ^{
        [self getAllData];
    };
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cashierModel *cModel = self.dataArray[indexPath.row];
    cashierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashierTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"cashierTableViewCell" owner:nil options:nil][0];
    }
    cell.nameLabel.text = cModel.name;
    cell.phonrNumberLabel.text = cModel.phoneNumber;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cashierModel *CModel = _dataArray[indexPath.row];
    if (_chooseType)
    {
        self.backBlock(CModel);
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        addCashierViewController *comm=[[addCashierViewController alloc]init];
        comm.title=@"收银员详情";
        comm.backBlock = ^{
            [self getAllData];
        };
        comm.typeString = @"detail";
        comm.cashModel = CModel;
        [self.navigationController pushViewController:comm animated:YES];
    }
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
