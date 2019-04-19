//
//  OverflowViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/20.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "OverflowViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "ProductModel.h"
#import "ChooseTableViewCell.h"
#import "AddClassifyViewController.h"
#import "ProuctTableViewCell.h"
#import "FlowDetailViewController.h"
@interface OverflowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *searchField;
}
@property(nonatomic,strong) UIView *btnKind;
@property(nonatomic,strong) UILabel *btnLable;
@property(nonatomic,strong)UITableView *proTableView;
@property(nonatomic,retain)ProductModel *productodel;
@property(nonatomic,copy)NSString *classiFyNo;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(strong,nonatomic)UITableView *table;
@end

@implementation OverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[NSMutableArray array];
    [self getButtView];
    [self createUI];
    [self getAllData];
//    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
//    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    // Do any additional setup after loading the view from its nib.
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
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(_btnKind.mas_centerY);
    }];
    [_btnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageview.mas_left);
        make.left.mas_equalTo(_btnKind.mas_left);
        make.centerY.mas_equalTo(_btnKind.mas_centerY);
        make.height.mas_equalTo(_btnKind.mas_height);
        
    }];
    
    
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSString *condition=[NSString stringWithFormat:@"A.SHOPID$=$%@$AND$A.COMPANY$=$%@",model.SHOPID,model.COMPANY];
  
    NSDictionary *dic=@{@"FromTableName":@"INV_MallProduct[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        
        _dataArray=[ProductModel getDataWithDic:dic1];
        
        [_proTableView reloadData];
        
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
    NSDictionary *dic=@{@"FromTableName":@"INV_MallProduct[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        [_dataArray removeAllObjects];
        _dataArray=[ProductModel getDataWithDic:dic1];
        
        [_proTableView reloadData];
        
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
    NSDictionary *dic=@{@"FromTableName":@"INV_MallProduct[A]||inv_classify[B]{left (A.company=B.company and A.shopid=B.shopid and A.classify_2=B.classifyno)}",@"SelectField":@"*",@"Condition":newStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        [_dataArray removeAllObjects];
        _dataArray=[ProductModel getDataWithDic:dic1];
        
        [_proTableView reloadData];
        
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
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, 77, screen_width-40, 45)];
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
    [searchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchField addSubview:searchBtn];
    [self.view addSubview:searchField];
    
    
    
    //创建全部的种类条目
    UIView *kindView = [[UIView alloc] initWithFrame:CGRectMake(0, 134, screen_width, 50)];
    kindView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:173.0f/255.0f blue:251.0f/255.0f alpha:1.0];
    
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
    priceLabel.text = @"是否上架";
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [kindView addSubview:_btnKind];
    [kindView addSubview:nameLabel];
    [kindView addSubview:priceLabel];
    [self.view addSubview:kindView];
    

        [self creatProductTabe];
    
    
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
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
     
     make.bottom.mas_equalTo(self.view.mas_bottom);
      
        
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
        cell.choseView.hidden=YES;
        [cell setDataWithModel:model Type:@"overFlow"];
        return cell;
        
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        FlowDetailViewController *detail=[[FlowDetailViewController alloc]init];
        __weak typeof(self)weakSelf=self;
        detail.backBlock=^{
            [weakSelf getAllData];
        };
        detail.title=@"产品明细";
        detail.model=model;
        [self.navigationController pushViewController:detail animated:YES];
        
        
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
        return 0.01;
    }
    
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
        NSDictionary *jsonDic;
        jsonDic=@{ @"Command":@"Del",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":@"GB01",@"SHOPID":@"CD003",@"CREATOR":@"admin",@"Classify_2":self.productodel.Classify_2,@"ProductName":self.productodel.ProductName,@"UPC_BarCode":@"",@"Unit":self.productodel.Unit,@"IsUpDown":self.productodel.IsUpDown,@"IsWeigh":self.productodel.IsWeigh,@"RetailPrice":self.productodel.RetailPrice,@"ProductDesc":@"详细说明",@"ProductNo":self.productodel.ProductNo}]};
        
        
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
                    
                    [self getAllData];
                    
                    
                });
                
                
                
            }else
            {
                [self alertShowWithStr:@"删除失败"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
