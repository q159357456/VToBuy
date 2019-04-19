//
//  CommodityBtnViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/2.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "CommodityBtnViewController.h"
#import "TableChangeCollectionViewCell.h"
#import "AddProductViewController.h"
#import "ChooseTableViewCell.h"
#import "ProuctTableViewCell.h"
#import "AddClassifyViewController.h"
#import "ClassifyModel.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface CommodityBtnViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *searchField;
}
@property(nonatomic,strong) UIView *btnKind;
@property(nonatomic,strong) UILabel *btnLable;
@property(nonatomic,strong)UITableView *proTableView;
@property(nonatomic,retain)ProductModel *productodel;
@property(nonatomic,copy)NSString *classiFyNo;
@property(nonatomic,strong)NSMutableArray *chooseArray;
@property(nonatomic,strong)PlaceholderView *placeView;


@end

@implementation CommodityBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    _chooseArray=[NSMutableArray array];
    [self getButtView];
    [self createUI];
    [self getAllData];
    if ([self.funType isEqualToString:@"manager"])
    {
        
    
    }else
    {
        [self addRightButton];
    }
    

}
-(void)setCombArray:(NSMutableArray *)combArray
{
    _combArray=combArray;
    [_combArray removeLastObject];
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.proTableView.frame;
    }
    return _placeView;
}
-(void)getButtView
{
    self.btnKind=[[UIView alloc]init];
    _btnLable=[[UILabel alloc]init];
    [self.btnKind addSubview:_btnLable];
    UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sj"]];
    [self.btnKind addSubview:imageview];

    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_btnKind.mas_right);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(_btnKind.mas_centerY);
    }];
    [_btnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageview.mas_left);
        make.left.mas_equalTo(_btnKind.mas_left);
         make.centerY.mas_equalTo(_btnKind.mas_centerY);
        make.height.mas_equalTo(_btnKind.mas_height);
        
    }];
    
   
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)commit
{
    if ([_funType isEqualToString:@"KanJia"])
    {
        self.KanJiaBlock(self.productodel);
        
    }else
    {
            self.backBlock(self.chooseArray);
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@$AND$A.Property$=$P",model.SHOPID,model.COMPANY];
    NSDictionary *dic=@{@"FromTableName":@"inv_product[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        
        _dataArray=[ProductModel getDataWithDic:dic1];
       

        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.proTableView reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
        
       
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
 
    
}
-(void)getDataWithStr:(NSString *)str
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@$AND$A.Classify_2$=$%@",model.SHOPID,model.COMPANY,str];
    NSDictionary *dic=@{@"FromTableName":@"inv_product[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
      
        [_dataArray removeAllObjects];
        _dataArray=[ProductModel getDataWithDic:dic1];
     
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.proTableView reloadData];

            [self.proTableView reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
//搜索
-(void)getSearchDataWithStr:(NSString *)str
{
    NSInteger lengh=str.length;
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *oldStr=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@$AND$A.ProductName$LIKE$%@",model.SHOPID,model.COMPANY,str];
    NSMutableString *newStr=[NSMutableString stringWithString:oldStr];
  
    [newStr insertString:@"%" atIndex:newStr.length];
    [newStr insertString:@"%" atIndex:newStr.length-lengh-1];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"inv_product[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":newStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        [_dataArray removeAllObjects];
        _dataArray=[ProductModel getDataWithDic:dic1];
        
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.proTableView reloadData];

            [self.proTableView reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
#pragma mark--textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self getSearchDataWithStr:textField.text];
//
    [searchField resignFirstResponder];
    return YES;
}
-(void)createUI
{
    //创建搜索栏
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 77-64, screen_width-40, 45)];
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
;
    [searchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchField addSubview:searchBtn];
    [self.view addSubview:searchField];
    
    
    
    //创建全部的种类条目
    UIView *kindView = [[UIView alloc] initWithFrame:CGRectMake(0, 134-64, screen_width, 50)];
    kindView.backgroundColor = navigationBarColor;
    
    //全部 的标题栏
     _btnKind.frame=CGRectMake(15, 0, 100, 50);
     _btnLable.text=@"全部";
    _btnLable.textAlignment=NSTextAlignmentCenter;
    _btnLable.textColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnKindClick)];
    [_btnKind addGestureRecognizer:tap];

    
    //名称  的标题栏
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-80)/2, 0, 80, 50)];
    nameLabel.text = @"名称";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //普通价  的标题栏
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width-110, 0, 80, 50)];
    priceLabel.text = @"普通价";
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [kindView addSubview:_btnKind];
    [kindView addSubview:nameLabel];
    [kindView addSubview:priceLabel];
    [self.view addSubview:kindView];

    if ([self.funType isEqualToString:@"manager"]) {
        
        [self createFootUI];
    }else
    {
        [self creatProductTabe];
    }
    
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)createFootUI
{

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60-64, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    NSArray *nameArray=@[@"编辑",@"删除",@"新增"];
    NSArray *imageArray=@[@"edit",@"delete",@"add"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/3*i,screen_height-59-64,screen_width/3-1, 59);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/3*i-1,screen_height-50-64, 1, 40)];
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
    [self creatProductTabe];
    
}
-(void)touch:(UIButton*)butt
{
    if (butt.tag==1)
    {
        //编辑
        if (self.productodel)
        {
            AddProductViewController *add=[[AddProductViewController alloc]init];
            add.funType=@"Edit";
            add.productModel=self.productodel;
            add.title=@"编辑商品";
            add.backBlock=^{
                [self getAllData];
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中商品"];
        }
        
        
        
    }else if (butt.tag==2)
    {
        NSLog(@"删除");
        
        
         [self alertShowWithString:@"是否确认删除？"];
        
    }else
    {
        NSLog(@"新增");
        
        //新增
        AddProductViewController *add=[[AddProductViewController alloc]init];
        add.funType=@"Add";
        add.title=@"增加商品";
        add.backBlock=^{
            [self getAllData];
        };
        [self.navigationController pushViewController:add animated:YES];    }
}
-(void)alertShowWithString:(NSString *)string
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletproduct];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)creatProductTabe
{
    _proTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    _proTableView.delegate = self;
    _proTableView.dataSource = self;
    [self.view addSubview:_proTableView];
    [_proTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnKind.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        if ([self.funType isEqualToString:@"manager"]) {
            
           make.bottom.mas_equalTo(self.view.mas_bottom).offset(-60);
        }else
        {
           make.bottom.mas_equalTo(self.view.mas_bottom);
        }
        
        
    }];

    
}

-(void)createTableUI
{
    _table = [[UITableView alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
     [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnKind.mas_bottom).offset(-10);
        make.left.mas_equalTo(_btnKind.mas_left);
        make.right.mas_equalTo(_btnKind.mas_right);
        make.height.mas_equalTo(2*44);
        
    }];
    _table.layer.borderWidth=1;
    _table.layer.borderColor=[UIColor lightGrayColor].CGColor;
    

    
   
}


//搜索按钮响应
-(void)SearchBtnClick
{
    NSLog(@"开始搜索。。。");
}

//全部种类按钮响应
-(void)btnKindClick
{
    if (_table )
    {
        _table.hidden=!_table.hidden;
    }else
    {
        [self createTableUI];
    }
}


#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_table)
    {
         return 2;
    }else
    {
         return _dataArray.count;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_table)
    {
        NSArray *titleArray=@[@"全部",@"其它"];
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.contentLable.text=titleArray[indexPath.row];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        ProductModel *model=_dataArray[indexPath.row];
       static NSString *cellid=@"ProuctTableViewCell";
        ProuctTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ProuctTableViewCell" owner:nil options:nil][0];
            
        }
        if (model.selected)
        {
            cell.choseView.backgroundColor=navigationBarColor;
            
        }else
        {
             cell.choseView.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel:model Type:@"product"];
        return cell;
    
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_table)
    {
        NSArray *titleArray=@[@"全部",@"其它"];
        _table.hidden=YES;
        
        if (indexPath.row==0)
        {
            [self getAllData];
            self.btnLable.text=titleArray[indexPath.row];
            
        }else
        {
            AddClassifyViewController *add=[[AddClassifyViewController alloc]init];
            add.title=@"选择大类";
            __weak typeof(self)weakSelf=self;
            add.backBlock=^(ClassifyModel *model){
                weakSelf.btnLable.text=model.classifyName;
                [weakSelf getDataWithStr:model.classifyNo];
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        
    }else
    {
        ProductModel *model=_dataArray[indexPath.row];
         if ([self.funType isEqualToString:@"manager"]||[self.funType isEqualToString:@"KanJia"])
         {
             //单选
             for (ProductModel *smodel in _dataArray)
             {
                 if (smodel.ProductNo==model.ProductNo)
                 {
                     smodel.selected=!smodel.selected;
                     //
                     if (smodel.selected==YES)
                     {
                         self.productodel=smodel;
                     }else
                     {
                         self.productodel=nil;
                     }
                     
                 }else
                 {
                     smodel.selected=NO;
                 }
             }

             
             
         }else
         {
             //套餐多选
             //先看子件中是否存在，存在则不能再选
             
             BOOL isChild = NO;
             if (_combArray.count) {
                 for (ProductModel *Cmodel in _combArray) {
                     if ([Cmodel.ProductNo isEqualToString:model.ProductNo]) {
                         [SVProgressHUD setMinimumDismissTimeInterval:0.8];
                         [SVProgressHUD showErrorWithStatus:@"子件中已经存在"];
                         [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                         isChild=YES;
                         break;
                     }
                 }

             }
             
             //再看是否套餐商品
             if ([model.Property isEqualToString:@"C"]) {
                 [SVProgressHUD setMinimumDismissTimeInterval:0.8];
                 [SVProgressHUD showErrorWithStatus:@"不能选套餐商品"];
                 [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
                 isChild=YES;
             }
             if (isChild)
             {
                 return;
             }else
             {
                 for (ProductModel *smodel in _dataArray)
                 {
                     if (smodel.ProductNo==model.ProductNo)
                     {
                         smodel.selected=!smodel.selected;
                         
                         if (smodel.selected==YES)
                         {
                             smodel.Dosage=@"1";
                             [_chooseArray addObject:smodel];
                             
                         }else
                         {
                             if ([_chooseArray containsObject:smodel]) {
                                 [_chooseArray removeObject:smodel];
                             }
                             
                         }
                         
                     }
                 }
                 
                 
             }

             
         }
   
        [self.proTableView reloadData];
      
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_table)
    {
        return 0;
    }else
    {
         return 0.01;
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==_table)
    {
        return 0;
    }else
    {
        return 10;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)deletproduct
{
    
    

    if (!self.productodel)
    {
        [self alertShowWithStr:@"先选中要删除的类别"];
        
    }else
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"加载中"];
        MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
        NSDictionary *jsonDic;
         jsonDic=@{ @"Command":@"Del",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productodel.Classify_2,@"ProductName":self.productodel.ProductName,@"UPC_BarCode":@"",@"Unit":self.productodel.Unit,@"IsUpDown":self.productodel.IsUpDown,@"IsWeigh":self.productodel.IsWeigh,@"RetailPrice":self.productodel.RetailPrice,@"ProductDesc":@"详细说明",@"ProductNo":self.productodel.ProductNo}]};
        
        
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
           
            
            NSString *str=[JsonTools getNSString:responseObject];
            
            if ([str isEqualToString:@"OK"])
            {
                //删除成功
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    [SVProgressHUD dismiss];
                    self.productodel=nil;
                    [self getAllData];
                });
            }else
            {
                [SVProgressHUD dismiss];
                [self alertShowWithStr:str];
            }
            
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
