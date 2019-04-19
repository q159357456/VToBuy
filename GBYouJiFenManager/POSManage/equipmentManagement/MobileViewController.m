//
//  MobileViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/5.
//  Copyright © 2017年 xia. All rights reserved.

#import "MobileViewController.h"
#import "TableChangeCollectionViewCell.h"
#import "MobileSecondTableViewCell.h"
#import "InternalRegisterViewController.h"
#import "CheckInfoViewController.h"
#import "ShedualInfoViewController.h"
#import "TasteKindViewController.h"
#import "TasteRequestViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "electronicScaleViewController.h"
@interface MobileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;

@end

@implementation MobileViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initArray];
    [self initTable];
    [self initOperationBtn];
    
    [self getAllData];
    
    [self getTasteClassData];
    
    [self getTasteBigClassData];
    
    [self getAreaData];
    
    [self getMenuData];
    
    [self getRoleRightData];
    
    
    
    
}


-(void)getRoleRightData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_RoleRight",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        
        
        _roleRightArr = [MenuFunctionModel getDataWithDic:dic1];
        
        } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getMenuData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_Menu",@"SelectField":@"*",@"Condition":@"ParentPnoNo$=$QT",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        
        
        _menuAllArr = [MenuFunctionModel getDataWithDic:dic1];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}


-(void)getAreaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        self.areaArray = [FloorModel getDataWithDic:dic1];
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}


-(void)getTasteBigClassData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"Inv_classify",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _tasteBigClassArray = [TasteClassifyModel getDataWithDic:dic1];
        
        [_table reloadData];
        
    } Faile:^(NSError *error){
        NSLog(@"失败%@",error);
    }];

}

-(void)initArray
{
    _dataArray = [NSMutableArray array];
    
    _tasteClassArray = [NSMutableArray array];
    
    _tasteBigClassArray = [NSMutableArray array];
    
    self.areaArray = [NSMutableArray array];
    
    _tasteRequestArray = [NSMutableArray array];
    
    _RoleRightArr = [NSMutableArray array];
    
    _menuAllArr = [NSMutableArray array];
    
    _roleRightArr = [NSMutableArray array];
    
    
    _titleArray = @[@"设备SN",@"PC的MAC",@"大类列表",@"口味分类",@"开始时间",@"角色",@"IP地址"];
    _titleArray1 = @[@"设备名称",@"PC名称",@"分类名称",@"口味名称",@"终止时间",@"角色名称",@"启用否"];

}

-(void)getTasteClassData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSDC",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _tasteClassArray=[TasteKindModel getDataWithDic:dic1];
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    if (_tagNum == 100) {
        dic=@{@"FromTableName":@"POSDV",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 101) {
        dic=@{@"FromTableName":@"POSDN",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 105) {
        dic=@{@"FromTableName":@"POSDC",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 106) {
        dic=@{@"FromTableName":@"POSDI",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 109) {
        dic=@{@"FromTableName":@"POSSTT",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 113) {
        dic=@{@"FromTableName":@"POS_ScaleMachine",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 130){
        
        dic = @{@"FromTableName":@"CMS_Role",@"Condition":_conitionStr,@"SelectField":@"*",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        if (_tagNum == 100) {
             _dataArray=[InternalRegisterModel getDataWithDic:dic1];
        }
        if (_tagNum == 101) {
             _dataArray=[PCRegisyerModel getDataWithDic:dic1];
        }
        if (_tagNum == 105) {
            _dataArray = [TasteKindModel getDataWithDic:dic1];
        }
        if (_tagNum == 106) {
            _dataArray = [TasteRequestModel getDataWith:dic1];
        }
        if (_tagNum == 109) {
            _dataArray=[scheduleModel getDataWithDic:dic1];
        }
        if (_tagNum == 113) {
            _dataArray=[ScaleModel getDataWith:dic1];
        }
        if (_tagNum == 130) {
            _dataArray=[RolePemissionModel getDataWithDic:dic1];
        }
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initOperationBtn
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-60-(ZWHNavHeight), screen_width, 60)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    NSArray *nameArray=@[@"编辑",@"删除",@"新增"];
    NSArray *imageArray=@[@"edit",@"delete",@"add"];
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(screen_width/3*i,screen_height-59,screen_width/3-1, 59);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.backgroundColor=[UIColor whiteColor];
        
        button.tag=i+1;
        button.enabled=YES;
       
        [button addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        CGFloat wid = (SCREEN_WIDTH)/3;
        CGFloat hig = 59;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view);
            make.left.equalTo(view).offset(wid*i);
            make.height.mas_equalTo(hig);
            make.width.mas_equalTo(wid);
        }];
        if (i<2) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/3*i-1,screen_height-50,1, 40)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [button addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.equalTo(button);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(40);
            }];
        }
        
        
    }

    
}

-(void)touchClick:(UIButton *)btn
{
    NSLog(@"------------点击");
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

-(void)editBtnClick
{
    if (_tagNum == 101) {
        if (self.PCModel) {
            
        CheckInfoViewController *CIVC = [[CheckInfoViewController alloc] initWithNibName:@"CheckInfoViewController" bundle:nil];
        CIVC.chooseType = @"Edit";
        CIVC.navigationItem.title = @"编辑";
        CIVC.PCModel = self.PCModel;
            for (FloorModel *model in self.areaArray) {
            if ([self.PCModel.PCArea isEqualToString:model.itemNo]) {
                  CIVC.floorItnoString = model.FloorInfo;
                    }
        }
        CIVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:CIVC animated:YES];
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    if (_tagNum == 105) {
        if (self.tasteModel) {
            
            TasteKindViewController *TKVC = [[TasteKindViewController alloc] initWithNibName:@"TasteKindViewController" bundle:nil];
            TKVC.chooseType = @"Edit";
            TKVC.navigationItem.title = @"编辑";
            TKVC.TasteKindModel = self.tasteModel;
            
            NSString *str = self.tasteModel.classifyList;
            NSArray *arr = [str componentsSeparatedByString:@";"];
            NSMutableArray *array1 = [NSMutableArray array];
            for (NSString *str1 in arr) {
                for (TasteClassifyModel *model1 in _tasteBigClassArray) {
                    if ([str1 isEqualToString:model1.classifyNo]) {
                        
                        NSString *str2 = [NSString stringWithFormat:@"%@;",model1.classifyName];
                        
                        [array1 addObject:str2];
                    }
                }
            }
            NSString *string = [array1 componentsJoinedByString:@""];
            TKVC.tasteClassStr = string;
            TKVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:TKVC animated:YES];
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    
    if (_tagNum == 106) {
        if (self.TRModel){

            TasteRequestViewController *TRVC = [[TasteRequestViewController alloc] initWithNibName:@"TasteRequestViewController" bundle:nil];
            TRVC.chooseType = @"Edit";
            TRVC.navigationItem.title = @"编辑";
            TRVC.TRequestModel = self.TRModel;

            for (TasteKindModel *model1 in _tasteClassArray) {
                if ([self.TRModel.tasteClasses isEqualToString:model1.itemNo]) {
                   TRVC.tasteClassStr  = model1.classifyName;
                }
            }
            
            TRVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:TRVC animated:YES];
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
        
    }
    
    if (_tagNum == 109) {
        if (self.scheduModel) {
            
            ShedualInfoViewController *SIVC = [[ShedualInfoViewController alloc] initWithNibName:@"ShedualInfoViewController" bundle:nil];
            SIVC.chooseType = @"Edit";
            SIVC.navigationItem.title = @"编辑";
            SIVC.scheduModel = self.scheduModel;
            SIVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:SIVC animated:YES];
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    
    
    if (_tagNum == 113) {
        if (self.scaleModel) {
            
            electronicScaleViewController *SIVC = [[electronicScaleViewController alloc] initWithNibName:@"electronicScaleViewController" bundle:nil];
            SIVC.chooseType = @"Edit";
            SIVC.navigationItem.title = @"编辑";
            SIVC.SModel = self.scaleModel;
            SIVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:SIVC animated:YES];
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }

    
    
    
    
    if (_tagNum == 130) {
        if (self.roleModel) {
            
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }

    
    
    
}



-(void)delBtnClick
{
    NSLog(@"点击删除");
    
    [self deleteItem];
    
}

-(void)addBtnClick
{
    NSLog(@"点击新增");
    if (_tagNum==100) {
        InternalRegisterViewController *IRVC = [[InternalRegisterViewController alloc] initWithNibName:@"InternalRegisterViewController" bundle:nil];
        IRVC.chooseType = @"Add";
        IRVC.navigationItem.title = @"新增";
        IRVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:IRVC animated:YES];

    }
    if (_tagNum == 101) {
        CheckInfoViewController *CIVC = [[CheckInfoViewController alloc] initWithNibName:@"CheckInfoViewController" bundle:nil];
        CIVC.chooseType = @"Add";
        CIVC.navigationItem.title = @"新增";
        CIVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:CIVC animated:YES];
    }
    if (_tagNum == 105) {
        TasteKindViewController *TKVC = [[TasteKindViewController alloc] initWithNibName:@"TasteKindViewController" bundle:nil];
        TKVC.chooseType = @"Add";
        TKVC.navigationItem.title = @"新增";
        TKVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:TKVC animated:YES];
    }
    
    
    if (_tagNum == 106) {
        TasteRequestViewController *TRVC = [[TasteRequestViewController alloc] initWithNibName:@"TasteRequestViewController" bundle:nil];
        TRVC.chooseType = @"Add";
        TRVC.navigationItem.title = @"新增";
        TRVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:TRVC animated:YES];
    }


    if (_tagNum == 109) {
        ShedualInfoViewController *CIVC = [[ShedualInfoViewController alloc] initWithNibName:@"ShedualInfoViewController" bundle:nil];
        CIVC.chooseType = @"Add";
        CIVC.navigationItem.title = @"新增";
        CIVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:CIVC animated:YES];
    }
    
    if (_tagNum == 113) {
        electronicScaleViewController *CIVC = [[electronicScaleViewController alloc] initWithNibName:@"electronicScaleViewController" bundle:nil];
        CIVC.chooseType = @"Add";
        CIVC.navigationItem.title = @"新增";
        CIVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:CIVC animated:YES];
    }

    
    
    if (_tagNum == 130) {

    }

    

}

-(void)initTable
{
    switch (_tagNum) {
        case 100:
        case 101:
        case 105:
        case 106:
        case 109:
        case 113:
        case 130:
            [self header];
            break;
        
        default:
            break;
    }
    
}

-(void)header
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (screen_width-30)/2, 39)];
    switch (_tagNum) {
        case 100:
            label1.text = _titleArray[0];
            break;
        case 101:
            label1.text = _titleArray[1];
            break;
        case 105:
            label1.text = _titleArray[2];
            break;
        case 106:
            label1.text = _titleArray[3];
            break;
        case 109:
            label1.text = _titleArray[4];
            break;
        case 130:
            label1.text = _titleArray[5];
            break;
        case 113:
            label1.text = _titleArray[6];
            break;

        default:
            break;
    }
    
    label1.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30+(screen_width-30)/2, 0, (screen_width-30)/2, 39)];
    switch (_tagNum) {
        case 100:
            label2.text = _titleArray1[0];
            break;
        case 101:
            label2.text = _titleArray1[1];
            break;
        case 105:
            label2.text = _titleArray1[2];
            break;
        case 106:
            label2.text = _titleArray1[3];
            break;
        case 109:
            label2.text = _titleArray1[4];
            break;
        case 130:
            label2.text = _titleArray1[5];
            break;
        case 113:
            label2.text = _titleArray1[6];
            break;

        default:
            break;
    }

    label2.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:label2];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, screen_width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headView addSubview:line];
    
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    //_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+64, screen_width, screen_height-60-40-64) style:UITableViewStylePlain];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-60-40-64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    _table.backgroundColor = [UIColor whiteColor];
    
    [_table registerNib:[UINib nibWithNibName:@"MobileSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MobileSecondTableViewCell"];
    if ([_table respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _table.estimatedRowHeight = 0;
            _table.estimatedSectionHeaderHeight = 0;
            _table.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view).offset(-60);
    }];


}

//实现协议部分
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid=@"MobileSecondTableViewCell";
    MobileSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"MobileSecondTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_tagNum==101) {
        PCRegisyerModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel1:model];
    }else if (_tagNum==105) {
        TasteKindModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        //[cell setDataWithModel2:model];
        
        NSString *str = model.classifyList;
        NSArray *arr = [str componentsSeparatedByString:@";"];
        NSMutableArray *array1 = [NSMutableArray array];
        for (NSString *str1 in arr) {
            for (TasteClassifyModel *model1 in _tasteBigClassArray) {
                if ([str1 isEqualToString:model1.classifyNo]) {
                    
                    NSString *str2 = [NSString stringWithFormat:@"%@;",model1.classifyName];
                    
                    [array1 addObject:str2];
                }
            }
        }
        NSString *string = [array1 componentsJoinedByString:@""];
        cell.name.text = string;
        //self.name.text = model.classifyList;
        cell.number.text = model.classifyName;
        
        
        
    }else if (_tagNum==106) {
        TasteRequestModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        //[cell setDataWithModel3:model];
        cell.number.text = model.tasteName;
        for (TasteKindModel *model1 in _tasteClassArray) {
            if ([model.tasteClasses isEqualToString:model1.itemNo]) {
                cell.name.text = model1.classifyName;
            }
        }
    }
    
    else if (_tagNum==109) {
        scheduleModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel4:model];
    }
    
    else if (_tagNum==113) {
        ScaleModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel6:model];
    }
    
    else if (_tagNum==130) {
        RolePemissionModel *model=_dataArray[indexPath.row];
        
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel5:model];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (_tagNum == 101) {
        PCRegisyerModel *model=_dataArray[indexPath.row];
        
        for (PCRegisyerModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.PCModel=smodel;
                }else
                {
                    self.PCModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }
    if (_tagNum == 105) {
        TasteKindModel *model=_dataArray[indexPath.row];
        
        for (TasteKindModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.tasteModel=smodel;
                }else
                {
                    self.tasteModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }

    if (_tagNum == 106) {
        TasteRequestModel *model=_dataArray[indexPath.row];
        
        for (TasteRequestModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.TRModel=smodel;
                }else
                {
                    self.TRModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }

    
    if (_tagNum == 109) {
        scheduleModel *model=_dataArray[indexPath.row];
        
        for (scheduleModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.scheduModel=smodel;
                }else
                {
                    self.scheduModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }
    
    
    if (_tagNum == 113) {
        ScaleModel *model=_dataArray[indexPath.row];
        
        for (ScaleModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.scaleModel=smodel;
                }else
                {
                    self.scaleModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }
    
    
    if (_tagNum == 130) {
        RolePemissionModel *model=_dataArray[indexPath.row];
        
        for (RolePemissionModel *smodel in _dataArray) {
            if (smodel.RoleNo==model.RoleNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.roleModel=smodel;
                }else
                {
                    self.roleModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }

      [self.table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNum==101) {
        return 60.0f;
    }
    return 40.0f;
}
//
-(void)deleteItem
{
    if (_tagNum == 101) {
        if (!self.PCModel)
        {
            [self alertShowWithStr:@"请选中要删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDN",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DN002":self.PCModel.PCName,@"DN004":self.PCModel.PCMAC,@"DN004":self.PCModel.PCArea,@"DN001":self.PCModel.itemNo}]};
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
    
    if (_tagNum == 105) {
        if (!self.tasteModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDC",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DC002":self.tasteModel.classifyName,@"DC003":self.tasteModel.classifyList,@"DC001":self.tasteModel.itemNo}]};
            
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

    if (_tagNum == 106) {
        if (!self.TRModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DI002":self.TRModel.tasteName,@"DI003":self.TRModel.tasteClasses,@"DI001":self.TRModel.itemNo}]};
            
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

    
    
    if (_tagNum == 109) {
        if (!self.scheduModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSSTT",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":self.scheduModel.beginTime,@"STT003":self.scheduModel.endTime,@"STT001":self.scheduModel.itemNo}]};
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
    
    
    
    if (_tagNum == 113) {
        if (!self.scaleModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POS_ScaleMachine",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ID":self.scaleModel.itemNo,@"IP":self.scaleModel.IPAddress,@"Status":self.scaleModel.StartUsing}]};
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

    
    
    
    if (_tagNum == 130) {
        if (!self.roleModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            
            NSMutableArray *MArr = [NSMutableArray array];
            
            for (MenuFunctionModel *model in self.roleRightArr) {
                if ([self.roleModel.RoleNo isEqualToString:model.RoleNo]) {
                    NSDictionary *dic = @{@"Pno":model.Pno,@"RightValue":model.RightValue,@"RoleNo":self.roleModel.RoleNo};
                    [MArr addObject:dic];
                }
            }

            NSDictionary *jsonDic;
            
    jsonDic=@{ @"Command":@"Del",@"TableName":@"CMS_Role",@"CMS_RoleRight":MArr,@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"RoleNa":self.roleModel.RoleNa,@"Remark":self.roleModel.Remark,@"RoleNo":self.roleModel.RoleNo}]};
            
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
                    [SVProgressHUD dismiss];
                    [self alertShowWithStr:@"删除失败"];
                }
                
                
            } Faile:^(NSError *error) {
                NSLog(@"失败%@",error);
            }];
            
        }
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
    
}


@end
