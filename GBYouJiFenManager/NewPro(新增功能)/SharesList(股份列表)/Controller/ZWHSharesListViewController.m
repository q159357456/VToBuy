//
//  ZWHSharesListViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/9/3.
//  Copyright © 2018年 秦根. All rights reserved.
//

#import "ZWHSharesListViewController.h"
#import "ZWHSharesListTableViewCell.h"
#import "ZWHAddSharesViewController.h"
#import "ZWHSharesModel.h"

#define OCOLOR [UIColor qmui_colorWithHexString:@"5DC5FD"]
#define TCOLOR [UIColor qmui_colorWithHexString:@"8BC34A"]

@interface ZWHSharesListViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;


@end

@implementation ZWHSharesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"股份列表";
    [self setUI];
    [self getDataSource];
}

-(void)setUI{
    _dataArray = [NSMutableArray array];
    _index = 1;
    
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-ZWHNavHeight-100) style:UITableViewStyleGrouped];
    [self.view addSubview:_listTable];
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.separatorStyle = 0;
    _listTable.backgroundColor = LINECOLOR;
    [_listTable registerClass:[ZWHSharesListTableViewCell class] forCellReuseIdentifier:@"ZWHSharesListTableViewCell"];
    _listTable.showsVerticalScrollIndicator = NO;
    self.keyTableView = _listTable;
    
    NOTIFY_ADD(reloadDataSource, NOTIFY_SHARES);
}

-(void)reloadDataSource{
    [self getDataSource];
}

-(void)dealloc{
    NOTIFY_REMOVEALL;
}

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
            for (NSInteger i=0; i<weakSelf.dataArray.count; i++) {
                ZWHSharesModel *model = weakSelf.dataArray[i];
                model.row = i;
            }
            [weakSelf.listTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"placeHoderView"] text:@"" detailText:@"" buttonTitle:@"" buttonAction:nil];
        }
        QMUIButton *btn = [[QMUIButton alloc]init];
        [btn setTitle:@"添加" forState:0];
        btn.tintColorAdjustsTitleAndImage = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [btn addTarget:self action:@selector(addShares) forControlEvents:UIControlEventTouchUpInside];
    } Faile:^(NSError *error) {
        [self hideEmptyView];
        NSLog(@"失败%@",error);
    }];
}

#pragma mark - 删除股份
-(void)deleteSharesWith:(QMUIButton *)btn{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    MJWeakSelf;
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        ZWHSharesModel *usermodel = _dataArray[btn.tag];
        NSDictionary *dict = @{@"date":[[NSDate date] stringWithFormat:@"yyyy-MM-dd"],@"shopid":usermodel.ShopID,@"memberid":usermodel.MemberID,@"CipherText":CIPHERTEXT};
        [self showEmptyViewWithLoading];
        NSLog(@"%@",dict);
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/posservice.asmx/PartnerInvalid" With:dict and:^(id responseObject) {
            NSString *str = [JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"succeed"]) {
                [weakSelf getDataSource];
            }else{
                [QMUITips showInfo:@"删除失败"];
            }
        } Faile:^(NSError *error) {
            [self hideEmptyView];
            NSLog(@"失败%@",error);
        }];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除？" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
    
    
    
}

#pragma mark - 添加股份
-(void)addShares{
    float maxShares=99;
    if (_dataArray.count>0) {
        for (ZWHSharesModel *model in _dataArray) {
            maxShares = maxShares-[model.Ratio floatValue];
        }
    }
    
    ZWHAddSharesViewController *vc = [[ZWHAddSharesViewController alloc]init];
    vc.state = @"0";
    vc.maxShares = maxShares;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma marl - 修改股份
-(void)editSharesWith:(QMUIButton *)btn{
    ZWHSharesModel *usermodel = _dataArray[btn.tag];
    float maxShares=99;
    if (_dataArray.count>0) {
        for (ZWHSharesModel *model in _dataArray) {
            if ([usermodel.MemberID isEqualToString:model.MemberID]&&[usermodel.ShopID isEqualToString:model.ShopID]) {
                
            }else{
                maxShares = maxShares-[model.Ratio floatValue];
            }
            
        }
    }
    ZWHAddSharesViewController *vc = [[ZWHAddSharesViewController alloc]init];
    vc.state = @"1";
    vc.maxShares = maxShares;
    vc.mymodel = usermodel;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_PRO(10);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_PRO(100);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHSharesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHSharesListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.model = _dataArray[indexPath.row];
    cell.edit.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    [cell.edit addTarget:self action:@selector(editSharesWith:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteSharesWith:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}







@end
