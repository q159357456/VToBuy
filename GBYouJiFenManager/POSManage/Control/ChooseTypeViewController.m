//
//  ChooseTypeViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 xia. All rights reserved.

#import "ChooseTypeViewController.h"
#import "FloorTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface ChooseTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end

@implementation ChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    _dataArray = [NSMutableArray array];
    _floorArray = [NSMutableArray array];
    

    [self getAllData];
    
    [self initTable];
}

-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    if (_tagNumber == 201) {
        dic=@{@"FromTableName":@"POSST",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }if (_tagNumber == 202) {
        dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNumber == 204){
        dic=@{@"FromTableName":@"POSSI",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNumber == 301) {
        dic=@{@"FromTableName":@"POSDC",@"SelectField":@"*",@"Condition":self.conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    
    if (_tagNumber == 402) {
        dic=@{@"FromTableName":@"CMS_BaseVar",@"SelectField":@"*",@"Condition":@"ModuleNo$=$POS$AND$VarField$=$p_discount",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        if (_tagNumber == 201) {
            _floorArray=[RoomTypeModel getDataWithDic:dic1];
            [self getShowData];
        }
        if (_tagNumber == 202) {
            _dataArray=[FloorModel getDataWithDic:dic1];
        }
        if (_tagNumber == 204) {
            _dataArray=[roomDataModel getDataWithDic:dic1];
        }
        if (_tagNumber == 301) {
            _dataArray=[TasteKindModel getDataWithDic:dic1];
        }
        if (_tagNumber == 402) {
            _dataArray=[discountClassifyModel getDataWithDic:dic1];
        }
        
        
        [_table reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
  
}

-(void)getShowData
{
    for (RoomTypeModel *model in _floorArray) {
        if ([model.roomArea isEqualToString:_floorStr]) {
            [_dataArray addObject:model];
        }
    }

}

-(void)initTable
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, screen_width, 50)];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sureBtn.backgroundColor = MainColor;
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_PRO(50));
    }];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 29, screen_width, screen_height-114) style:UITableViewStyleGrouped];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    
    [_table registerNib:[UINib nibWithNibName:@"FloorTableViewCell" bundle:nil] forCellReuseIdentifier:@"FloorTableViewCell"];
    
    [self.view  addSubview:_table];
    self.keyTableView = _table;
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-HEIGHT_PRO(50));
    }];
}

-(void)sureBtnClick
{
    if (_tagNumber == 201) {
        if (self.tModel.itemNo.length>0)
        {
            self.backBlock(self.tModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择房台类型"];
        }
    }
    if (_tagNumber == 202) {
        if (self.FModel.itemNo.length>0)
        {
            self.backBlock1(self.FModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择楼层"];
        }
    }
    
    if (_tagNumber == 204) {
        if (self.RDModel.itemNo.length>0)
        {
            self.backBlock4(self.RDModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择房台"];
        }
    }
    
    if (_tagNumber == 301) {
        if (self.kModel.itemNo.length>0)
        {
            self.backBlock2(self.kModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择口味分类"];
        }
    }
    
    if (_tagNumber == 402) {
        if (self.dcModel.VarDisPlay.length>0)
        {
            self.backBlock3(self.dcModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择折扣类型"];
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



//实现table的协议
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
    if (_tagNumber == 201) {
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
    if (_tagNumber == 202) {
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
    
    if (_tagNumber == 204) {
        roomDataModel *model = _dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        cell.floorLab.text = model.roomName;
        
    }
    
    if (_tagNumber == 301) {
        TasteKindModel *model = _dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        cell.floorLab.text = model.classifyName;
        
    }
    if (_tagNumber == 402) {
        discountClassifyModel *model = _dataArray[indexPath.row];
        if (model.selected)
        {
            cell.selectLab.backgroundColor=[UIColor greenColor];
            
        }else
        {
            cell.selectLab.backgroundColor=[UIColor whiteColor];
        }
        cell.floorLab.text = model.VarDisPlay;
        
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNumber == 201) {
        RoomTypeModel *model=_dataArray[indexPath.row];
        
        for (RoomTypeModel *smodel in _dataArray) {
            if (smodel.RoomName==model.RoomName)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.tModel=smodel;
                }else
                {
                    self.tModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }

    }
    if (_tagNumber == 202) {
        FloorModel *model=_dataArray[indexPath.row];
        
        for (FloorModel *smodel in _dataArray) {
            if (smodel.FloorInfo==model.FloorInfo)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.FModel=smodel;
                }else
                {
                    self.FModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }

    }
    
    if (_tagNumber == 204) {
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

    
    
    if (_tagNumber == 301) {
        TasteKindModel *model=_dataArray[indexPath.row];
        
        for (TasteKindModel *smodel in _dataArray) {
            if (smodel.classifyName==model.classifyName)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.kModel=smodel;
                }else
                {
                    self.kModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }

    
    if (_tagNumber == 402) {
        discountClassifyModel *model=_dataArray[indexPath.row];
        
        for (discountClassifyModel *smodel in _dataArray) {
            if (smodel.VarValue==model.VarValue)
            {
                smodel.selected=!smodel.selected;
                if (smodel.selected==YES) {
                    self.dcModel = smodel;
                }else
                {
                    self.dcModel=nil;
                }
                
            }else
            {
                smodel.selected=NO;
            }
        }
        
    }

        [_table reloadData];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
