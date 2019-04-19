//
//  StockShopViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/9.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StockShopViewController.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "ProductModel.h"
@interface StockShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation StockShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableview.backgroundColor=[ColorTool colorWithHexString:@"#f4f4f4"];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self getShopProductWithStr:self.shopModel.SHOPID];
    // Do any additional setup after loading the view from its nib.
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

//获取店铺商品信息
-(void)getShopProductWithStr:(NSString*)shopid
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"inv_bproduct",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"supplierno$=$%@",self.shopModel.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    //    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        //        NSLog(@"%@",dic1);
        if (dic1) {
            self.dataArray=[ProductModel getDataWithDic:dic1];
        }
        [self.tableview reloadData];
        
    } Faile:^(NSError *error) {
        
    }];
    
}
#pragma mark -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        return 80;
    }else if((indexPath.section==1))
    {
        return 50;
    }else
    {
        if (self.dataArray.count%2)
        {
           return  (self.dataArray.count/2+1)*(screen_width/2+45)+50;
        }else
        {
            return (self.dataArray.count/2)*(screen_width/2+45)+50;
        }
        
    }
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (indexPath.section==0)
    {
        static NSString *cellID = @"FirstTableViewCell";
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:nil options:nil][0];
        }
        [cell setDataWithModel:self.shopModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section==1)
    {
        static NSString *cellID = @"ThirdTableViewCell";
        ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil][0];
        }
        cell.phoneNu.text=self.shopModel.Mobile;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else
    {
        static NSString *cellID = @"FirstTableViewCell";
        SecondTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SecondTableViewCell" owner:nil options:nil][0];
        }
        cell.dataArray=self.dataArray;
        DefineWeakSelf;
        cell.pushBlock=^(ProductModel *model){
//           PeocurDetailViewController *peo=[[PeocurDetailViewController alloc]init];
//            peo.title=@"商品详情";
//            peo.shop=YES;
//            [weakSelf.navigationController  pushViewController:peo animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0.01;
    }else if(section==1)
    {
        return 10;
    }else
    {
        return 20;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
