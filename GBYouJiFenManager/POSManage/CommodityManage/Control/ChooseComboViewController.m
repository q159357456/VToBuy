//
//  ChooseComboViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChooseComboViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "GroupModel.h"
#import "ChooseTableViewCell.h"
#import "trreeTableViewCell.h"
@interface ChooseComboViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger count;
}
@property(nonatomic,strong)MemberModel *Dmodel;
@property(nonatomic,strong)NSMutableArray *groupArray;
@property(nonatomic,strong)NSMutableArray *detailArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *chosenArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ChooseComboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=MainColor;
    _groupArray=[NSMutableArray array];
    _detailArray=[NSMutableArray array];
    _dataArray=[NSMutableArray array];
    _chosenArray=[NSMutableArray array];
      [self getGroupData];
    // Do any additional setup after loading the view from its nib.
}
//群组
-(void)getGroupData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *Dmodel=[[FMDBMember shareInstance]getMemberData][0];
//    NSLog(@"%@",self.model.ProductNo);
    NSString *condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$Hproductno$=$%@",Dmodel.COMPANY,Dmodel.SHOPID,_productNo];
   
    NSDictionary *dic=@{@"FromTableName":@"BOM_GProduct",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT} ;

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        _groupArray=[GroupModel getDataWithDic:dic1];
        NSLog(@"%ld",_groupArray.count);
        [self getDetailData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
//明细
-(void)getDetailData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];

    NSString *condition=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$A.Hproductno$=$%@",model.COMPANY,model.SHOPID,_productNo];
    NSDictionary *dic=@{@"FromTableName":@"Bom_DetailProduct[A]||inv_product[B]{ left (A.company=B.company and A.shopid=B.shopid and A.DProductNo=B.ProductNo)} ||BOM_GProduct[C]{left (A.company=C.company and a.shopid=C.shopid and  A.HProductNo=C.HProductNo and  A.Te_Gp=C.GP_No )}",@"SelectField":@"A.*,B.ProductName,B.ProductNo,C.BasicQuantity,C.GP_Name",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        _detailArray=[ProductModel getDataWithDic:dic1];
    
        [self getAllData];
        

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getAllData
{
    
    for (GroupModel *gmodel in _groupArray)
    {

        [_dataArray addObject:gmodel];
     
        for (ProductModel *model in _detailArray)
        {
            if ([model.Te_Gp isEqualToString:gmodel.GP_No] )
            {

                [_dataArray addObject:model];
            }
            
        }
    }
    //没有群组的情况
    for (ProductModel *model in _detailArray)
    {
        if ([model.Te_Gp isEqualToString:@"0"]) {
            [_chosenArray addObject:model];
            [_dataArray insertObject:model atIndex:0];
        }
        
    }
    [self.tableview reloadData];
   
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataArray[indexPath.row] isKindOfClass:[GroupModel class]])
    {
        GroupModel *model=_dataArray[indexPath.row];
      
            static NSString *cellid=@"ChooseTableViewCell";
        
            ChooseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
            }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        cell.contentLable.textAlignment=NSTextAlignmentLeft;
        cell.left.constant=8;
        cell.contentLable.text=[NSString stringWithFormat:@"%@(可选%@种)",model.GP_Name,model.BasicQuantity];
        
        return cell;

        
    }else
    {
        static NSString *cellid=@"trreeTableViewCell";
        ProductModel *model=_dataArray[indexPath.row];
//        NSLog(@"%@",model.BasicQuantity1);
        trreeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"trreeTableViewCell" owner:nil options:nil][0];
        }
       
        cell.namelable.text=model.ProductName;
        cell.selectedButton.userInteractionEnabled=NO;
        cell.selectedBlock=^{
            
        };
        if ([model.Te_Gp isEqualToString:@"0"]) {
            model.selected=YES;
        }
        if (model.selected)
        {
            [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"slected_2"] forState:UIControlStateNormal];
         
        }
        else
        {
            [cell.selectedButton setBackgroundImage:[UIImage imageNamed:@"slected_1"] forState:UIControlStateNormal];
        }
        return cell;

        
    }

    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataArray[indexPath.row] isKindOfClass:[GroupModel class]])
    {
        return 30;
    }else
    {
        return 50;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 0.001;
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
    if ([_dataArray[indexPath.row] isKindOfClass:[GroupModel class]])
    {
        
    }else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
       ProductModel *model=_dataArray[indexPath.row];
        if (!model.Te_Gp.length)
        {
            return;
        }else
        {
            
            if ([_chosenArray containsObject:model])
            {
                model.selected=NO;
                [_chosenArray removeObject:model];
                [self.tableview reloadData];
                
            }else
            {
                count=0;
                for (ProductModel *pmodel in _chosenArray) {
                    if ([pmodel.Te_Gp isEqualToString:model.Te_Gp])
                    {
                        count++;
                    }
                }
                if (count>=model.BasicQuantity1.intValue)
                {
                   
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:@"不能再选"];
                }else
                {
                    model.selected=YES;
                    [_chosenArray addObject:model];
                    [self.tableview reloadData];
                }
                
                
            }
            
            
        }
        
    }
    
    
}
- (IBAction)done:(UIButton *)sender
{
    NSInteger s=0;
    for (GroupModel *model in _groupArray) {
        s=s+model.BasicQuantity.integerValue;
    }
    for (ProductModel *model in _detailArray) {
        if (!model.Te_Gp.length) {
            s++;
        }
    }
    if (_chosenArray.count>=s)
    {
        self.backBlock(_chosenArray);
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self alertShowWithStr:@"不够套餐件数"];
    }
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
