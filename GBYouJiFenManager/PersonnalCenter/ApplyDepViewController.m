//
//  ApplyDepViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/23.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ApplyDepViewController.h"
#import "ProuctTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "DespositModel.h"
@interface ApplyDepViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;


@end

@implementation ApplyDepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self getAllData];
    //     ProuctTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    // Do any additional setup after loading the view from its nib.
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Shopwithdraw",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
    NSLog(@"%@",dic1);
        _dataArray=[DespositModel getDataWithDic:dic1];
        
        [self.tableview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    DespositModel *model=_dataArray[indexPath.row];
      static NSString *cellid=@"ProuctTableViewCellID";
    ProuctTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"ProuctTableViewCell" owner:nil options:nil][0];
    }
    cell.ledLeft.constant=0;
    cell.choseView.hidden=YES;
    cell.classiFy.text=model.WithdrawCash;
    cell.productName.text=model.Remark;
    cell.price.text=model.CREATE_DATE;
    if (screen_width==320) {
        cell.classiFy.font=[UIFont systemFontOfSize:12];
        cell.price.font=[UIFont systemFontOfSize:10];
    }else
    {
            cell.price.font=[UIFont systemFontOfSize:14];
    }

    cell.price.textColor=[UIColor lightGrayColor];
    
      
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        return 50;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSArray *title = @[@"提现金额",@"审核状态",@"申请日期"];
    UIView*ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 145, screen_width, 40)];
    ItemView.backgroundColor = navigationBarColor;
    
    for (int i = 0; i<title.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((screen_width/3)*i, 0, screen_width/3, 40)];
        lab.text = title[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor=[UIColor whiteColor];
        [ItemView addSubview:lab];
    }
    return ItemView;


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
