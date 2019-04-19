//
//  BillDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BillDetailViewController.h"
#import "AlreadyChosenTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "SBPModel.h"
#import "SalseReturnView.h"
#import "CoverView.h"
#import "PayDetailViewController.h"
#import "ChooseTableViewCell.h"
#import "SPTModel.h"
#import "DownOrderViewController.h"
#import "StockPayTypeViewController.h"
@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)MemberModel *Mmodel;
@property(nonatomic,copy)NSString *totalprice;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)SalseReturnView *salseView;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)NSMutableArray *SPTArray;
@property(nonatomic,strong)NSMutableArray *sonProductArray;
@property(nonatomic,strong)NSMutableArray *productArray;

@end

@implementation BillDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    _SPTArray=[NSMutableArray array];
    _sonProductArray=[NSMutableArray array];
     self.Mmodel=[[FMDBMember shareInstance]getMemberData][0];
    if (self.billModel)
    {
        if (self.billModel.funType==1) {
          [self creatBttom1];
        }
        
        [self getDetailDingDanWithString:self.billModel.SB002];
    }else
    {
        [self creatBttom];
        [self getDetailDingDanWithString:_dingDanNo];
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendBillSuccess) name:@"sendBillSuccess" object:nil];


    // Do any additional setup after loading the view from its nib.
}
-(void)creatBttom1
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-50-64, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    button.frame=CGRectMake(0,screen_height-49-64,screen_width, 49);
    button.backgroundColor=MainColor;
    [self.view addSubview:button];
    if (self.billModel) {
        [button setTitle:[NSString stringWithFormat:@"¥%@  去支付",self.billModel.SB023] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
  
}
-(void)gotoPay
{
    StockPayTypeViewController *stock=[[StockPayTypeViewController alloc]init];
    stock.title=@"支付";
    stock.billModel=_billModel;
    [self.navigationController pushViewController:stock animated:YES];
}
-(void)sendBillSuccess
{
    [self getDetailDingDanWithString:_dingDanNo];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark(获取订单详情)
-(void)getDetailDingDanWithString:(NSString *)str
{
    NSString *condition;
       if (self.billModel)
       {
           condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SBP002$=$%@",_billModel.company,_billModel.SHOPID,str];
           
       }else
       {
            condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SBP002$=$%@",_Mmodel.COMPANY,_Mmodel.SHOPID,str];
       }
   


    NSDictionary *dic=@{@"FromTableName":@"POSSBP",@"SelectField":@"SBP005,SBP009,SBP010,SBP011,SBP004,SBP003,SBP026,SBP027,SBP016,SBP017,SBP032,SBP014,SBP015,PSQuantity,TFQuantity",@"Condition":condition,@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"------------------%@",dic1);
        self.dataArray=[SBPModel getDataWithDic:dic1];
        [self changeArrayWithArray:_dataArray];
        if (!self.billModel) {
            [self getTotalPrice];
        }
         [self getAllData];
    } Faile:^(NSError *error) {
        
    }];
    
    
    
    
}
#pragma mark--获取订单内口味数据
-(void)getSPTdataWithStr:(NSString*)str
{
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSSBPT",@"SelectField":@"SPT003,SPT005,SPT006,SPT007,SPT004",@"Condition":[NSString stringWithFormat:@"SPT002$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"----%@",dic1);
        _SPTArray=[SPTModel getDatawithdic:dic1];
       
      
        
        
        
    } Faile:^(NSError *error) {
        
    }];

    
}
-(void)getAllData
{
   //主键数据
   _productArray=[NSMutableArray array];
    for (SBPModel *model in _dataArray) {
   
        if (model.SBP027.intValue==0) {
            [_productArray addObject:model];
        }
    }
  //子件加入主键
    for (SBPModel *model in _productArray) {
        for (SBPModel *model2 in _dataArray) {
            if (model2.SBP027.intValue==model.SBP003.intValue) {
                [model.sonProductArray addObject:model2];
            }
        }
    }
//  //加入商品
//    for (SBPModel *model in _productArray) {
//        for (SPTModel *smodel in _SPTArray) {
//            if (smodel.SPT003.intValue==model.SBP003.intValue) {
//                [model.SPTArray addObject:smodel];
//            }
//        }
//    }
//
    for (SBPModel *model in _productArray) {
        [self getModelDataWithModel:model];
    }
    
    [self.tableview reloadData];
    
}
-(void)getModelDataWithModel:(SBPModel*)model
{

    //套餐
    if (model.sonProductArray.count>0) {

        for (SBPModel *pmodel in model.sonProductArray) {


            NSString *str=[NSString stringWithFormat:@"+%@X%@",pmodel.SBP005,[pmodel.SBP009 removeZeroWithStr]];
            [model.detailMuStr appendString:str];


        }
        if (model.detailMuStr.length>0) {
            [model.detailMuStr deleteCharactersInRange:NSMakeRange(0, 1)];
        }

    }


    if (model.SBP026.length) {
        [model.detailMuStr appendString:model.SBP026];
    
    }
    //
    UILabel *lable=[[UILabel alloc]init];
    lable.numberOfLines=0;
    lable.text=model.detailMuStr;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lable sizeThatFits:CGSizeMake(screen_width-26, MAXFLOAT)];
    model.Bheight=size.height;
//    NSLog(@"%f",model.height);
}
#pragma mark--获得账单总价  人数  会员号 房台号
-(void)getTotalPrice
{
    NSString *conditinStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB003$=$%@$AND$SB002$=$%@",_Mmodel.COMPANY,_Mmodel.SHOPID,[self getTime],self.dingDanNo];
    NSDictionary*dic=@{@"FromTableName":@"possb",@"SelectField":@"SB023,SB009,SB016,SB005",@"Condition":conditinStr,@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"-----%@",dic1);
        self.totalprice=dic1[@"DataSet"][@"Table"][0][@"SB023"];
    
    } Faile:^(NSError *error) {
        
    }];
}

-(NSString*)zhuanhuanWithStr:(NSString*)str
{
    
    NSString *string1=[str stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return string1;
    
}
#pragma mark--获得返回的可退菜数量的数据
-(void)changeArrayWithArray:(NSMutableArray *)array
{
    for (SBPModel *model in self.dataArray)
    {
        NSInteger k=0;
        for (SBPModel *model1 in self.dataArray)
        {
            if ([model1.SBP032 isEqualToString:model.SBP003])
            {
                k=k+[model1.SBP009 intValue];
            }
        }
        model.leftCount=[model.SBP009 intValue]+k;
        
    }
}

#pragma mark--获取时间
-(NSString *)getTime
{
    
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"BusinessDate"];
    NSArray *timeArray=[time componentsSeparatedByString:@","];
    return timeArray[1];
}

-(void)creatBttom
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60-64, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    NSArray *nameArray=@[@"加菜",@"付款"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/nameArray.count*i,screen_height-59-64,screen_width/nameArray.count-1, 59);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Bill_%ld",i+1]] forState:UIControlStateNormal];
   
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.backgroundColor=[UIColor whiteColor];
        
        button.tag=i+1;
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
}
-(void)touch:(UIButton*)butt
{
    switch (butt.tag) {
       
        case 1:
        {
            //加菜
            DownOrderViewController *down=[[DownOrderViewController alloc]init];
            down.title=[NSString stringWithFormat:@"%@加菜",_model.SI002];
            down.isAdd=YES;
            down.runModel=@"01";
            down.seatModel=_model;
            down.dingDanNo=self.dingDanNo;
            [self.navigationController pushViewController:down animated:YES];
        }
            break;
            
        case 2:
        {
            //付款
            NSString *totoal=[NSString stringWithFormat:@"%@",[[self zhuanhuanWithStr:self.totalprice] removeZeroWithStr]];
            PayDetailViewController *pay=[[PayDetailViewController alloc]init];
            pay.title=@"付款";
            pay.billNo=self.dingDanNo;
            pay.seatNo=self.model.SI001;
            pay.seatName=self.model.SI002;
            pay.totalPrice=totoal;
            [self.navigationController pushViewController:pay animated:YES];
            
        }
            break;
            
            
        default:
            break;
    }
    
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _productArray.count+1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.text=@"已购商品";
        cell.left.constant=10;
        return cell;
        
        
    }else
    {
        static NSString *cellid=@"AlreadyChosenTableViewCell";
        SBPModel *model=_productArray[indexPath.row-1];
//        NSLog(@"－－%@",model.SBP026);
        AlreadyChosenTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"AlreadyChosenTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        __weak typeof(self)weakSelf=self;
        cell.tuicaiBlock=^{
            //退
            weakSelf.coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [self.view addSubview:weakSelf.coverView];
            SalseReturnView *salse=[[NSBundle mainBundle]loadNibNamed:@"SalseReturnView" owner:nil options:nil][0];
            salse.COMPANY=self.model.COMPANY;
            salse.SHOPID=self.model.SHOPID;
            salse.orderNumber=self.dingDanNo;
            [salse getModelDataWithModel:model];
            [weakSelf.coverView addSubview:salse];
            
            [salse mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf.coverView.mas_centerY).offset(-30);
                make.centerX.mas_equalTo(weakSelf.coverView.mas_centerX);
                make.width.mas_equalTo(screen_width*0.8);
                make.height.mas_equalTo(screen_height*2/3);
            }];
            //关闭
            salse.closeBlock=^{
                [weakSelf.coverView removeFromSuperview];
                [weakSelf.salseView removeFromSuperview];
            };
            //完成
            salse.doneBlock=^{
                [weakSelf.coverView removeFromSuperview];
                [weakSelf getDetailDingDanWithString:self.dingDanNo];

            };
            
        };
        
        [cell setDataWithModel:model];
        if (self.billModel) {
            cell.cancelButton.hidden=YES;
            cell.buttonWidth.constant=1;
        }
        
        return cell;
    }
 
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row!=0) {
        SBPModel *model=_productArray[indexPath.row-1];
        return 8+30+8+model.Bheight;
        
    }else
    return 44;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
