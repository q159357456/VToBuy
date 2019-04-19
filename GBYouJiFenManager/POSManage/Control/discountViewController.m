
//  discountViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "discountViewController.h"
#import "discountTableViewCell.h"
#import "discountOperationViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface discountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end

@implementation discountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _disTypeArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    [self createBtn];
    
    [self initTable];
    
    [self getWebServicesData];
    
    [self getDisTypeData];
}

-(void)getDisTypeData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"CMS_BaseVar",@"SelectField":@"*",@"Condition":@"ModuleNo$=$POS$AND$VarField$=$p_discount",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
     _disTypeArray=[discountClassifyModel getDataWithDic:dic1];
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getWebServicesData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSDS",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataArray = [discountModel getDataWithDic:dic1];
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)createUI
{
    NSArray *arr = @[@"折扣名称",@"折扣类型",@"指定折扣",@"输入折扣",@"折让金额"];
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 40)];
    for (int i=0; i<5; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30+i*(screen_width-30)/5, 0, (screen_width-30)/5, 39)];
        lab.tag = 400 + i;
        lab.text = arr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        [_headView addSubview:lab];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, screen_width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_headView addSubview:line];
    
    [self.view addSubview: _headView];
}

-(void)createBtn
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60, screen_width, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    NSArray *nameArray=@[@"编辑",@"删除",@"新增"];
    NSArray *imageArray=@[@"edit",@"delete",@"add"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/3*i,screen_height-59,screen_width/3-1, 59);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/3*i-1,screen_height-50, 1, 40)];
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

-(void)touch:(UIButton *)btn
{
    //编辑
    if (btn.tag == 1) {
        [self editBtnClick];
    }
    //删除
    if (btn.tag == 2) {
        [self delBtnClick];
    }
    if (btn.tag == 3) {
        [self addBtnClick];
    }
}

-(void)initTable
{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, screen_height-164) style:UITableViewStylePlain];
    
    _table.delegate = self;
    
    _table.dataSource = self;
    
    _table.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    
    [_table registerNib:[UINib nibWithNibName:@"discountTableViewCell" bundle:nil] forCellReuseIdentifier:@"discountTableViewCell"];
    
    [self.view addSubview:_table];
}

-(void)editBtnClick
{
    if (self.dModel) {
    discountOperationViewController *DOVC = [[discountOperationViewController alloc] initWithNibName:@"discountOperationViewController" bundle:nil];
    DOVC.chooseType = @"Edit";
    DOVC.navigationItem.title = @"编辑";
    DOVC.disModel = self.dModel;

        for (discountClassifyModel *smodel in _disTypeArray) {
            if ([smodel.VarValue isEqualToString:self.dModel.discountType]) {
               DOVC.discountName  = smodel.VarDisPlay;
            }
        }


    DOVC.backBlock = ^{
        [self getWebServicesData];
    };
    DOVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DOVC animated:YES];
    }else
    {
        [self alertShowWithStr:@"请选中需修改的条目"];
    }
}
//当你的才华还撑不起你的野心时,那就静下心来学习。
-(void)delBtnClick
{
    [self deleteItem];
}

-(void)addBtnClick
{
    discountOperationViewController *DOVC = [[discountOperationViewController alloc] initWithNibName:@"discountOperationViewController" bundle:nil];
    DOVC.chooseType = @"Add";
    DOVC.navigationItem.title = @"新增";
    DOVC.backBlock = ^{
        [self getWebServicesData];
    };
    DOVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DOVC animated:YES];
}
//实现协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"discountTableViewCell";
    discountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"discountTableViewCell" owner:nil options:nil][0];
    }
    discountModel *model = _dataArray[indexPath.row];
    if (model.selected) {
        cell.selectLab.backgroundColor = [UIColor greenColor];
    }else
    {
        cell.selectLab.backgroundColor = [UIColor whiteColor];
    }
    //[cell setDataWithModel:model];
    for (discountClassifyModel *smodel in _disTypeArray) {
        if ([smodel.VarValue isEqualToString:model.discountType]) {
            cell.lab2.text = smodel.VarDisPlay;
        }
    }
    cell.lab1.text = model.discountName;
    cell.lab3.text = model.appointDiscount;
    cell.lab4.text = model.printDiscount;
    cell.lab5.text = model.discountMoney;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    discountModel *model = _dataArray[indexPath.row];
    for (discountModel *smodel in _dataArray) {
        if (smodel.itemNo == model.itemNo) {
            smodel.selected = !smodel.selected;
            if (smodel.selected == YES) {
                self.dModel = smodel;
            }else{
                self.dModel = nil;
            }
        }else
        {
            smodel.selected = NO;
        }
    }
    
    [self.table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(void)deleteItem
{
    if (!self.dModel) {
        [self alertShowWithStr:@"请选择需删除的条目"];
    }else
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"玩儿命加载中"];
        NSDictionary *jsonDic;
        jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DS002":self.dModel.discountName,@"DS003":self.dModel.discountType,@"DS004":self.dModel.appointDiscount,@"DS005":self.dModel.printDiscount,@"DS006":self.dModel.discountMoney,@"DS001":self.dModel.itemNo}]};
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
                    
                    [self getWebServicesData];
                    
                    
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

-(void)alertShowWithStr:(NSString *)str
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
