//
//  FinanciaManagerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FinanciaManagerViewController.h"
#import "AddClipTwoTableViewCell.h"
#import "AddDetailTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "NSDate+Extension.h"
#import "FinanciaModel.h"
#import "FinanciaOneTableViewCell.h"
#import "FinanciaTwoTableViewCell.h"
#import "StoreTwoTableViewCell.h"
#import "SZCalendarPicker.h"
#import "CashierManageViewController.h"
#import "cashierModel.h"
#import "BuyRecordViewController.h"
#import "ZWHThreeTableViewCell.h"


@interface FinanciaManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL _is;
    SZCalendarPicker *calendarPicker;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)FinanciaModel *fmodel;
@property(nonatomic,copy)NSString *stateString;
@property(nonatomic,copy)NSString *endString;
@property(nonatomic,copy)NSString *CstateString;
@property(nonatomic,copy)NSString *CendString;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,assign)NSInteger seleIndex;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *BottomView;
@property(nonatomic,copy)NSString *detailName;
@property(nonatomic,copy)NSString *cashNo;
@property(nonatomic,strong)PlaceholderView *placeView;

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *valueArr;


@end

@implementation FinanciaManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"线上支付(微信)",@"线下支付(现金)",@"储值卡(充值卡)",@"第三方(美团等)",@"商家券",@"平台券",@"抽奖",@"退款",@"支出(派派金等)",@"统计"];
    _model=[[FMDBMember shareInstance]getMemberData][0];
     _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
   
    //获取当前日期
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    _endString = [dateFormatter stringFromDate:nowDate];
 
    [_tableview registerClass:[ZWHThreeTableViewCell class] forCellReuseIdentifier:@"ZWHThreeTableViewCell"];
    //获取开始日期
//    NSDate *startDate=[nowDate dateBySubtractingDays:30];
    _stateString=_endString;
    [self creatHeadUI];
    [self GetShopOrderInfo];
    // Do any additional setup after loading the view from its nib.
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
- (void)creatHeadUI{

    NSArray *itemArray=@[[NSString stringWithFormat:@"%@至%@",_stateString,_endString],@"全部收银员"];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,50)];
    _headView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    [self.view addSubview:_headView];
    for (int i = 0; i<itemArray.count; i++) {
        UIButton *itemButton =[UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame=CGRectMake(screen_width*i/itemArray.count+0.5 ,0, screen_width/itemArray.count-1, 49);
        itemButton.tag = 100+i;
        [itemButton setTitle:itemArray[i] forState:UIControlStateNormal];
        if (screen_width==320) {
              itemButton.titleLabel.font=[UIFont systemFontOfSize:12];
        }else
        {
             itemButton.titleLabel.font=[UIFont systemFontOfSize:14];
        }
       
        itemButton.backgroundColor=[UIColor whiteColor];
        [itemButton setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
        [_headView addSubview:itemButton];
        
        [itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
   
    
}
-(NSString *)detailName
{
    if (!_detailName) {
        _detailName=@"今日数据";
    }
    return _detailName;
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag==100)
    {
            calendarPicker = [SZCalendarPicker showOnView:self.view];
            calendarPicker.today = [NSDate date];
            calendarPicker.isAnnimation=YES;
            calendarPicker.date = calendarPicker.today;
            calendarPicker.frame = CGRectMake(0, 111, self.view.frame.size.width, 352);
        DefineWeakSelf;
            calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
                [weakSelf changeButtonWith:year :month :day];
             
            };
        calendarPicker.backBlock=^{
            [weakSelf.topView removeFromSuperview];
             [weakSelf.BottomView removeFromSuperview];
        };
        [self creatTopView];
        [self creatBottomView];

        
    }else
    {
        //全部收银员
        CashierManageViewController *comm=[[CashierManageViewController alloc]init];
        comm.title=@"全部收银员";
        comm.chooseType=YES;
        DefineWeakSelf;
        comm.backBlock=^(cashierModel *model){
            weakSelf.cashNo=model.phoneNumber;
            UIButton *button=(UIButton*)[weakSelf.view viewWithTag:101];
            [button setTitle:model.name forState:UIControlStateNormal];
            [weakSelf GetShopOrderInfo];
        };
        [comm setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:comm animated:YES];
        
    }

}
-(void)changeButtonWith:(NSInteger)year :(NSInteger)month :(NSInteger)day
{
    UIButton *start=(UIButton*)[self.view viewWithTag:1];
    UIButton *end=(UIButton*)[self.view viewWithTag:2];
    NSArray *array=@[start,end];
    for (UIButton *butt in array) {
        if (butt.selected==YES) {
            NSString *Tday=[NSString stringWithFormat:@"%02ld",day];
            NSString *Tmonth=[NSString stringWithFormat:@"%02ld",month];
            if (butt.tag==1)
            {
                 _CstateString=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
             
                    [butt setTitle:[NSString stringWithFormat:@"起始时间(%ld/%@/%@)",(long)year,Tmonth,Tday] forState:UIControlStateNormal];
              
                
               
                
            }else
            {
                 _CendString=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
            
                    [butt setTitle:[NSString stringWithFormat:@"结束时间(%ld/%@/%@)",(long)year,Tmonth,Tday] forState:UIControlStateNormal];
               
               
            }
           
//            butt.titleLabel.text=[NSString stringWithFormat:@"%ld/%@/%@",(long)year,Tmonth,Tday];
        }
    }
}

-(void)creatBottomView
{
    self.BottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 111+352, self.view.width, 50)];
    self.BottomView.backgroundColor=[UIColor whiteColor];
     [self.view addSubview:self.BottomView];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(30,5,self.BottomView.width-60,40);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:19];
    button.backgroundColor=MainColor;
    [self.BottomView addSubview:button];
    [button addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)queding
{
     UIButton *button=(UIButton*)[self.view viewWithTag:100];
    if (_CstateString.length) {
        _stateString=_CstateString;
    }
    if (_CendString.length) {
        _endString=_CendString;
    }
    [button setTitle:[NSString stringWithFormat:@"%@至%@",_stateString,_endString] forState:UIControlStateNormal];
    self.detailName=[NSString stringWithFormat:@"%@至%@数据",_stateString,_endString];
    [self.topView removeFromSuperview];
    [self.BottomView removeFromSuperview];
    [calendarPicker removeFromSuperview];
    [calendarPicker.mask removeFromSuperview];
    [self GetShopOrderInfo];
}
-(void)creatTopView
{
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0,66, self.view.width, 45)];
    self.topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.topView];

    NSArray *nameArray=@[[NSString stringWithFormat:@"起始时间(%@)",_stateString],[NSString stringWithFormat:@"结束时间(%@)",_endString]];
    
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(self.topView.width/nameArray.count*i,0,self.topView.width/nameArray.count-1,40);
        

            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(self.topView.width/nameArray.count*i+20,40,self.topView.width/nameArray.count-40, 2)];
            lineView.backgroundColor=MainColor;
            lineView.tag=i+11;
            [self.topView addSubview:lineView];
        if (lineView.tag==11) {
            lineView.hidden=NO;
        }else
        {
            lineView.hidden=YES;
        }

        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:MainColor forState:UIControlStateSelected];
        if (screen_width==320) {
            button.titleLabel.font=[UIFont systemFontOfSize:12];
        }else
        {
            button.titleLabel.font=[UIFont systemFontOfSize:14];
        }
        button.backgroundColor=[UIColor whiteColor];
        button.tag=i+1;
        if (button.tag==1)
        {
            button.selected=YES;
            self.seleIndex=1;
        }
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];

        
    }
    
}
-(void)touch:(UIButton*)sender
{
    if (sender.tag==_seleIndex)
    {
        return;
    }else
    {
        UIButton *button=(UIButton*)[self.view viewWithTag:_seleIndex];
        button.selected=NO;
        UIView *line=[self.view viewWithTag:_seleIndex+10];
        line.hidden=YES;
        sender.selected=YES;
        self.seleIndex=sender.tag;
        UIView *Sline=[self.view viewWithTag:sender.tag+10];
        Sline.hidden=NO;

    }
    
 
    
}
-(NSString *)cashNo{
    if (!_cashNo) {
        _cashNo=@"";
    }
    return _cashNo;
}
-(void)GetShopOrderInfo
{

    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":self.model.COMPANY,@"shopid":self.model.SHOPID,@"startDate":_stateString,@"endDate":_endString,@"cashoperator":self.cashNo};
    
    MJWeakSelf;
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/GetShopOrderInfo5_new" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"--－－－%@",dic1);
        weakSelf.fmodel=[FinanciaModel getDataWithDic:dic1];
        FinanciaModel *model = weakSelf.fmodel;
        if (dic1[@"DataSet"][@"OrderInfo"])
        {
            weakSelf.valueArr = @[@[model.onlineamount1,model.offlineamount1,model.memberamount1,model.othercouponamount1,model.shopcouponamount1,model.platformcouponamount1,[NSString stringWithFormat:@"%.2f",[model.lotteryamount1 floatValue]],model.quitamount1,model.subamount1,model.totalamount1],@[model.onlineamount2,model.offlineamount2,model.memberamount2,model.othercouponamount2,model.shopcouponamount2,model.platformcouponamount2,[NSString stringWithFormat:@"%.2f",[model.lotteryamount2 floatValue]],model.quitamount2,model.subamount2,model.totalamount2]];
            [self.tableview reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }

    
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}

#pragma mark--delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    QMUILabel *left = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor grayColor]];
    [header addSubview:left];
    left.textAlignment = NSTextAlignmentCenter;
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.mas_left).offset(SCREEN_WIDTH/3/2);
        make.centerY.equalTo(header);
    }];
    
    QMUILabel *center = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor grayColor]];
    [header addSubview:center];
    center.textAlignment = NSTextAlignmentCenter;
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.contentView).offset(WIDTH_PRO(150));
        make.center.equalTo(header);
    }];
    
    QMUILabel *right = [[QMUILabel alloc]qmui_initWithFont:ZWHFont(13) textColor:[UIColor grayColor]];
    right.textAlignment = NSTextAlignmentRight;
    [header addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.mas_right).offset(-(SCREEN_WIDTH/3/2));
        make.centerY.equalTo(header);
    }];
    
    left.text = @"项目";
    center.text = @"金额";
    right.text = @"结算";
    
    return section==0?header:nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?HEIGHT_PRO(35):0.01;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)
    {
        return _titleArr.count;
    }else
    {
        return _fmodel.Detail.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0)
    {
        /*张卫煌修改*/
        ZWHThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWHThreeTableViewCell" forIndexPath:indexPath];
        cell.leftL.text = _titleArr[indexPath.row];
        if (_valueArr.count>0) {
            cell.centerL.text = [NSString stringWithFormat:@"¥ %@",_valueArr[0][indexPath.row]];
            cell.rightL.text = [NSString stringWithFormat:@"¥ %@",_valueArr[1][indexPath.row]];
        }
        
        
        if (indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9) {
            cell.line.hidden = NO;
        }
        
        if (indexPath.row == 9) {
            cell.leftL.textColor = [UIColor orangeColor];
        }
        
        return cell;
        
        
        /*if (indexPath.row==0)
        {
            FinanciaOneTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"FinanciaOneTableViewCell" owner:nil options:nil][0];
            cell.tptalPrice.text=[NSString stringWithFormat:@"%.2f",_fmodel.TotalShopAmount.floatValue];
            NSLog(@"%@",self.detailName);
            cell.nameLable.text=self.detailName;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else
        {
           
           FinanciaTwoTableViewCell *cell =[[NSBundle mainBundle]loadNibNamed:@"FinanciaTwoTableViewCell" owner:nil options:nil][0];
            if (indexPath.row==1)
            {
                cell.lable1.text=@"营业金额(元)";
                cell.lable2.text=[NSString stringWithFormat:@"%.2f",_fmodel.TotalAmount.floatValue];
            }else if (indexPath.row==2)
            {
                cell.lable1.text=@"实结金额(元)";
                 cell.lable2.text=[NSString stringWithFormat:@"%.2f",_fmodel.TotalShopAmount1.floatValue];
                
            }else
            {
                cell.lable1.text=@"退款金额(元)";
                 cell.lable2.text=[NSString stringWithFormat:@"%.2f",_fmodel.TotalShopAmount2.floatValue];
            }
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }*/
        
     
    }else
    {
        NSDictionary *dic=_fmodel.Detail[indexPath.row];
        static NSString *AddDetailTableViewCell_ID = @"StoreTwoTableViewCell";
        StoreTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"StoreTwoTableViewCell" owner:nil options:nil][0];
        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.lable4.hidden=YES;
        cell.lable2.hidden=YES;
        cell.lable5.textColor=[UIColor lightGrayColor];
        cell.lable1.text=[NSString stringWithFormat:@"%@付款",dic[@"payname"]];
        cell.lable3.text=[NSString stringWithFormat:@"金额%@",dic[@"payamount"]];
        cell.lable5.text=[NSString stringWithFormat:@"%@笔",dic[@"paycount"]];
        return cell;

        
    }
    return nil;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            
            /*if (indexPath.row==0)
            {
                 return 90;
            }else
            {
                return 70;
            }*/
            return HEIGHT_PRO(37);
        }
            break;
     
            
        default:
             return 70;
            break;
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1) {
          NSDictionary *dic=_fmodel.Detail[indexPath.row];
        BuyRecordViewController *buy=[[BuyRecordViewController alloc]init];
        buy.billType=dic[@"payno"];
        buy.startData=self.stateString;
        buy.endData=self.endString;
        buy.title=@"买单记录";
        [self.navigationController pushViewController:buy  animated:YES];
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
-(void)dealloc
{
    NSLog(@"dealloc+finan");
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
