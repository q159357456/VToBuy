//
//  HouseDataViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.

#import "HouseDataViewController.h"
#import "RoomDataTableViewCell.h"
#import "RoomStateViewController.h"
#import "ClassesInfoViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "OffspringViewController.h"
#import "RechargeViewController.h"
#import "SettleAccountViewController.h"
#import "SettleBillClassModel.h"


@interface HouseDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *title1;
@property(nonatomic,strong)NSArray *title2;
@property(nonatomic,strong)NSArray *title3;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;

@end

@implementation HouseDataViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    [self   initOperationBtn];
    
    [self initTitleArr];
    
    [self getAllData];
    
    [self getRoomTypeData];
    
    [self getFloorAreaData];
    
    [self getTasteBigClassData];
    
    [self getRoleData];
    
    [self getMenuData];
    
    [self getRoleRightData];
    
    [self getMenuRightData];
    
    [self getRoomInfoData];
    
    [self initTable];
    
    [self getSettleBillCode];

}

-(void)getRoomInfoData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSSI",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _roomInfoArr = [roomDataModel getDataWithDic:dic1];
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getRoleRightData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_AccountRole",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        
        
        _roleRightArr = [QianTainRoleModel getDataWithDic:dic1];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(void)getMenuRightData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_AccountRight",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        
        _MenuRightArr = [MenuFunctionModel getDataWithDic:dic1];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getMenuData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    NSDictionary *dic = @{@"FromTableName":@"CMS_Menu",@"SelectField":@"*",@"Condition":@"ParentPnoNo$=$QT",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _allMenuArr = [MenuFunctionModel getDataWithDic:dic1];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}

-(void)getRoleData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    
    
    dic=@{@"FromTableName":@"CMS_Role",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _roleArr=[QianTainRoleModel getDataWithDic:dic1];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getSettleBillCode
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"POSCC",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _dataBillArray = [SettleBillClassModel getDataWith:dic1];
        [_table reloadData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initTitleArr
{
    _title1 = @[@"房台名称",@"班次名称",@"打印机名称",@"充值金额",@"结账方式",@"用户编号",@"设备编号"];
    _title2 = @[@"房台类型",@"起始时间",@"打印机IP",@"赠金金额",@"营收类型",@"用户名称",@"设备名称"];
    _title3 = @[@"楼层区域",@"终止时间",@"大类列表",@"赠送积分",@"结账分类",@"超级用户",@"房台名称"];
    
    _roomTypeArray = [NSMutableArray array];
    _floorAreaArray = [NSMutableArray array];
    
    _tasteBigClassArray = [NSMutableArray array];
    _dataBillArray = [NSMutableArray array];
    
    _roleArr = [NSMutableArray array];
    
    _allMenuArr = [NSMutableArray array];
    
    _roleRightArr = [NSMutableArray array];
    _MenuRightArr = [NSMutableArray array];
    
    _roomInfoArr = [NSMutableArray array];
}

-(void)getTasteBigClassData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic = @{@"FromTableName":@"Inv_classify",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject){
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        _tasteBigClassArray = [TasteClassifyModel getDataWithDic:dic1];
        
        [_table reloadData];
        
    } Faile:^(NSError *error){
        NSLog(@"失败%@",error);
    }];
}

-(void)getRoomTypeData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSST",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
     _roomTypeArray=[RoomTypeModel getDataWithDic:dic1];
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getFloorAreaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _floorAreaArray=[FloorModel getDataWithDic:dic1];
        
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
    if (_tagNum == 104) {
        dic=@{@"FromTableName":@"POSSI",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 107){
        dic=@{@"FromTableName":@"POSCS",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 114){
        dic=@{@"FromTableName":@"POSPS",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 115){
        dic=@{@"FromTableName":@"CRMMBR",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 116){
        dic=@{@"FromTableName":@"POSCM",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNum == 131){
     dic=@{@"FromTableName":@"CMS_Accounts",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
        
    }

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        if (_tagNum == 100) {
            _dataArray=[InternalRegisterModel getDataWithDic:dic1];
        }
        if (_tagNum == 104) {
            _dataArray=[roomDataModel getDataWithDic:dic1];
        }
        if (_tagNum == 107){
            _dataArray=[classesModel getDataWithDic:dic1];
        }
        if (_tagNum == 114) {
            _dataArray=[offspringPrintModel getDataWith:dic1];
        }
        if (_tagNum == 115) {
            _dataArray=[rechargeModel getDataWith:dic1];
        }
        if (_tagNum == 116) {
            _dataArray=[SettleBillModel getDataWith:dic1];
        }
        
        if (_tagNum == 131) {
            _dataArray=[userAccountModel getDataWithDic:dic1];
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
        /*if (i>0) {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(screen_width/3*i-1,screen_height-50, 1, 40)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [self.view addSubview:lineView];
        }*/
        
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.backgroundColor=[UIColor whiteColor];
        
        button.tag=i+1;
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)editBtnClick
{
    NSLog(@"点击编辑");
    
    if (_tagNum == 100) {
        if (self.internalModel) {
            
            InternalRegisterViewController *IRVC=[[InternalRegisterViewController alloc]initWithNibName:@"InternalRegisterViewController" bundle:nil];
            IRVC.chooseType=@"Edit";
            IRVC.internalModel=self.internalModel;
            IRVC.title=@"编辑";

            
            for (roomDataModel *model in _roomInfoArr) {
                if ([model.itemNo isEqualToString:self.internalModel.roomName]) {
                    IRVC.roomStr = model.roomName;
                }
            }
            
            IRVC.backBlock = ^{
                [self getAllData];
            };
            
            [self.navigationController pushViewController:IRVC animated:YES];
        
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    
    if (_tagNum == 104) {
    if (self.RDModel)
    {
        RoomStateViewController *RSVC=[[RoomStateViewController alloc]initWithNibName:@"RoomStateViewController" bundle:nil];
        RSVC.chooseType=@"Edit";
        RSVC.RoomDModel=self.RDModel;
        
        for (RoomTypeModel *model1 in _roomTypeArray) {
            if ([self.RDModel.roomType isEqualToString:model1.itemNo]) {
                RSVC.roomTypeStr = model1.RoomName;
            }
        }
        
        for (FloorModel *model2 in _floorAreaArray) {
            if ([self.RDModel.floorArea isEqualToString:model2.itemNo]) {
                RSVC.floorAreaStr = model2.FloorInfo;
            }
        }
        
        RSVC.title=@"编辑";
        RSVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:RSVC animated:YES];
        
    }else
    {
        [self alertShowWithStr:@"请选中编辑条目"];
    }
    }
    
    if (_tagNum == 107) {
        if (self.cModel)
        {
            ClassesInfoViewController *RSVC=[[ClassesInfoViewController alloc]initWithNibName:@"ClassesInfoViewController" bundle:nil];
            RSVC.chooseType=@"Edit";
            RSVC.ClassModel=self.cModel;
            RSVC.title=@"编辑";
            RSVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:RSVC animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    
    if (_tagNum == 114) {
        if (self.OffModel)
        {
            OffspringViewController *OVC=[[OffspringViewController alloc]initWithNibName:@"OffspringViewController" bundle:nil];
            OVC.chooseType=@"Edit";
            OVC.OffSPModel=self.OffModel;
            OVC.title=@"编辑";
            
            
            NSString *str = self.OffModel.BigClasses;
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
            OVC.tasteClassStr = string;

            
            OVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:OVC animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }

    if (_tagNum == 115) {
        if (self.ReModel)
        {
            RechargeViewController *RVC=[[RechargeViewController alloc]initWithNibName:@"RechargeViewController" bundle:nil];
            RVC.chooseType=@"Edit";
            RVC.ChargeModel=self.ReModel;
            RVC.title=@"编辑";
            RVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:RVC animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    

    if (_tagNum == 116) {
        if (self.SettleModel)
        {
            SettleAccountViewController *RVC=[[SettleAccountViewController alloc]initWithNibName:@"SettleAccountViewController" bundle:nil];
            RVC.chooseType=@"Edit";
            RVC.SBModel=self.SettleModel;
            RVC.title=@"编辑";
            RVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:RVC animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中编辑条目"];
        }
    }
    
    
    if (_tagNum == 131) {
        if (self.QModel)
       {
           
           
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
    
    //iPad注册
    if (_tagNum==100) {
        InternalRegisterViewController *IRVC = [[InternalRegisterViewController alloc] initWithNibName:@"InternalRegisterViewController" bundle:nil];
        IRVC.chooseType = @"Add";
        IRVC.navigationItem.title = @"新增";
        IRVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:IRVC animated:YES];
        
    }
    
    //房台资料
    if (_tagNum == 104) {
    RoomStateViewController *RSVC = [[RoomStateViewController alloc] initWithNibName:@"RoomStateViewController" bundle:nil];
    RSVC.chooseType = @"Add";
    RSVC.navigationItem.title = @"新增";
    RSVC.backBlock = ^{
        [self getAllData];
    };
    [self.navigationController pushViewController:RSVC animated:YES];
    }
    
    //班次
    if (_tagNum == 107) {
        ClassesInfoViewController *RSVC = [[ClassesInfoViewController alloc] initWithNibName:@"ClassesInfoViewController" bundle:nil];
        RSVC.chooseType = @"Add";
        RSVC.navigationItem.title = @"新增";
        RSVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:RSVC animated:YES];
    }
    
    
    //后厨打印机
    if (_tagNum == 114) {
        
            OffspringViewController *OVC=[[OffspringViewController alloc]initWithNibName:@"OffspringViewController" bundle:nil];
            OVC.chooseType=@"Add";
            OVC.title=@"新增";
            OVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:OVC animated:YES];
    }
    
    
    //充值规则
    if (_tagNum == 115) {
        
            RechargeViewController *RVC=[[RechargeViewController alloc]initWithNibName:@"RechargeViewController" bundle:nil];
            RVC.chooseType=@"Add";
            RVC.title=@"新增";
            RVC.backBlock = ^{
                [self getAllData];
            };
            [self.navigationController pushViewController:RVC animated:YES];
        
    }
    
    //结账方式
    if (_tagNum == 116) {
        
        SettleAccountViewController *RVC=[[SettleAccountViewController alloc]initWithNibName:@"SettleAccountViewController" bundle:nil];
        RVC.chooseType=@"Add";
        RVC.title=@"新增";
        RVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:RVC animated:YES];
        
    }

    //前台权限
    if (_tagNum == 131) {
        
           }
}

-(void)initTable
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 40)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (screen_width-30)/3, 39)];
    label1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-30)/3+30, 0, (screen_width-30)/3, 39)];
    label2.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(((screen_width-30)/3)*2+30, 0, (screen_width-30)/3, 39)];
    label3.textAlignment = NSTextAlignmentCenter;
    
    if (_tagNum == 104) {
        label1.text = _title1[0];
        label2.text = _title2[0];
        label3.text = _title3[0];
    }
    if (_tagNum == 107) {
        label1.text = _title1[1];
        label2.text = _title2[1];
        label3.text = _title3[1];
    }
    
    if (_tagNum == 114) {
        label1.text = _title1[2];
        label2.text = _title2[2];
        label3.text = _title3[2];
    }
    
    if (_tagNum == 115) {
        label1.text = _title1[3];
        label2.text = _title2[3];
        label3.text = _title3[3];
    }
    
    if (_tagNum == 116) {
        label1.text = _title1[4];
        label2.text = _title2[4];
        label3.text = _title3[4];
    }
    
    
    if (_tagNum == 131) {
        label1.text = _title1[5];
        label2.text = _title2[5];
        label3.text = _title3[5];
    }
    if (_tagNum == 100) {
        label1.text = _title1[6];
        label2.text = _title2[6];
        label3.text = _title3[6];
    }

    
    [_headView addSubview:label1];
    [_headView addSubview:label2];
    [_headView addSubview:label3];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, screen_width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headView addSubview:line];
    
    [self.view addSubview:_headView];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+64, screen_width, screen_height-64-60-40) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    
    [_table registerNib:[UINib nibWithNibName:@"RoomDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoomDataTableViewCell"];
    
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
    //添加上拉加载，下拉刷新功能。。
//    [self addHeaderRefresh];
//    [self addFooterRefresh];
}


//UITableView协议实现部分
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellid=@"RoomDataTableViewCell";
    RoomDataTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"RoomDataTableViewCell" owner:nil options:nil][0];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_tagNum == 100) {
        InternalRegisterModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel6:model];
        cell.RoomNameLab.text = model.itemNo;
        cell.RoomTypeLab.text = model.equipmentName;
        for (roomDataModel *rModel in _roomInfoArr) {
            if ([rModel.itemNo isEqualToString:model.roomName]) {
                cell.FloorAreaLab.text = rModel.roomName;
            }
        }
    }

    
    if (_tagNum == 104) {
        roomDataModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        //[cell setDataWithModel:model];
        cell.RoomNameLab.text = model.roomName;
        for (RoomTypeModel *model1 in _roomTypeArray) {
            if ([model.roomType isEqualToString:model1.itemNo]) {
                cell.RoomTypeLab.text = model1.RoomName;
            }
        }
        
        for (FloorModel *model2 in _floorAreaArray) {
            if ([model.floorArea isEqualToString:model2.itemNo]) {
                cell.FloorAreaLab.text = model2.FloorInfo;
            }
        }
    }
    if (_tagNum == 107) {
        classesModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel1:model];
    }
    
    if (_tagNum == 114) {
        offspringPrintModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        
        //[cell setDataWithModel2:model];
        NSString *str = model.BigClasses;
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
        cell.FloorAreaLab.text = string;
        //self.name.text = model.classifyList;
        cell.RoomNameLab.text = model.PrinterName;
        cell.RoomTypeLab.text = model.PrinterIP;
    }

    if (_tagNum == 115) {
        rechargeModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel3:model];
    }

    
    if (_tagNum == 116) {
        SettleBillModel *model=_dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        //[cell setDataWithModel4:model];
        cell.RoomNameLab.text = model.billName;
        if ([model.GetCode isEqualToString:@"0"]) {
            cell.RoomTypeLab.text = @"非营业收入";
        }
        if ([model.GetCode isEqualToString:@"1"]) {
            cell.RoomTypeLab.text = @"营业收入";
        }
        for (SettleBillClassModel *sModel in _dataBillArray) {
            if ([sModel.itemNo isEqualToString:model.BillCode]) {
                cell.FloorAreaLab.text = sModel.billName;
            }
        }
        
       // self.FloorAreaLab.text = model.BillCode;
    }
    
    if (_tagNum == 131) {
        userAccountModel *model=_dataArray[indexPath.row];
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
    
    if (_tagNum == 100) {
        InternalRegisterModel *model=_dataArray[indexPath.row];
        
        for (InternalRegisterModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.internalModel=smodel;
                }else
                {
                    self.RDModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }
    
    if (_tagNum == 104) {
        roomDataModel *model=_dataArray[indexPath.row];
        
        for (roomDataModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.RDModel=smodel;
                }else
                {
                    self.RDModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }

    }
    
    if (_tagNum == 107) {
        classesModel *model=_dataArray[indexPath.row];
        
        for (classesModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.cModel=smodel;
                }else
                {
                    self.cModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }

    }
    
    if (_tagNum == 114) {
        offspringPrintModel *model=_dataArray[indexPath.row];
        
        for (offspringPrintModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.OffModel=smodel;
                }else
                {
                    self.OffModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }

    
    if (_tagNum == 115) {
        rechargeModel *model=_dataArray[indexPath.row];
        
        for (rechargeModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.ReModel=smodel;
                }else
                {
                    self.ReModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }
    
    

    if (_tagNum == 116) {
        SettleBillModel *model=_dataArray[indexPath.row];
        
        for (SettleBillModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.SettleModel=smodel;
                }else
                {
                    self.SettleModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }

    if (_tagNum == 131) {
        userAccountModel *model=_dataArray[indexPath.row];
        
        for (userAccountModel *smodel in _dataArray) {
            if (smodel.Account_No==model.Account_No)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.QModel=smodel;
                }else
                {
                    self.QModel=nil;
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
    return 40.0f;
}




-(void)deleteItem
{
    if (_tagNum == 100) {
        if (!self.internalModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSDV",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DV002":self.internalModel.equipmentName,@"DV006":self.internalModel.roomName,@"DV001":self.internalModel.itemNo}]};
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


    if (_tagNum == 104) {
    if (!self.RDModel)
    {
        [self alertShowWithStr:@"请选中删除的条目"];
        
    }else
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *jsonDic;
        jsonDic=@{ @"Command":@"Del",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"SI002":self.RDModel.roomName,@"SI003":self.RDModel.roomType,@"SI004":self.RDModel.floorArea,@"SI015":self.RDModel.isValid,@"SI018":self.RDModel.isBook,@"SI001":self.RDModel.itemNo}]};
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
    
    
    if (_tagNum == 107) {
        if (!self.cModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSCS",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"CS002":self.cModel.classesName,@"CS003":self.cModel.beginTime,@"CS004":self.cModel.endTime,@"CS001":self.cModel.itemNo}]};
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
    
    if (_tagNum == 114) {
        if (!self.OffModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSPS",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"PS002":self.OffModel.PrinterName,@"PS004":self.OffModel.PrinterIP,@"PS007":self.OffModel.BigClasses,@"PS001":self.OffModel.itemNo}]};
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

    
    
    
    if (_tagNum == 115) {
        if (!self.ReModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSArray *arr = [self.ReModel.CashNumber componentsSeparatedByString:@","];
            NSString *str = [arr componentsJoinedByString:@""];
            
            NSArray *arr1 = [self.ReModel.PresentNumber componentsSeparatedByString:@","];
            NSString *str1 = [arr1 componentsJoinedByString:@""];
            
            NSArray *arr2 = [self.ReModel.CreditsScore componentsSeparatedByString:@","];
            NSString *str2 = [arr2 componentsJoinedByString:@""];
            
            
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"CRMMBR",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"MBR001":str,@"MBR002":str1,@"MBR003":str2,@"MBR000":self.ReModel.itemNo}]};
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
    
    if (_tagNum == 116) {
        if (!self.SettleModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSCM",@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"CM002":self.SettleModel.billName,@"CM017":self.SettleModel.GetCode,@"CM004":self.SettleModel.BillCode,@"CM005":self.SettleModel.insideRate,@"CM006":self.SettleModel.outsideRate,@"CM007":self.SettleModel.sortOrder,@"CM008":self.SettleModel.printBill,@"CM011":self.SettleModel.faceValueType,@"CM013":self.SettleModel.faceValueMoney,@"CM018":self.SettleModel.rerurnCharge,@"CM019":self.SettleModel.validCode,@"CM022":self.SettleModel.scoreExchange,@"CM023":self.SettleModel.speedMoney,@"CM001":self.SettleModel.itemNo}]};
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
    
    
    if (_tagNum == 131) {
        if (!self.QModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            
            
            NSMutableArray *RArr = [NSMutableArray array];
            NSMutableArray *MArr = [NSMutableArray array];
            
            for (QianTainRoleModel *model in self.roleArr) {
                if ([model.RoleNo isEqualToString:self.QModel.RoleNo]) {
                    NSDictionary *dic = @{@"RoleNo":model.RoleNo,@"AccountNo":self.QModel.AccountNo};
                    [RArr addObject:dic];

                }
            }
            
            for (MenuFunctionModel *model in self.allMenuArr) {
                if ([model.Pno isEqualToString:self.QModel.Pno]) {
                    NSDictionary *dic = @{@"Pno":model.Pno,@"RightValue":model.RightValue,@"AccountNo":self.QModel.AccountNo1};
                    [MArr addObject:dic];
                    
                }
            }
            
            NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Del",@"TableName":@"CMS_Accounts",@"CMS_AccountRole":RArr,@"CMS_AccountRight":MArr,@"Data":@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"CREATOR":@"admin",@"Account_No":self.QModel.Account_No,@"Account_Name":self.QModel.Account_Name,@"Password":self.QModel.passWord,@"IsSuper":self.QModel.isSuper}]};
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
                    [self alertShowWithStr:str];
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

-(void)addHeaderRefresh
{
    MJRefreshGifHeader *header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //1.重置页数
        
        //2.清空页数
        [_dataArray removeAllObjects];
        
        //3.重新发生网络请求
        [self getAllData];
        
    }];
    
    [header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
    _table.mj_header=header;
    
}
-(void)addFooterRefresh
{
    //上拉刷新
    MJRefreshAutoGifFooter *footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //1.页数增加
        
        
        //2.重新请求数据
        [self getAllData];
        
        
    }];
    
    
    _table.mj_footer=footer;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
