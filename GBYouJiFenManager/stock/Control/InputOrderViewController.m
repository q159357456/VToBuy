//
//  InputOrderViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "InputOrderViewController.h"
#import "AddressChooseTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "StInputOrderTableViewCell.h"
#import "addressModel.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "AddDetailTableViewCell.h"
#import "ProductModel.h"
#import "MyAddressViewController.h"
#import "FMDBShopInfo.h"
#import "StockPayTypeViewController.h"
#import "ADBillModel.h"
#import "FMDBShopCar.h"
#import "CoverView.h"
#import "BillStateViewController.h"
@interface InputOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)NSMutableArray *buyArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSString *orderNo;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)UITableView *tableview2;
@end
@implementation InputOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.doneButton.backgroundColor=navigationBarColor;
    float prie = 0.0;
    for (ProductModel *model in _dataArray) {
        prie=prie+model.count*model.RetailPrice.floatValue;
        self.priceLable.text=[NSString stringWithFormat:@"合计:¥%.2f",prie];
    }
    //获得默认收货地址
    [self getDefautAdress];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}
-(void)getDefautAdress
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_MyAddress",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$DefaultAddr$=$True",self.model.COMPANY,self.model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        NSArray *array= [addressModel getDataWithDic:dic1];
        if (array.count>0) {
            addressModel *aModel=array[0];
            AddressChooseTableViewCell *cell=(AddressChooseTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.nameLabel.text = aModel.contact;
            cell.numberLabel.text = aModel.mobile;
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",aModel.area,aModel.address];
        }
    
//        self.adeessID=model.ID;
        NSLog(@"%@",dic1);
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
#pragma mark -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)
    {
        return 1;
    }else
    {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        return 100;
    }else
    {
        if (indexPath.row==0)
        {
            return self.dataArray.count*100;
        }else
        {
            return 50;
        }
    }
    return 100;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0)
    {
        static NSString *cellID = @"AddressChooseTableViewCell";
        AddressChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddressChooseTableViewCell" owner:nil options:nil][0];
        }
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else
    {
        if (indexPath.row==0)
        {
            
            static NSString *cellID = @"StInputOrderTableViewCell";
            StInputOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"StInputOrderTableViewCell" owner:nil options:nil][0];
            }
            cell.dataArray=self.dataArray;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if(indexPath.row==1)
        {
            static NSString *cellID = @"AddDetailTableViewCell";
        
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.nameLeft.constant=14;
            cell.nameLable.text=@"配送方式:";
            cell.inputText.enabled=NO;
            cell.inputText.text=@"快递";
            cell.inputText.textAlignment=NSTextAlignmentRight;
            cell.inputText.tag=indexPath.row;
            cell.seprateView.hidden=YES;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }else
        {
            static NSString *cellID = @"AddDetailTableViewCell";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.nameLeft.constant=14;
            cell.nameLable.text=@"买家留言:";
             cell.seprateView.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 50;
    }else
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        MyAddressViewController *aress=[[MyAddressViewController alloc]init];
        [self.navigationController pushViewController:aress animated:YES];
    }else
    {
        if (indexPath.row==1) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"快递" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textfield=(UITextField*)[self.view viewWithTag:1];
                textfield.text=@"快递";
                
            }];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"货到付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textfield=(UITextField*)[self.view viewWithTag:1];
                textfield.text=@"货到付款";
                
            }];
         
            [alert addAction:action];
            [alert addAction:action1];
            ;
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    
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

- (IBAction)doen:(UIButton *)sender {
    if (self.orderNo.length)
    {
        NSLog(@"一已送单");
        [self pushOrder];
    }else
    {
          NSLog(@"一未送单");
        [self sendStockBill];
    }
    
}
#pragma mark--前端产生订单号
-(NSString *)getQuciklyOrderNo
{
    //DateTime.Now.ToString("yyMMddHHmmssfff") + (new Random()).Next(10000, 99999).ToString();
    //日期
    NSString *dateString;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    dateString = [dateFormatter stringFromDate:currentDate];
    //随机数
    int k=[self getRandomNumber:10000 to:99999];
    NSString *kStr=[NSString stringWithFormat:@"%d",k];
    NSString *arcStr=[NSString stringWithFormat:@"%@%@",dateString,kStr];
    NSMutableString  *str=[NSMutableString stringWithString:arcStr];
    [str deleteCharactersInRange:NSMakeRange(0, 2)];
    return str;
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
-(void)sendStockBill
{
   
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSArray *bjsonArray=[NSArray array];
    self.orderNo=[self getQuciklyOrderNo];
    bjsonArray=@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"SB004":@"1",@"SB002":self.orderNo,@"SB001":PC01,@"OnLineAddressID":@"0001",@"SB016":model.SHOPID}];
    
    NSMutableArray *pjsonArray=[NSMutableArray array];
    NSInteger k=0;
    for (ProductModel *model in self.dataArray)
    {
        k++;
        NSDictionary *dic;
        dic=@{@"SupplierNo":model.SupplierNo,@"SBP004":model.ProductNo,@"SBP009":[NSString stringWithFormat:@"%ld",model.count],@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":[NSString stringWithFormat:@"%ld",k],@"SBP015":model.RetailPrice};
        [pjsonArray addObject:dic];
    }
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:bjsonArray options:kNilOptions error:nil];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:pjsonArray options:kNilOptions error:nil];
    NSString *bjsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSString *pjsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"-%@",bjsonStr);
    NSLog(@"-%@",pjsonStr);
    
    NSDictionary *jsonDic;
    
    jsonDic=@{@"possbJson":bjsonStr,@"possbpJson":pjsonStr,@"CipherText":CIPHERTEXT};
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url=@"B2BService.asmx/B2BCreateBill";
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:url With:jsonDic and:^(id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str containsString:@"true"]) {
            [SVProgressHUD dismiss];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //数据库删除
                for (ProductModel *model in _dataArray) {
                    [[FMDBShopCar shareInstance]deleteTable:model];
                }
                [self pushOrder];
            });
            
        }else
        {
            [self alertShowWithStr:str];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        
        
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
//-(void)B2BOrderInfo2WithStr:(NSString*)str
//{
//    
//    [SVProgressHUD showWithStatus:@"加载中"];
//    NSDictionary *dic=@{@"shopid":self.model.SHOPID,@"mode":@"1",@"pageindex":@"1",@"pagesize":requsetSize};
//
//    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BOrderInfo1" With:dic and:^(id responseObject) {
//        
//        NSDictionary *dic1=[JsonTools getData:responseObject];
//     
//         NSArray *arry=[ADBillModel getDatawithdic:dic1];
//        ADBillModel *model=arry[0];
//        StockPayTypeViewController *stock=[[StockPayTypeViewController alloc]init];
//        stock.title=@"支付";
//        stock.billModel=model;
//        [self.navigationController pushViewController:stock animated:YES];
//     
//    } Faile:^(NSError *error) {
//        
//    }];
//}
-(void)pushOrder
{
    BillStateViewController *bill=[[BillStateViewController alloc]init];
    bill.title=@"我的";
    [self.navigationController pushViewController:bill animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
