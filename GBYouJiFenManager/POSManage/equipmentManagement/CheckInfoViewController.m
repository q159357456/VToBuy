//
//  CheckInfoViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/4.
//  Copyright © 2017年 xia. All rights reserved.

#import "CheckInfoViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "ChooseTableViewCell.h"
@interface CheckInfoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation CheckInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    _conditionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    [self editOption];
    
    self.areaArray = [NSMutableArray array];
    
    [self getAreaData];
}
-(void)setFinishBtn:(UIButton *)finishBtn
{
    _finishBtn=finishBtn;
    _finishBtn.backgroundColor=navigationBarColor;
}
-(void)getAreaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":_conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        _areaArray = [FloorModel getDataWithDic:dic1];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)editOption
{
    self.PCArea.tag = 710;
    if ([self.chooseType isEqualToString:@"Edit"]) {
        self.PCMAC.text = self.PCModel.PCMAC;
        self.PCName.text = self.PCModel.PCName;
        self.PCArea.text = self.floorItnoString;
        self.areaCode = self.PCModel.PCArea;
    }else
    {
        self.PCArea.text = @"--请选择--";
    }
    self.PCMAC.delegate = self;
    self.PCName.delegate = self;
    self.PCArea.delegate = self;
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)FinishBtnClick:(id)sender{
    
    if (_PCName.text.length==0||_PCMAC.text.length == 0||[_PCArea.text isEqualToString:@"--请选择--"]) {
        [self alertShowWithStr:@"请输入必填信息"];
    }else if (_areaCode == nil)
    {
        [self alertShowWithStr:@"请修改选择项"];
    }
    else
    {
        if ([self.chooseType isEqualToString:@"Edit"]) {
            [self editItem];
        }else
        {
            [self addItem];
        }
    }
}

-(void)addItem
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSDN",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DN002":_PCName.text,@"DN006":_areaCode,@"DN004":_PCMAC.text}]};
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
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSDN",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"DN004":_PCMAC.text,@"DN002":_PCName.text,@"DN006":_areaCode,@"DN001":self.PCModel.itemNo}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 710) {
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
        make.top.mas_equalTo(self.PCArea.mas_bottom);
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
    return _areaArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloorModel *model = _areaArray[indexPath.row];
    ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    cell.contentLable.font = [UIFont systemFontOfSize:13];
    cell.contentLable.text= model.FloorInfo;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _areaTable.hidden=YES;
    
    FloorModel *model = _areaArray[indexPath.row];
    
    self.PCArea.text = model.FloorInfo;
    
    _areaCode = model.itemNo;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
