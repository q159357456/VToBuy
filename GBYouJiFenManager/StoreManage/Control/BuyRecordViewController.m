//
//  BuyRecordViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BuyRecordViewController.h"
#import "StoreTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MSModel.h"
#import "PayRecordModel.h"
#import "ChooseTableViewCell.h"
#import "BuyDetailViewController.h"
#import "CoverView.h"
#import "PayTypeModel.h"
@interface BuyRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *itemButton;
}
@property(nonatomic,strong)MemberModel *model;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UITableView *tableView2;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSArray *payTypeArray;
@property(nonatomic,strong)NSArray *payTypeNo;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)PlaceholderView *placeView;
@property(nonatomic,strong)MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong)MJRefreshGifHeader *header;
@property(nonatomic,assign)NSInteger index;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@end

@implementation BuyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!self.startData.length)
    {
        [self loadBaseUI];
    }else
    {
        self.tableTop.constant=0;
        [self GetShopOrderInfoWithStr:self.billType];
    }
    [self fresh];
 //微信收款  支付宝收款 银联卡刷卡收款 现金收款
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--mjFresh
-(void)addHeaderRefresh
{
    _header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //1.重置页数
        self.index=1;
        //2.清空页数
        [self.dataArray removeAllObjects];
        //3.重新发生网络请求
        [self GetShopOrderInfoWithStr:self.billType];
        
    }];
    //        NSArray *imageArr=@[[UIImage imageNamed:@"loadAni_1"],[UIImage imageNamed:@"loadAni_2"],[UIImage imageNamed:@"loadAni_3"],[UIImage imageNamed:@"loadAni_4"],[UIImage imageNamed:@"loadAni_5"]];
    //正在刷新中的状态
    //        [_header setImages:@[[UIImage imageNamed:@"logo"]] forState:MJRefreshStateRefreshing];
    //        [_header setImages:@[[UIImage imageNamed:@"logo"]] forState:MJRefreshStateIdle];
    
    [_header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header=_header;
    
}
-(NSInteger)index
{
    if (!_index) {
        _index=1;
    }
    return _index;
}

-(void)fresh
{
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)addFooterRefresh
{
    
    //上拉加载
    _footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        ;
        //1.页数增加
        self.index++;
        
        //2.重新请求数据
        
        [self GetShopOrderInfoWithStr:self.billType];
    }];
    
    self.tableView.mj_footer=_footer;
}
-(void)endFresh
{
    //如果没有更多数据
    
    [self.tableView.mj_header endRefreshing];
    [ self.tableView.mj_footer endRefreshing];
}
//没有更多数据
-(void)noModreData
{
    [_footer endRefreshingWithNoMoreData];
}

-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableView.frame;
    }
    return _placeView;
}
-(NSArray *)payTypeArray
{
    if (!_payTypeArray) {
        _payTypeArray=@[@"微信收款",@"支付宝收款",@"银联卡刷卡收款",@"现金收款"];
    }
    return _payTypeArray;
}
-(NSArray *)payTypeNo
{
    if (!_payTypeNo) {
        _payTypeNo=@[@"WEIXIN",@"ALIPAY",@"BANKPAY",@"001"];
    }
    return _payTypeNo;
}
//-(void)getPayType
//{
//    
//    NSDictionary *dic=@{@"FromTableName":@"POSCM",@"SelectField":@"CM001,CM002,CM003",@"Condition":[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@$AND$CM019$=$true$AND$CM023$=$true",@"MShop",_model.COMPANY],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
//    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
//     {
//         NSDictionary *dic1=[JsonTools getData:responseObject];
//        
//         _payTypeArray=[PayTypeModel getDatawithdic:dic1];
//         [_payTypeArray addObject:[self getPayModel]];
//     } Faile:^(NSError *error) {
//         NSLog(@"网络错误");
//     }];
//}
//-(PayTypeModel*)getPayModel
//{
//    PayTypeModel *model=[[PayTypeModel alloc]init];
//    model.CM002=@"退款订单";
//     model.CM001=@"退款订单";
//    return model;
//}
-(NSString *)startData
{
    if (!_startData) {
        _startData=@"";
    }
    return _startData;
}
-(NSString *)endData
{
    if (!_endData) {
       _endData=@"";
    }
    return _endData;
}
-(NSString *)memberno
{
    if (!_memberno) {
        _memberno=@"";
    }
    return _memberno;
}
-(NSString *)billType
{
    if (!_billType) {
        _billType=@"";
    }
    return _billType;
}

-(void)GetShopOrderInfoWithStr:(NSString*)str
{

    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID,@"OrderType":self.billType,@"PageIndex":[NSString stringWithFormat:@"%ld",self.index],@"PageSize":requsetSize,@"memberno":self.memberno,@"startDate":self.startData,@"endDate":self.endData};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopOrderInfo4" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        //判断刷新加载
        NSArray *array=[PayRecordModel getDataWithDic:dic1];
        if (array.count<requsetSize.intValue)
        {
            if (self.index==1)
            {
                //刷新
                
                self.dataArray=[PayRecordModel getDataWithDic:dic1];
                 [self endFresh];
                [self noModreData];
            }else
            {
                //加载
                 [self.dataArray addObjectsFromArray:array];
                 [self noModreData];
            }
        }else
        {
            if (self.index==1)
            {
                //刷新
              self.dataArray=[PayRecordModel getDataWithDic:dic1];
                [self endFresh];
                
            }else
            {
                //加载
                [self.dataArray addObjectsFromArray:array];
                [self endFresh];
                
            }
        }

        if (self.dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
           
            [self.tableView reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
- (void)loadBaseUI{

    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 44, screen_width, 1)];
    lineview.backgroundColor= [UIColor lightGrayColor];;
    [self.view addSubview:lineview];
    
        itemButton =[UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame=CGRectMake(0 ,0, screen_width, 44);
        [itemButton setTitle:@"全部订单" forState:UIControlStateNormal];
        itemButton.backgroundColor=[UIColor whiteColor];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view  addSubview:itemButton];
        [itemButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
  
    [self GetShopOrderInfoWithStr:self.billType];
}
-(void)buttonClick
{
    if (![self.view.subviews containsObject:_tableView2])
    {
        [self creatTable];
    }else
    {
        [self.tableView2 removeFromSuperview];
    }
    
}
-(void)creatTable
{
   
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_coverView];
    _tableView2.showsVerticalScrollIndicator=NO;
    _tableView2.showsHorizontalScrollIndicator=NO;
        _tableView2=[[UITableView alloc]initWithFrame:CGRectMake(0,46,screen_width ,48*self.payTypeArray.count) style:UITableViewStylePlain];
            
        _tableView2.delegate=self;
       _tableView2.dataSource=self;
    
    
        [_coverView addSubview:_tableView2];
        
 
    
}


#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView) {
         return _dataArray.count;
    }else
        NSLog(@"--------------%ld",self.payTypeArray.count);
        return self.payTypeArray.count;
        
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (tableView==_tableView)
        {
            static NSString *AddDetailTableViewCell_ID = @"StoreTwoTableViewCell";
            StoreTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"StoreTwoTableViewCell" owner:nil options:nil][0];
            }
            PayRecordModel *model=_dataArray[indexPath.row];
            cell.lable1.text=model.Payment1;
            cell.lable2.text=model.SB023;
            cell.lable3.text=model.sb015;
            cell.lable5.text=model.POtype;
            cell.lable6.hidden=NO;
            cell.lable3.font=[UIFont boldSystemFontOfSize:10];
            NSMutableString *muStr=[NSMutableString stringWithString:model.SB002];
            cell.lable4.text=[NSString stringWithFormat:@"订单号后五位%@",[muStr substringFromIndex:muStr.length-5]];
            cell.lable4.font=[UIFont systemFontOfSize:12];
            cell.lable5.textColor=navigationBarColor;
       
            return cell;

        }else
        {
            static NSString *ChooseTableViewCell_ID = @"ChooseTableViewCell";
            ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChooseTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
            }
//            PayTypeModel *model=_payTypeArray[indexPath.row];
            cell.contentLable.text=self.payTypeArray[indexPath.row];

           
            return cell;

            
        }
    return nil;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView==_tableView)
     {
         return 80;
     }else
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_tableView)
    {
           return 15;
       
    }else
         return 0.01;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==_tableView)
    {
         return 10;
       
    }else
         return 1;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        return nil;
    }else
    {
        UIView *lineview=[[UIView alloc]init];
        lineview.backgroundColor=[UIColor lightGrayColor];
        return lineview;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     if (tableView==_tableView)
     {
         PayRecordModel *model=_dataArray[indexPath.row];
         BuyDetailViewController *buy=[[BuyDetailViewController alloc]init];
         buy.title=@"买单详情";
         DefineWeakSelf;
         buy.backBlock=^{
             [weakSelf GetShopOrderInfoWithStr:weakSelf.billType];
         };
         buy.pmodel=model;
    
         [self.navigationController pushViewController:buy animated:YES];
         
     }else
     {

         [itemButton setTitle:self.payTypeArray[indexPath.row] forState:UIControlStateNormal];
         self.billType=self.payTypeNo[indexPath.row];
         self.index=1;
         [self GetShopOrderInfoWithStr:self.billType];
         [_tableView2 removeFromSuperview];
         [_coverView removeFromSuperview];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
