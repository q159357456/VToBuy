//
//  CrashDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "CrashDetailViewController.h"
#import "ProuctTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "PayRecordModel.h"
#import "BuyDetailViewController.h"
@interface CrashDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView *btnKind;
@property(nonatomic,strong) UILabel *btnLable;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *leftArray;
@property(nonatomic,assign)NSInteger index;
@end

@implementation CrashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self getButtView];
    [self createUI];
    //[self getAllData];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self setRefresh];
}
-(void)getButtView
{
    self.btnKind=[[UIView alloc]init];
    _btnLable=[[UILabel alloc]init];
    [self.btnKind addSubview:_btnLable];
    UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sj"]];
    [self.btnKind addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_btnKind.mas_right);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(_btnKind.mas_centerY);
    }];
    [_btnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageview.mas_left);
        make.left.mas_equalTo(_btnKind.mas_left);
        make.centerY.mas_equalTo(_btnKind.mas_centerY);
        make.height.mas_equalTo(_btnKind.mas_height);
        
    }];
}


#pragma mark - 网络请求 刷新
-(void)setRefresh{
    MJWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.index = 1;
        weakSelf.dataArray = [NSMutableArray array];
        [weakSelf getAllData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.mj_header = header;
    
    self.tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        weakSelf.index+=1;
        [weakSelf getAllData];
    }];
    [self.tableview.mj_header beginRefreshing];
}


-(void)createUI
{
   
    //创建全部的种类条目
    UIView *kindView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screen_width, 50)];
    kindView.backgroundColor =[ColorTool colorWithHexString:@"#ff9ebb"];
    kindView.backgroundColor = navigationBarColor;
    
    //全部 的标题栏
    _btnKind.frame=CGRectMake(15, 0, 100, 50);
    _btnLable.text=@"收款类型";
    _btnLable.textAlignment=NSTextAlignmentCenter;
    _btnLable.textColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnKindClick)];
    [_btnKind addGestureRecognizer:tap];
    
    
    //名称  的标题栏
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-80)/2, 0, 80, 50)];
    nameLabel.text = @"变动金额";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //普通价  的标题栏
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-110, 0, 80, 50)];
    priceLabel.text = @"余额";
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [kindView addSubview:_btnKind];
    [kindView addSubview:nameLabel];
    [kindView addSubview:priceLabel];
    
    
    [self.view addSubview:kindView];
    

    
}
-(void)btnKindClick
{
    
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
  
    NSDictionary *dic=@{@"company":model.COMPANY,@"shopid":model.SHOPID,@"pageindex":[NSString stringWithFormat:@"%ld",self.index],@"pagesize":@"20"};
    NSLog(@"%@",dic);
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopOrderInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"-----%@",dic1);
        NSArray *ary = [PayRecordModel getDataWithDic:dic1];
        
        
        if (ary.count==0) {
            weakSelf.tableview.mj_footer.hidden = YES;
        }else{
            [weakSelf.dataArray addObjectsFromArray:ary];
        }
        [weakSelf getLeftArrayWithArray:weakSelf.dataArray];
        //self.dataArray=[PayRecordModel getDataWithDic:dic1];
        
        [weakSelf.tableview reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
-(void)getLeftArrayWithArray:(NSMutableArray*)array
{
    self.leftArray = [NSMutableArray array];
    for (NSInteger i=0; i<array.count; i++)
    {
        if (i==0)
        {
            [self.leftArray addObject:[NSString stringWithFormat:@"%.2f",[self.leftCrash stringByReplacingOccurrencesOfString:@"," withString:@""].floatValue]];
            
        }else
        {
            PayRecordModel *model=array[i-1];
            NSString *next = self.leftArray[i-1];
            float l=next.floatValue-model.ShopAmount.floatValue;
            //self.leftCrash=[NSString stringWithFormat:@"%.2f",l];
            [self.leftArray addObject:[NSString stringWithFormat:@"%.2f",l]];
            
        }
        
    }
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)leftArray
{
    if (!_leftArray) {
        _leftArray=[NSMutableArray array];
        
    }
    return _leftArray;
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
  
   
    static NSString *cellid=@"ProuctTableViewCell";
    PayRecordModel *mode=_dataArray[indexPath.row];
    ProuctTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"ProuctTableViewCell" owner:nil options:nil][0];
        
    }
    cell.choseView.hidden=YES;
    cell.classiFy.text=mode.Payment1;
    cell.productName.text=mode.ShopAmount;
//    NSLog(@"%d",[self.leftArray[indexPath.row] intValue]);
    if ([mode.ShopAmount intValue]<0) {
        cell.productName.textColor=[UIColor redColor];
    }else
    {
       cell.productName.textColor=[UIColor darkGrayColor];
    }
    cell.price.text=self.leftArray[indexPath.row];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayRecordModel *mode=_dataArray[indexPath.row];
    if ([mode.ShopAmount intValue]<0)
    {
        return;
    }else
    {
        PayRecordModel *model=_dataArray[indexPath.row];
        BuyDetailViewController *buy=[[BuyDetailViewController alloc]init];
        buy.title=@"买单详情";
        buy.pmodel=model;
        [self.navigationController pushViewController:buy animated:YES];
    }
   

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
    
}


-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
