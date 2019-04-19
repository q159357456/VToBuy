//
//  STShopCarViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "STShopCarViewController.h"
#import "STShopCarTableViewCell.h"
#import "FMDBShopCar.h"
#import "ProductModel.h"
#import "InputOrderViewController.h"
#import "FMDBShopInfo.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ADShopInfoModel.h"
@interface STShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *allSelButt;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property(nonatomic,strong)NSMutableArray *seletArray;
@property(nonatomic,assign)BOOL edit;
@property(nonatomic,strong)NSMutableArray *deletArray;

@end

@implementation STShopCarViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       [self getData];
    [self.seletArray removeAllObjects];
    self.seletArray=self.seletArray;
    [self.tableView reloadData];
}
-(NSArray *)deletArray
{
    if (!_deletArray) {
        _deletArray=[NSMutableArray array];
    }
    return _deletArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=navigationBarColor;
    self.seletArray=[NSMutableArray array];
    [self addleftButton];
    [self addRightButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)edit:(UIBarButtonItem*)butt
{
    if ([butt.title isEqualToString:@"编辑"])
    {
       
        [butt setTitle:@"完成"];
        self.edit=YES;
        [self.tableView reloadData];
        
        
    }else
    {

         [butt setTitle:@"编辑"];
        self.edit=NO;
        [self.tableView reloadData];
    }
}
-(void)setEdit:(BOOL)edit
{
    _edit=edit;
    if (edit)
    {
        [self.doneButton setTitle:@"删除" forState:UIControlStateNormal];
    }else
    {
        [self.doneButton setTitle:@"去结算" forState:UIControlStateNormal];
    }
}
- (IBAction)allSel:(UIButton *)sender {
    NSArray *productArray=[[FMDBShopCar shareInstance]getShopCarModel];
    if (self.seletArray.count==productArray.count)
    {   [self.seletArray removeAllObjects];
        for (NSInteger i=0;i<_dataArray.count;i++) {
            NSArray *array=_dataArray[i];
            for (ProductModel *model in array) {
                model.selected=NO;
           
                
            }
        }
        self.seletArray=self.seletArray;
        [self.tableView reloadData];
        
    }else
    {   [self.seletArray removeAllObjects];
        for (NSInteger i=0;i<_dataArray.count;i++) {
            NSArray *array=_dataArray[i];
            for (ProductModel *model in array) {
                model.selected=YES;
                [self.seletArray addObject:model];
                
            }
        }
        self.seletArray=self.seletArray;
        [self.tableView reloadData];
        
    }
 

}

-(void)getData
{
    _dataArray=[NSMutableArray array];
    NSArray *array=[[FMDBShopCar shareInstance]getShopCarModel];
    NSArray *array1=[[FMDBShopInfo shareInstance]getShopInfo];
    for (ADShopInfoModel *model in array1) {
        NSMutableArray *pArray=[NSMutableArray array];
        BOOL is=NO;
        for (ProductModel *pmodel in array) {
            if ([pmodel.SupplierNo isEqualToString:model.SHOPID]) {
                is=YES;
                [pArray addObject:pmodel];
            }
            
        }
        if (!is) {
            [[FMDBShopInfo shareInstance]deleteTable:model];
            
        }else
        {
            [_dataArray addObject:pArray];
        }
        
        
    }

}

-(void)setSeletArray:(NSMutableArray *)seletArray
{
    _seletArray=seletArray;
    if (_seletArray.count==0) {
        self.doneButton.enabled=NO;
    }else
    {
        self.doneButton.enabled=YES;
    }
    NSArray *productArray=[[FMDBShopCar shareInstance]getShopCarModel];
    if (seletArray.count==productArray.count)
    {
        [self.allSelButt setBackgroundImage:[UIImage imageNamed:@"slected_2"] forState:UIControlStateNormal];
    }else
    {
            [self.allSelButt setBackgroundImage:[UIImage imageNamed:@"slected_1"] forState:UIControlStateNormal];
    }
}
-(void)addleftButton
{
   
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=right;
    
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *array=[[FMDBShopInfo shareInstance]getShopInfo];
    return array.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array=_dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        return 100;
  
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellid=@"STShopCarTableViewCell";
    ProductModel *model=_dataArray[indexPath.section][indexPath.row];
        STShopCarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"STShopCarTableViewCell" owner:nil options:nil][0];
        }
    if (_edit)
    {
        cell.proCount.hidden=YES;
        [cell setNoHideen];
        cell.minceBlock=^{
                        if (model.count>1)
                        {
                            model.count--;
                            [[FMDBShopCar shareInstance]insertUser:model];
                        }
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        };
        cell.pluseBlock=^{
                        model.count++;
                        [[FMDBShopCar shareInstance]insertUser:model];
                         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        };
        
    }else
    {
        cell.proCount.hidden=NO;
        [cell setHideen];

        
    }
    [cell setDataWithModel:model];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        NSArray *array=[[FMDBShopInfo shareInstance]getShopInfo];
        ADShopInfoModel *model=array[section];
    if (model.ShopName) {
        return [NSString stringWithFormat:@"%@",model.ShopName];
    }else
 
    return @"无名";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      ProductModel *model=_dataArray[indexPath.section][indexPath.row];
    model.selected=!model.selected;
    if (model.selected) {
      
        [self.seletArray addObject:model];
    }else
    {
        if ([self.seletArray containsObject:model]) {
         
            [self.seletArray removeObject:model];
        }
    }
   
    self.seletArray=self.seletArray;
    [self.tableView reloadData];
    
    
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
    if (self.edit)
    {
        //删除选中
        for (ProductModel *model in self.seletArray) {
            [[FMDBShopCar shareInstance]deleteTable:model];
        }
        //
        [self.seletArray removeAllObjects];
        self.seletArray=self.seletArray;

        [self getData];
     
        [self.tableView reloadData];
    }else
    {
        InputOrderViewController *input=[[InputOrderViewController alloc]init];
        input.title=@"提交订单";
        input.dataArray=self.seletArray;
        [self.navigationController pushViewController:input animated:YES];
  
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
