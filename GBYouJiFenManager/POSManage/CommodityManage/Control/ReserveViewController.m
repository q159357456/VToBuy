//
//  ReserveViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/16.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ReserveViewController.h"
#import "ReserveTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "STSModel.h"
#import "OrderViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ReserveDetailViewController.h"
@interface ReserveViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
        UITextField *searchField;
}

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)STSModel *model;
@property(nonatomic,strong)MemberModel *Mmodel;
@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Mmodel=[[FMDBMember shareInstance]getMemberData][0];
    [self createUI];
    [self getData];
//    yuDingSuccess
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yuDingSuccess) name:@"yuDingSuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)yuDingSuccess
{
    [self getData];
}
-(void)getData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];

    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@$AND$STS011$=$N",model.SHOPID,model.COMPANY];
    NSDictionary *dic=@{@"FromTableName":@"POSSTS[A]||POSSI[B]{left (A.company=B.company and A.shopid=B.shopid and A.STS010=B.SI001)}",@"SelectField":@"A.*,B.SI002",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//                NSLog(@"%@",dic1);
        
        _dataArray=[STSModel getDatawithdic:dic1];
//        NSLog(@"%ld",_dataArray.count);
        
        [_tableview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)createUI
{
    //创建搜索栏
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, screen_width-30, 45)];
    searchField.placeholder = @"搜索";
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.borderWidth = 1.0f;
    searchField.layer.cornerRadius = 8;
    searchField.layer.masksToBounds = YES;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchField.frame.size.width-45, 8, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //searchBtn.backgroundColor = [UIColor redColor];
//    [searchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchField addSubview:searchBtn];
    [self.view addSubview:searchField];
 
    //
    NSArray *title = @[@"台号",@"人数",@"联系人",@"预定时间"];
    UIView*ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, screen_width, 40)];
    ItemView.backgroundColor = navigationBarColor;
//  UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(28+i*(screen_width-28)/array.count, 0, (screen_width-28)/array.count, self.height)];

    for (int i = 0; i<title.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(28+i*(screen_width-28)/title.count,0,(screen_width-28)/title.count, 40)];
        lab.text = title[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor=[UIColor whiteColor];
        [ItemView addSubview:lab];
    }
    [self.view addSubview:ItemView];
 
    //
    [self cretTable];
    
    
    //底部按钮
    [self creatBttom];
    
}
-(void)cretTable
{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 106, screen_width, screen_height-106-60-64) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    self.keyTableView = _tableview;
    
}

-(void)creatBttom
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60-64, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    NSArray *nameArray=@[@"查看",@"作废",@"开台",@"新增"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/4*i,screen_height-59-64,screen_width/4-1, 59);

        if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/4*i-1,screen_height-50-64, 1, 40)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [self.view addSubview:lineView];
        }
        
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
            //查看
            if (self.model) {
                ReserveDetailViewController *detail=[[ReserveDetailViewController alloc]init];
                detail.tmoel=_model;
                detail.title=@"预定详情";
                [self.navigationController pushViewController:detail animated:YES];
            }else
            {
                [self alertShowWithStr:@"请选择订单"];
            }
            
        }
            break;
        case 2:
        {
            //作废
            if (self.model) {
                [self cancelSeatWithModel];
            }else
            {
                 [self alertShowWithStr:@"请选择订单"];
            }
            
       
        }
            break;
            
        case 3:
        {
            //开台
            if (self.model) {
                  [self startSeatWithModel];
            }else
            {
                [self alertShowWithStr:@"请选择订单"];
            }
          
        
            
        }
            break;
            
        case 4:
        {
            //新增
            OrderViewController *order=[[OrderViewController alloc]init];
            order.chooseType=YES;
            order.title=@"选择预定房台";
            [self.navigationController pushViewController:order animated:YES];
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}
-(void)startSeatWithModel
{
   
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    //公共参数
    NSString *DeviceNo =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"];
    
    NSString *Area =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN006"];

   
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"BusinessDate"];
   
    NSArray *timeArray=[time componentsSeparatedByString:@","];
    NSString* dateString=timeArray[1];
    NSString *ClassesInfo =[[NSUserDefaults standardUserDefaults]valueForKey:@"ClassesInfo"];
  
    NSArray *classArray=[ClassesInfo componentsSeparatedByString:@","];
    NSString *ClassesNo=classArray[0];
    NSString *ClassesIndex=classArray[2];
//    inv_product[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}

    NSDictionary *dic=@{@"company":_Mmodel.COMPANY,@"shopid":_Mmodel.SHOPID,@"billno":_model.STS001,@"seatno":_model.STS010,@"shopday":dateString,@"area":Area,@"classesno":ClassesNo,@"classesindex":ClassesIndex,@"deviceno":DeviceNo,@"userno":_Mmodel.Mobile};
  
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"posservice.asmx/PreOrderConfirm" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"确认成功"])
        {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self getData];
            });
        }else
        {
            [self alertShowWithStr:str];
        }
        
        
    } Faile:^(NSError *error)
     {
         NSLog(@"错误%@",error);
     }];

    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)cancelSeatWithModel
{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":_Mmodel.COMPANY,@"shopid":_Mmodel.SHOPID,@"billno":_model.STS001,@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"posservice.asmx/DeletePreOrderBill" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"true"])
        {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                [self getData];
                
            });
        }else
        {
              [self alertShowWithStr:str];
        }
        
        
    } Faile:^(NSError *error)
     {
         NSLog(@"错误%@",error);
     }];


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

        STSModel *model=_dataArray[indexPath.row];
        static NSString *cellid=@"ReserveViewController ";
        ReserveTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ReserveTableViewCell" owner:nil options:nil][0];
            
        }
    NSArray *array=@[model.SI002,model.STS009,model.STS008,model.STS003];
    [cell initLabelWithArray:array];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=navigationBarColor;
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
    
//        return cell;
    
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
        STSModel *model=_dataArray[indexPath.row];
        //商品表
        for (STSModel *smodel in _dataArray) {
            if ([smodel.STS001 isEqualToString:model.STS001])
            {
                smodel.selected=!smodel.selected;
                //
                if (smodel.selected==YES) {
                    self.model=smodel;
                }else
                {
                    self.model=nil;
                }
            }else
            {
                smodel.selected=NO;
            }
        }
        [self.tableview reloadData];
    
}
    
    

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
        return 0.01;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
        return 0.01;
    
    
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
