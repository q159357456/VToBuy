//
//  FloorViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.
//

#import "FloorViewController.h"
#import "FloorTableViewCell.h"
#import "FloorInfoViewController.h"
#import "RoomTypeViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface FloorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end

@implementation FloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _areaArray = [NSMutableArray array];
    [self   initOperationBtn];
    
    [self initTable];
    
    [self getAllData];
    
    [self getAreaData];
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
        
        _areaArray = [FloorModel getDataWithDic:dic1];
        
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
    if (_tagNum == 102) {
        dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 103) {
        dic=@{@"FromTableName":@"POSST",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 110) {
        dic=@{@"FromTableName":@"POSSTT1",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        if (_tagNum == 102) {
            _dataArray=[FloorModel getDataWithDic:dic1];
        }
        if (_tagNum == 103) {
            _dataArray=[RoomTypeModel getDataWithDic:dic1];
        }
        if (_tagNum == 110) {
            _dataArray=[deliveryModel getDataWithDic:dic1];
        }
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initOperationBtn
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

-(void)editBtnClick
{
    if (_tagNum == 102) {
        
    if (self.fModel) {
        
    FloorInfoViewController *FIVC=[[FloorInfoViewController alloc]initWithNibName:@"FloorInfoViewController" bundle:nil];
    FIVC.chooseType=@"Edit";
    FIVC.numberOfTag = 102;
    FIVC.FLModel=self.fModel;
    FIVC.title=@"编辑";
    FIVC.backBlock = ^{
        [self getAllData];
    };
    
    [self.navigationController pushViewController:FIVC animated:YES];
    
}else
{
    [self alertShowWithStr:@"请选中需编辑的条目"];
}
    }
    
    
    if (_tagNum == 103) {
        if (self.RTModel){
            
            RoomTypeViewController *RTVC=[[RoomTypeViewController alloc]initWithNibName:@"RoomTypeViewController" bundle:nil];
            RTVC.chooseType=@"Edit";
            RTVC.numberOfTag = 103;
            RTVC.RTypeModel=self.RTModel;
            for (FloorModel *model in _areaArray) {
                if ([self.RTModel.roomArea isEqualToString:model.itemNo]) {
                    RTVC.floorItnoString = model.FloorInfo;
                }
            }

            RTVC.title=@"编辑";
            RTVC.backBlock = ^{
                [self getAllData];
            };
            
            [self.navigationController pushViewController:RTVC animated:YES];
            
        }else
        {
            [self alertShowWithStr:@"请选中需编辑的条目"];
        }

        
    }
    if (_tagNum == 110) {
        
            
            if (self.dModel) {
                
                FloorInfoViewController *FIVC=[[FloorInfoViewController alloc]initWithNibName:@"FloorInfoViewController" bundle:nil];
                FIVC.chooseType=@"Edit";
                FIVC.deliModel=self.dModel;
                FIVC.numberOfTag = 110;
                FIVC.title=@"编辑";
                FIVC.backBlock = ^{
                    [self getAllData];
                };
                
                [self.navigationController pushViewController:FIVC animated:YES];
                
            }else
            {
                [self alertShowWithStr:@"请选中需编辑的条目"];
            }
        }
    


}

-(void)delBtnClick
{
    [self deleteItem];
}

-(void)addBtnClick
{
    if (_tagNum == 102) {
    FloorInfoViewController *FIVC = [[FloorInfoViewController alloc] initWithNibName:@"FloorInfoViewController" bundle:nil];
    FIVC.chooseType = @"Add";
    FIVC.navigationItem.title = @"新增";
    FIVC.numberOfTag = 102;
    FIVC.backBlock = ^{
        [self getAllData];
    };
    [self.navigationController pushViewController:FIVC animated:YES];
    }
    
    if (_tagNum == 103) {
        RoomTypeViewController *RTVC = [[RoomTypeViewController alloc] initWithNibName:@"RoomTypeViewController" bundle:nil];
        RTVC.chooseType = @"Add";
        RTVC.numberOfTag = 103;
        RTVC.navigationItem.title = @"新增";
        RTVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:RTVC animated:YES];
    }
    
    if (_tagNum == 110) {
        
        FloorInfoViewController *FIVC = [[FloorInfoViewController alloc] initWithNibName:@"FloorInfoViewController" bundle:nil];
        FIVC.chooseType = @"Add";
        FIVC.navigationItem.title = @"新增";
        FIVC.numberOfTag = 110;
        FIVC.backBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:FIVC animated:YES];
    }
}

-(void)initTable
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 40)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _headView.frame.size.width, 39)];
    if (_tagNum == 102) {
        lab.text = @"区域/楼层名称";
    }
    if (_tagNum == 103) {
        lab.text = @"房台类型";
    }
    if (_tagNum == 110) {
        lab.text = @"配送时间";
    }
    lab.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, screen_width, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headView addSubview:line];
    [self.view addSubview:_headView];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, screen_width, screen_height-64-60-40) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _table.tableFooterView = v;
    
    [_table registerNib:[UINib nibWithNibName:@"FloorTableViewCell" bundle:nil] forCellReuseIdentifier:@"FloorTableViewCell"];
    
    [self.view addSubview:_table];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"FloorTableViewCell";
    FloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FloorTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_tagNum == 102) {

    FloorModel *model = _dataArray[indexPath.row];
    if (model.selected)
    {
        cell.selectLab.backgroundColor=[UIColor greenColor];
        
    }else
    {
        cell.selectLab.backgroundColor=[UIColor whiteColor];
    }
    [cell setDataWithModel:model];
    }
    
    if (_tagNum == 103) {
        
        RoomTypeModel *model = _dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel1:model];
    }
    
    if (_tagNum == 110) {
        
        deliveryModel *model = _dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        [cell setDataWithModel2:model];
    }


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNum == 102) {
        FloorModel *model=_dataArray[indexPath.row];
        
        for (FloorModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.fModel=smodel;
                }else
                {
                    self.fModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }
    
    if (_tagNum == 103) {
        RoomTypeModel *model=_dataArray[indexPath.row];
        
        for (RoomTypeModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.RTModel=smodel;
                }else
                {
                    self.RTModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
    }
    if (_tagNum == 110) {
        deliveryModel *model=_dataArray[indexPath.row];
        
        for (deliveryModel *smodel in _dataArray) {
            if (smodel.itemNo==model.itemNo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.dModel=smodel;
                }else
                {
                    self.dModel=nil;
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

-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)deleteItem
{
    if (_tagNum == 102) {
        
        if (!self.fModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            NSDictionary *jsonDic;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSAF",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"AF002":self.fModel.FloorInfo,@"AF001":self.fModel.itemNo}]};
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
    
    if (_tagNum == 103) {
        if (!self.RTModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            NSDictionary *jsonDic;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":self.RTModel.RoomName,@"ST001":self.RTModel.itemNo}]};
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
    
    
    if (_tagNum == 110) {
        
        if (!self.dModel)
        {
            [self alertShowWithStr:@"请选中删除的条目"];
            
        }else
        {
            NSDictionary *jsonDic;
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [SVProgressHUD showWithStatus:@"加载中"];
            jsonDic=@{ @"Command":@"Del",@"TableName":@"POSSTT1",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":self.dModel.deliveryTime,@"STT001":self.dModel.itemNo}]};
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
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
