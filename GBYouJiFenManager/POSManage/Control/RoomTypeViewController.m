//
//  RoomTypeViewController.m
//  GBYouJiFenManager

//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.

#import "RoomTypeViewController.h"
#import "ChooseTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface RoomTypeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;

@property(nonatomic,copy)NSString *conitionStr;


@end

@implementation RoomTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    _AreaArray = [NSMutableArray array];
    
    [self getAreaData];
    
    [self editOption];
    
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
//    [self.view addGestureRecognizer:tap];
}

-(void)editOption
{
//    if (_numberOfTag == 103) {
//        _nameLab.text = @"房台类型名称*:";
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 97, 21)];
//        label.text = @"楼层区域*:";
//        label.font = [UIFont systemFontOfSize:14];
//        label.textAlignment = NSTextAlignmentRight;
//        [self.view addSubview:label];
        
//        _areaField = [[UITextField alloc] initWithFrame:CGRectMake(100, 117, screen_width-8-101, 30)];
//        _areaField.text = @"--请选择楼层--";
//        _areaField.tag = 920;
//        _areaField.delegate = self;
//        _areaField.font = [UIFont systemFontOfSize:14];
//        _areaField.layer.borderWidth = 1;
//        _areaField.layer.borderColor = [UIColor blackColor].CGColor;
//        [self.view addSubview:_areaField];
//        
    
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 155, screen_width, 1)];
//        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [self.view addSubview:line];
//    }
//    if (_numberOfTag == 110) {
//        _nameLab.text = @"配送时间:";
//        _TypeName.placeholder = @"8:00:00";
//    }
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        if (_numberOfTag == 103) {
            
            self.FloorArea.text = _floorItnoString;
         
         self.TypeName.text = self.RTypeModel.RoomName;
         //self.areaField.text = self.RTypeModel.roomArea;
        }
//        if (_numberOfTag == 110) {
//            self.TypeName.text = self.deliModel.deliveryTime;
//        }
    }
    
    self.TypeName.delegate = self;
    self.FloorArea.delegate = self;
    self.FloorArea.tag = 920;
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)FinishBtnClick:(id)sender {
    if (_numberOfTag == 103){
        if (_TypeName.text.length==0) {
            [self alertShowWithStr:@"请输入必填信息"];
        }else if ([_FloorArea.text isEqualToString:@"--请选择区域--"])
        {
            [self alertShowWithStr:@"请选择区域"];
        }
//        else if (_floorItnoString == nil)
//        {
//            [self alertShowWithStr:@"请修改需选择的项"];
//        }
        else
        {
            if ([self.chooseType isEqualToString:@"Edit"]) {
                [self editItem];
            }else
            {
                [self addItem];
            }
        }
    }else
    {
        if (_TypeName.text.length==0) {
            [self alertShowWithStr:@"请输入必填信息"];
        }else
        {
            if ([self.chooseType isEqualToString:@"Edit"]) {
                [self editItem];
            }else
            {
                [self addItem];
            }
        }
    }
}

-(void)addItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    if (_numberOfTag == 103) {
        jsonDic=@{ @"Command":@"Add",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":_TypeName.text,@"ST005":_floorItNoStr}]};
    }
//    if (_numberOfTag == 110){
//        jsonDic=@{ @"Command":@"Add",@"TableName":@"POSSTT1",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":_TypeName.text}]};
//    }
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
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
-(void)editItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *jsonDic;
    if (_numberOfTag == 103) {
        NSString *str ;
        if (_floorItNoStr == nil) {
            str = self.RTypeModel.roomArea;
        }else
        {
            str = _floorItNoStr;
        }
        jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":_TypeName.text,@"ST001":self.RTypeModel.itemNo,@"ST005":str}]};
    }
//    if (_numberOfTag == 110){
//        jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSSTT1",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"STT002":_TypeName.text,@"STT001":self.deliModel.itemNo}]};
//    }

    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.backBlock();
                
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        if (textField.tag == 920) {
            if (_areaTable) {
                _areaTable.hidden = !_areaTable.hidden;
            }else
            {
                [self initAreaTable];
            }
            return NO;
        }
    return YES;
}

-(void)initAreaTable
{
    _areaTable = [[UITableView alloc] init];
    _areaTable.delegate = self;
    _areaTable.dataSource = self;
    [self.view addSubview:_areaTable];
    
    [_areaTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_FloorArea.mas_bottom);
       // make.left.mas_equalTo(_FloorArea.mas_left);
        make.left.mas_equalTo(screen_width/2);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(4*40);
    }];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    _areaTable.tableFooterView = v;
    _areaTable.layer.borderWidth = 1;
    _areaTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_areaTable dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _AreaArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloorModel *model = _AreaArray[indexPath.row];
    ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    cell.contentLable.font = [UIFont systemFontOfSize:13];
    cell.contentLable.text= model.FloorInfo;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _areaTable.hidden=YES;
    
    FloorModel *model = _AreaArray[indexPath.row];
    
    _FloorArea.text = model.FloorInfo;
    _floorItNoStr = model.itemNo;
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
        _AreaArray = [FloorModel getDataWithDic:dic1];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
