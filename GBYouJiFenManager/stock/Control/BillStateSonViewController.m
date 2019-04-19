//
//  BillStateSonViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BillStateSonViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "BillStateTableViewCell.h"
#import "ADBillModel.h"
#import "StockPayTypeViewController.h"
#import "BillDetailViewController.h"
#import "AreaSetView.h"
#import "CoverView.h"
@interface BillStateSonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel*model;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)AreaSetView *areaSetView;
@property(nonatomic,strong)MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong)MJRefreshGifHeader *header;
@property(nonatomic,assign)NSInteger index;
@end

@implementation BillStateSonViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;

    //SelectVC
    [self fresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewChange:) name:@"SelectVC" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)index
{
    if (!_index) {
        _index=1;
    }
    return _index;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewChange:(NSNotification*)notic
{
    NSInteger k=[notic.object intValue];
    
    NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
    if ([shopType isEqualToString:@"DS"])
    {
        //卖家模式
        if (_fun==k+1) {
            [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }
        
    }else
    {
        //买家模式
        if (_fun==k) {
            [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }
        
    }
    
}
-(MemberModel *)model
{
    if (!_model) {
        _model=[[FMDBMember shareInstance]getMemberData][0];
    }
    return _model;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(void)B2BOrderInfo2WithStr:(NSString*)str
{

    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"shopid":self.model.SHOPID,@"mode":str,@"pageindex":[NSString stringWithFormat:@"%ld",self.index],@"pagesize":requsetSize};
//    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BOrderInfo1" With:dic and:^(id responseObject) {
       
        NSDictionary *dic1=[JsonTools getData:responseObject];
        if (self.index==1)
        {
            //不是加载的情况
            [_dataArray removeAllObjects];
            
            
        }
           [_dataArray addObjectsFromArray:[ADBillModel getDatawithdic:dic1]];
        [self chanFootWithArray:[ADBillModel getDatawithdic:dic1]];
         [SVProgressHUD dismiss];
        [self.tableView reloadData];
        [self endFresh];
    } Faile:^(NSError *error) {
       
    }];
}
-(void)B2BOrderInfo1WithStr:(NSString*)str
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"shopid":self.model.SHOPID,@"mode":str,@"pageindex":[NSString stringWithFormat:@"%ld",self.index],@"pagesize":requsetSize};
//        NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BOrderInfo2" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
//           NSLog(@"%@",dic1);
        if (self.index==1)
        {
            //不是加载的情况
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[ADBillModel getDatawithdic:dic1]];
        [self chanFootWithArray:[ADBillModel getDatawithdic:dic1]];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
         [self endFresh];
    } Faile:^(NSError *error) {
        
    }];
}
#pragma mark-table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"BillStateTableViewCell";
    BillStateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"BillStateTableViewCell" owner:nil options:nil][0];
    }
    ADBillModel *model=self.dataArray[indexPath.row];
    [cell setDataWithMode:model];
    [self swichWithCell:cell];
    DefineWeakSelf;
    cell.touBlock=^(NSInteger k){
        NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
        
        switch (k) {
            case 1:
            {
              
            
            }
                break;
            case 2:
            {
                //快递单号
                   if ([shopType isEqualToString:@"DS"])
                   {
                       if (_fun==2) {
                            [self B2BDealTrackingNoWithMoel:model];
                       }
                   }
            
             
               
            }
                break;
            case 3:
            {
                if ([shopType isEqualToString:@"DS"])
                {
                    if (_fun==2) {
                        //审核
                        [self B2BConfirmPOWithMoel:model];
                    }else if (_fun==3)
                    {
                        //取消审核
                        [self cancelWithMoel:model];
                    }
                }else
                {
                    //删除
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除订单?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //确认删除
                         [weakSelf B2BDeleteBill1WithMoel:model];
                    
                        
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    
                    [self presentViewController:alert animated:YES completion:nil];

                   
                }
                
           
            
                
            }
                break;
            case 4:
            {
                if ([shopType isEqualToString:@"DS"])
                {
                    if (_fun==2)
                    {
                        //退货
                        [self B2BQuitBillWithMoel:model];
                    }else if (_fun==3)
                    {
                        //确认收货
                        [self B2BDealReceivingWithMoel:model];
                    }
                    
                }else
                {
                    if (_fun==1)
                    {
                        //去付款
                        [weakSelf toPayWithMoel:model];
                    }else if (_fun==3)
                    {
                        //确认收货
                        [self B2BDealReceivingWithMoel:model];
                    }
               
                }
                
            }
                break;
                
            
        }
    };
    return cell;
}
-(void)swichWithCell:(BillStateTableViewCell*)cell
{
    NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
    
    switch (_fun) {
        case 1:
        {
          
            
                [cell.button1 removeFromSuperview];
                [cell.button2 removeFromSuperview];
                cell.button4.backgroundColor=navigationBarColor;
                [cell.button4 setTitle:@"去付款" forState:UIControlStateNormal];
                cell.button3.backgroundColor=[UIColor lightGrayColor];
                [cell.button3 setTitle:@"删除" forState:UIControlStateNormal];
                cell.button4_wideth.constant=80;
                cell.button3_wideth.constant=60;
            
      
            
        }
            break;
        case 2:
        {
            if ([shopType isEqualToString:@"DS"])
            {
                
                cell.button2.backgroundColor=[UIColor lightGrayColor];
                [cell.button2 setTitle:@"快递单号" forState:UIControlStateNormal];
                [cell.button3 setTitle:@"审核" forState:UIControlStateNormal];
                cell.button3.backgroundColor=[UIColor lightGrayColor];
                 cell.button4.backgroundColor=[UIColor lightGrayColor];
                [cell.button4 setTitle:@"退货" forState:UIControlStateNormal];
                cell.button2_wideth.constant=80;
                cell.button3_wideth.constant=60;
                cell.button4_wideth.constant=60;
            }else
            {
                [cell.button1 removeFromSuperview];
                [cell.button2 removeFromSuperview];
                [cell.button3 removeFromSuperview];
                [cell.button4 removeFromSuperview];
                
                cell.buttonView_Height.constant=0;
            }
           
        }
            break;
        case 3:
        {

            if ([shopType isEqualToString:@"DS"])
            {
                [cell.button3 setTitle:@"取消审核" forState:UIControlStateNormal];
                cell.button3.backgroundColor=[UIColor lightGrayColor];
                cell.button4.backgroundColor=navigationBarColor;
                [cell.button4 setTitle:@"确认收货" forState:UIControlStateNormal];
                 cell.button4_wideth.constant=80;
                cell.button3_wideth.constant=80;
                [cell.button1 removeFromSuperview];
                [cell.button2 removeFromSuperview];
            }else
            {
                [cell.button1 removeFromSuperview];
                [cell.button2 removeFromSuperview];
                [cell.button3 removeFromSuperview];
                cell.button4.backgroundColor=navigationBarColor;
                [cell.button4 setTitle:@"确认收货" forState:UIControlStateNormal];
                cell.button4_wideth.constant=80;
            }
       
        }
            break;
        case 4:
        {
            [cell.button1 removeFromSuperview];
            [cell.button2 removeFromSuperview];
            [cell.button3 removeFromSuperview];
            [cell.button4 removeFromSuperview];
            cell.buttonView_Height.constant=0;
        }
            break;
            
        default:
        {
            [cell.button1 removeFromSuperview];
            [cell.button2 removeFromSuperview];
            [cell.button3 removeFromSuperview];
            [cell.button4 removeFromSuperview];
            
            cell.buttonView_Height.constant=0;
            
        }
            break;
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        return 0.01;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
    switch (_fun) {
        case 1:
        {
            return 140;
        }
            break;
        case 2:
        {
            if ([shopType isEqualToString:@"DS"])
            {
                 return 140;
            }else
            {
                 return 90;
            }
          
        }
            break;
        case 3:
        {
            return 140;
        }
            break;
        case 4:
        {
            return 90;
        }
            break;
            
        default:
        {
          return 90;
            
        }
            break;
    }


            return 90;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADBillModel *model=self.dataArray[indexPath.row];
    if (_fun==1)
    {
        model.funType=1;
        BillDetailViewController *detail=[[BillDetailViewController alloc]init];
        detail.title=model.POtype;
        detail.billModel=model;
        [self.navigationController pushViewController:detail animated:YES];
    }else
    {
        model.funType=0;
        BillDetailViewController *detail=[[BillDetailViewController alloc]init];
        detail.title=model.POtype;
        detail.billModel=model;
        [self.navigationController pushViewController:detail animated:YES];
    }
 
    
}
//付款
-(void)toPayWithMoel:(ADBillModel*)model
{
     NSLog(@"付款");
    StockPayTypeViewController *stock=[[StockPayTypeViewController alloc]init];
    stock.title=@"支付";
    stock.billModel=model;
    [self.navigationController pushViewController:stock animated:YES];
}
//删除
-(void)B2BDeleteBill1WithMoel:(ADBillModel*)model
{
    NSLog(@"删除");
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":model.company,@"shopid":model.SHOPID,@"billno":model.SB002,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BDeleteBill1" With:dic and:^(id responseObject) {
       NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
                if ([shopType isEqualToString:@"DS"])
                {
                    [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }else
                {
                    [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }
                
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
    } Faile:^(NSError *error) {
        NSLog(@"请求错误%@",error);
    }];

    
}
-(void)alertShowWithString:(NSString *)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
//审核
-(void)B2BConfirmPOWithMoel:(ADBillModel*)model
{

    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":model.company,@"shopid":model.SHOPID,@"billno":model.SB002,@"mode":@"1",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BConfirmPO" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"审核成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
                if ([shopType isEqualToString:@"DS"])
                {
                    [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }else
                {
                    [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
    } Faile:^(NSError *error) {
     
    }];

    
}
//快递单号
-(void)B2BDealTrackingNoWithMoel:(ADBillModel*)model
{
     NSLog(@"快递单号");
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _areaSetView=[[NSBundle mainBundle]loadNibNamed:@"AreaSetView" owner:nil options:nil][0];
    _areaSetView.lNameable.text=@"快递单号";
    _areaSetView.funType=@"number";
    DefineWeakSelf;
    _areaSetView.tastBlock=^(NSString *number){
        
        [weakSelf numberRecorderWithStr:number :model];
        [weakSelf.areaSetView removeFromSuperview];
         [weakSelf.coverView removeFromSuperview];
    };
    [_coverView addSubview:_areaSetView];
    [_areaSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_coverView.mas_centerX);
        make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-70);
        make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.9);
        make.height.mas_equalTo(200);
        
    }];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];


}
-(void)numberRecorderWithStr:(NSString*)str :(ADBillModel*)model
{
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *dic=@{@"company":model.company,@"shopid":model.SHOPID,@"billno":model.SB002,@"trackingno":@"1234",@"CipherText":CIPHERTEXT};
    
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BDealTrackingNo" With:dic and:^(id responseObject) {
            NSString *str=[JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"true"])
            {
                [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                    [SVProgressHUD dismiss];
    
                });
    
            }else
            {
                [SVProgressHUD dismiss];
    
                [self alertShowWithString:str];
            }
        } Faile:^(NSError *error) {
            
        }];
}
//退货
-(void)B2BQuitBillWithMoel:(ADBillModel*)model
{
     NSLog(@"退货");
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"billno":model.SB002,@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BQuitBill" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"退货成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
                if ([shopType isEqualToString:@"DS"])
                {
                    [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }else
                {
                    [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
    } Faile:^(NSError *error) {
        
    }];
    

    
}
//确认收货
-(void)B2BDealReceivingWithMoel:(ADBillModel*)model
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":model.company,@"shopid":model.SHOPID,@"billno":model.SB002,@"CipherText":CIPHERTEXT};
 
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BDealReceiving" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
                if ([shopType isEqualToString:@"DS"])
                {
                    [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }else
                {
                    [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
    } Faile:^(NSError *error) {
        
    }];
    
    
}
-(void)cancelWithMoel:(ADBillModel*)model
{
      NSLog(@"取消审核");
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":model.company,@"shopid":model.SHOPID,@"billno":model.SB002,@"mode":@"0",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BConfirmPO" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
                if ([shopType isEqualToString:@"DS"])
                {
                    [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }else
                {
                    [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
                }
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
    } Faile:^(NSError *error) {
        
    }];

    
}
-(void)fresh
{
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)addHeaderRefresh
{
    _header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //1.重置页数
        self.index=1;
        //2.清空页数
        [_dataArray removeAllObjects];
        //3.重新发生网络请求
        NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
        
        if ([shopType isEqualToString:@"DS"])
        {
            [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }else
        {
            [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }
        
    }];
    //    NSArray *imageArr=@[[UIImage imageNamed:@"loadAni_1"],[UIImage imageNamed:@"loadAni_2"],[UIImage imageNamed:@"loadAni_3"],[UIImage imageNamed:@"loadAni_4"],[UIImage imageNamed:@"loadAni_5"]];
    //    //正在刷新中的状态
    //    [header setImages:imageArr forState:MJRefreshStateRefreshing];
    //
    //    [header setImages:@[[UIImage imageNamed:@"loadAni_1"]] forState:MJRefreshStateIdle];
    
    [_header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header=_header;
    
}

-(void)addFooterRefresh
{
    
    //上拉加载
    
    _footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        ;
        //1.页数增加
        self.index++;
        
        //2.重新请求数据
        //        if (_pageArray.count<10)
        //        {
        //            [_footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
        //        }else{
        //            [_footer setTitle:@"点击或上拉加载更多数据" forState:MJRefreshStateIdle];
        //        }
        //        [_footer setTitle:@"正在加载更多数据更多数据" forState:MJRefreshStateRefreshing];
        
      
        NSString *shopType=[[NSUserDefaults standardUserDefaults]objectForKey:@"ShopType"];
        
        if ([shopType isEqualToString:@"DS"])
        {
            [self B2BOrderInfo1WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }else
        {
            [self B2BOrderInfo2WithStr:[NSString stringWithFormat:@"%ld",_fun]];
        }
    }];
    
    self.tableView.mj_footer=_footer;
}
-(void)chanFootWithArray:(NSMutableArray *)array{
    if (array.count<requsetSize.integerValue)
    {
        _footer.hidden=YES;
    }else
    {
         _footer.hidden=NO;
    }
}
-(void)endFresh
{
    //如果没有更多数据

    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
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
