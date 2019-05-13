//
//  ZWHCardListViewController.m
//  GBYouJiFenManager
//
//  Created by Syrena on 2018/12/29.
//  Copyright © 2018年 张卫煌. All rights reserved.
//

#import "ZWHCardListViewController.h"
#import "CouponModel.h"
#import "ZWHCardModel.h"
#import "ZWHCardListTableViewCell.h"
#import "ZWHShareQRViewController.h"
#import "ClipDetailViewController.h"

@interface ZWHCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)UITableView *listTable;



@end

@implementation ZWHCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LINECOLOR;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCard) name:@"refreshCard" object:nil];
    _index = 1;
    [self setUI];
    [self setRefresh];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refreshCard{
    [self.listTable.mj_header beginRefreshing];
}

-(void)setRefresh{
    MJWeakSelf
    _listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [NSMutableArray array];
        weakSelf.index = 1;
        [weakSelf getDataSource];
    }];
    _listTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getDataSource];
    }];
    [_listTable.mj_header beginRefreshing];
}

-(void)getDataSource{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_mode forKey:@"mode"];
    [dict setValue:model.SHOPID forKey:@"shopid"];
    [dict setValue:@(_index) forKey:@"pageindex"];
    [dict setValue:@(10) forKey:@"pagesize"];
    [dict setValue:CIPHERTEXT forKey:@"CipherText"];
    MJWeakSelf;
    [[NetDataTool shareInstance] zwhgetNetData:ROOTPATH url:@"/PosService.asmx/ShopCouponList" With:dict and:^(id responseObject) {
        NSDictionary *resdict=[JsonTools getData:responseObject];
        NSLog(@"%@",resdict);
        if ([resdict[@"message"] isEqualToString:@"OK"]) {
            NSArray *ary = resdict[@"DataSet"][@"Table"];
            [ZWHCardModel mj_objectClassInArray];
            ZWHCardModel *model = [ZWHCardModel mj_objectWithKeyValues:ary[0]];
            NSLog(@"%@",model);
            
            if (model.couponlist.count < 10) {
                [weakSelf.listTable.mj_header endRefreshing];
                [weakSelf.listTable.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.listTable.mj_header endRefreshing];
                [weakSelf.listTable.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:model.couponlist];
            [weakSelf.listTable reloadData];
            
            if (weakSelf.dataArray.count==0) {
                weakSelf.listTable.mj_footer.hidden = YES;
                [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"nodata"] text:@"" detailText:@"" buttonTitle:@"" buttonAction:nil];
            }else{
                weakSelf.listTable.mj_footer.hidden = NO;
                [weakSelf hideEmptyView];
            }
        }else{
            [QMUITips showError:@"获取失败"];
        }
    } Faile:^(NSError *error) {
        
    }];
}

-(void)setUI{
    _dataArray = [NSMutableArray array];
    _index = 1;
    
    
    _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-(ZWHNavHeight)-100) style:UITableViewStylePlain];
    [self.view addSubview:_listTable];
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
        //make.top.equalTo(self.view).offset(ZWHNavHeight);
    }];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.separatorStyle = 0;
    _listTable.backgroundColor = LINECOLOR;
    _listTable.showsVerticalScrollIndicator = NO;
    [_listTable registerClass:[ZWHCardListTableViewCell class] forCellReuseIdentifier:@"ZWHCardListTableViewCell"];
    self.keyTableView = _listTable;
}

#pragma mark - uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHCardListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (_dataArray.count >0) {
        CouponModel *model = _dataArray[indexPath.row];
        cell.model = model;
        cell.share.tag = indexPath.row;
        [cell.share addTarget:self action:@selector(shareQRWith:) forControlEvents:UIControlEventTouchUpInside];
        if ([_mode isEqualToString:@"03"]) {
            CouponModel *model = _dataArray[indexPath.row];
            cell.img.image = [UIImage imageNamed:@"quang2"];
            if ([model.Quantity2 isEqualToString:model.Quantity1]) {
                cell.time.text = @"已结束";
            }else{
                cell.time.text = @"已过期";
            }
            
            cell.shareholder.hidden = YES;
            cell.share.hidden = YES;
        }
        DefineWeakSelf;
        cell.RefreshCallBack = ^{
            [weakSelf deletCompon:indexPath.row];
        };
    }
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_PRO(101);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponModel *model=_dataArray[indexPath.row];
    ClipDetailViewController*comm=[[ClipDetailViewController alloc]init];
    comm.title=@"卡券明细";
    comm.clipID=model.ID;
    comm.Amount1=model.Amount1;
    comm.Amount2=model.Amount2;
    comm.Quantity2=model.Quantity2;
    comm.Quantity3=model.Quantity3;
    comm.EndDate=model.EndDate;
    [self.navigationController pushViewController:comm animated:YES];
}


#pragma mark - 分享二维码
-(void)shareQRWith:(QMUIButton *)btn{
    ZWHShareQRViewController *vc = [[ZWHShareQRViewController alloc]init];
    vc.coumodel = _dataArray[btn.tag];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)deletCompon:(NSInteger)index{
    
    
//    NSLog(@"删除------");
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
     CouponModel *coupon = _dataArray[index];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Del",@"TableName":@"sales_coupon",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ID":coupon.ID}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            DefineWeakSelf;
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                [weakSelf.dataArray removeObjectAtIndex:index];
                [weakSelf.listTable reloadData];
                
            });
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:str];
            
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
  
}











@end
