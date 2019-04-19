//
//  ZWHMaintainViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/10/19.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHMaintainViewController.h"
#import "ZWHMaintainModel.h"
#import "ZWHMainDetailViewController.h"

@interface ZWHMaintainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)MemberModel *userModel;

@end

@implementation ZWHMaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价基础维护";
    _dataArray = [NSMutableArray array];
    self.userModel = [[FMDBMember shareInstance] getMemberData][0];
    [self setUI];
    [self netWork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWork) name:@"mainrefresh" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - net
-(void)netWork{
    _dataArray = [NSMutableArray array];
    [self showEmptyViewWithLoading];
    NSDictionary *dic=@{@"FromTableName":@"crm_evaluationinfo",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@",_userModel.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    MJWeakSelf
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        [weakSelf hideEmptyView];
        if ([dic1[@"message"] isEqualToString:@"OK"]) {
            NSArray *ary = dic1[@"DataSet"][@"Table"];
            if (ary.count == 0) {
                [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"placeHoderView"] text:@"" detailText:@"" buttonTitle:@"" buttonAction:nil];
            }else{
                weakSelf.dataArray = [ZWHMaintainModel mj_objectArrayWithKeyValuesArray:ary];
                [weakSelf.listTableview reloadData];
            }
        }else{
            [weakSelf showEmptyViewWithText:@"请求失败" detailText:@"请检查网络连接" buttonTitle:@"重试" buttonAction:@selector(netWork)];
        }
        
    } Faile:^(NSError *error) {
        [weakSelf hideEmptyView];
        [weakSelf showEmptyViewWithText:@"请求失败" detailText:@"请检查网络连接" buttonTitle:@"重试" buttonAction:@selector(netWork)];
    }];
    
}


#pragma mark - setui
-(void)setUI{
    _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _listTableview.delegate = self;
    _listTableview.dataSource = self;
    _listTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:_listTableview];
    [_listTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    [_listTableview registerClass:[QMUITableViewCell class] forCellReuseIdentifier:@"QMUITableViewCell"];
    UIView *footerView = [UIView new];
    _listTableview.tableFooterView = footerView;
    
    //添加
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(zwhAdd)];
}

#pragma mark - 添加
-(void)zwhAdd{
    ZWHMainDetailViewController *vc = [[ZWHMainDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMUITableViewCell" forIndexPath:indexPath];
    if (_dataArray.count>0) {
        ZWHMaintainModel *model = _dataArray[indexPath.row];
        cell.textLabel.text = model.info;
    }
    
    return cell;
}

//编辑
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHMainDetailViewController *vc = [[ZWHMainDetailViewController alloc]init];
    ZWHMaintainModel *model = _dataArray[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

//开启或关闭移动功能
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



//监听编辑按钮的事件回调方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据传入的编辑模式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZWHMaintainModel *model = _dataArray[indexPath.row];
        NSDictionary *jsonDic=@{@"Command":@"Del",@"TableName":@"crm_evaluationinfo",@"Data":@[@{@"shopid":_userModel.SHOPID,@"info":model.info,@"sysid":model.sysid}]};
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        MJWeakSelf;
        [self showEmptyViewWithLoading];
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            NSString *str=[JsonTools getNSString:responseObject];
            [weakSelf hideEmptyView];
            if ([str isEqualToString:@"OK"])
            {
                [QMUITips showSucceed:@"删除成功"];
                [_dataArray removeObjectAtIndex:indexPath.row];
                //制定刷新当前行
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }else{
                [QMUITips showError:@"删除失败"];
            }
        } Faile:^(NSError *error) {
        }];
    }
}





@end
