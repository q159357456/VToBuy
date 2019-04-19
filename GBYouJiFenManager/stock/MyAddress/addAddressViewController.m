//
//  addAddressViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "addAddressViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "IDAddressPickerView.h"
#import "RegionModel.h"
@interface addAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IDAddressPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *defaultAddr;
@property(nonatomic,copy)NSString *memberNo;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)MemberModel *model;
@property (nonatomic, strong) IDAddressPickerView *addressPickerView;
@property(nonatomic,strong)NSMutableDictionary *areaDic;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *provinceCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *AreaName;
@property(nonatomic,copy)NSString *AreaCode;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *citypeArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation addAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    _doneButton.backgroundColor=navigationBarColor;
    _dataArray = [NSMutableArray array];
    _provinceArray = [NSMutableArray array];
    _citypeArray = [NSMutableArray array];
    _areaArray = [NSMutableArray array];
    
    [self initTable];
    
    [self initType];
    
    [self getprovinceData];
    
}

-(void)initType
{
    _titleArray = @[@"姓名",@"电话",@"地区",@"地址"];
    if ([self.chooseType isEqualToString:@"Edit"]) {
        
        self.name = self.addressModel.contact;
        self.mobile = self.addressModel.mobile;
        self.area = self.addressModel.area;
        self.address = self.addressModel.address;
        self.defaultAddr = self.addressModel.defaultAddress;
        
    }else
    {
        self.defaultAddr = @"True";
    }
}

-(void)initTable
{
    _table.delegate = self;
    _table.dataSource = self;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    _table.tableFooterView = v;
    
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTableViewCell"];
    [_table registerNib:[UINib nibWithNibName:@"AddDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTwoTableViewCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<4) {
        static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
        
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
           
        }
        
        cell.nameLable.text = _titleArray[indexPath.row];
        cell.nameLable.font = [UIFont systemFontOfSize:13];
        cell.nameLable.textAlignment = NSTextAlignmentCenter;
        
        [self getCellDataWithCell:cell index:indexPath.row];
        cell.inputText.delegate=self;
        cell.inputText.tag = 150 + indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        __weak typeof(self)weakSelf=self;
        
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.titleLable.text=@"设为默认地址";
        cell.titleLable.font = [UIFont systemFontOfSize:12];
        cell.titleLable.textAlignment = NSTextAlignmentRight;
        if ([self.chooseType isEqualToString:@"Edit"]) {
            if ([self.defaultAddr isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 0;
        }
        
        cell.statuseBlock=^(NSString *str){
            
            weakSelf.defaultAddr=str;
            NSLog(@"是否设置为默认地址:%@",weakSelf.defaultAddr);
            
        };
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
}

-(void)getCellDataWithCell:(AddDetailTableViewCell*)cell index:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            cell.inputText.text = self.name;
            
        }
            break;
        case 1:
        {
            
            cell.inputText.text = self.mobile;
        }
            break;
        case 2:
        {
            
            cell.inputText.text = self.area;
            
        }
            break;
        case 3:
        {
            cell.inputText.text = self.address;
            
            
        }
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
    switch (textField.tag) {
        case 150:
        {
            self.name = textField.text;
        }
            break;
        case 151:
        {
            
            self.mobile = textField.text;
            
        }
            break;
        case 152:
        {
           // self.area = textField.text;
        }
            break;
        case 153:
        {
            self.address = textField.text;
        }
            break;
            
            
        default:
            
            break;
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 152) {
        //选择区域
        [self.view endEditing:YES];
        if (!_addressPickerView) {
            
            _addressPickerView = [[IDAddressPickerView alloc] initWithFrame:CGRectMake(0, screen_height-250, screen_width, 250)];
            _addressPickerView.backgroundColor=[UIColor groupTableViewBackgroundColor];
            __weak typeof(self)weakSelf=self;
            _addressPickerView.backBlock=^(NSInteger index,NSMutableDictionary *dic){
                if (index==1)
                {
                    
                    //确定
                    weakSelf.areaDic=dic;
                    UITextField *field = [weakSelf.view viewWithTag:152];
//                    [weakSelf getprovinceCodeWithStr:dic[@"Province"]];
                    weakSelf.provinceName=dic[@"Province"];
                    weakSelf.cityName=dic[@"CityKey"];
                    weakSelf.AreaName=dic[@"AreaKey"];

                    NSMutableString *address=[NSMutableString stringWithString:dic[@"Province"]];
                    [address appendString:dic[@"CityKey"]];
                    [address appendString:dic[@"AreaKey"]];
                    _area = address;
                    field.text = address;
                    weakSelf.addressPickerView.hidden=YES;
                    
                }else
                {
                    //取消
                    weakSelf.addressPickerView.hidden=YES;
                    
                }
            };
            _addressPickerView.dataSource = self;
            [self.view addSubview:_addressPickerView];
        }else
        {
            _addressPickerView.hidden=!_addressPickerView.hidden;
        }
      return NO;
    }else
    {
        return YES;
    }
    
}


-(void)getprovinceCodeWithStr:(NSString*)str
{
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Provice",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"provName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        self.provinceCode=dic1[@"DataSet"][@"Table"][0][@"provCode"];
        
        NSLog(@"%@",  self.provinceCode);
        
        [self getcityCodeWithStr:self.areaDic[@"CityKey"]];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)getcityCodeWithStr:(NSString*)str
{
    NSDictionary *dic=@{@"FromTableName":@"CMS_City",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"cityName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",[NSString stringWithFormat:@"cityName$=$%@",str]);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        self.cityCode=dic1[@"DataSet"][@"Table"][0][@"cityCode"];
        
        NSLog(@"%@",  self.cityCode);
        [self getareaCodeWithStr:self.areaDic[@"AreaKey"]];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)getareaCodeWithStr:(NSString*)str
{
    NSDictionary *dic=@{@"FromTableName":@"CMS_Borough",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"boroName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        self.AreaCode=dic1[@"DataSet"][@"Table"][0][@"boroCode"];
        NSLog(@"%@", self.AreaCode);
        
        [self getAllData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}


-(void)getprovinceData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Provice",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        
        _provinceArray=[RegionModel getDataWithDic:dic1 withStr:@"Provice"];
        
        [self getcityData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getcityData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_City",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _citypeArray=[RegionModel getDataWithDic:dic1 withStr:@"City"];
        
        
        [self getareaData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getareaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Borough",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _areaArray=[RegionModel getDataWithDic:dic1 withStr:@"Borough"];
        [self getAllData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getAllData
{
    
    for (RegionModel *qmodel in _provinceArray)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:qmodel.provName forKey:@"state"];
        NSMutableArray *city=[NSMutableArray array];
        for (RegionModel *wmodel in _citypeArray)
        {
            
            NSMutableDictionary *cityDic=[NSMutableDictionary dictionary];
            
            
            
            if ([wmodel.provCode isEqualToString:qmodel.provCode])
            {
                
                [cityDic setValue:wmodel.cityName forKey:@"city"];
                NSMutableArray *borth=[NSMutableArray array];
                for (RegionModel*rmodel in _areaArray)
                {
                    
                    if ([rmodel.cityCode isEqualToString:wmodel.cityCode])
                    {
                        [borth addObject:rmodel.boroName];
                    }
                }
                
                [cityDic setValue:borth forKey:@"areas"];
                [city addObject:cityDic];
            }
            
        }
        
        [dic setValue:city forKey:@"cities"];
        [_dataArray addObject:dic];
        
    }
    [_dataArray removeObjectsInRange:NSMakeRange(_dataArray.count-3, 3)];
    
    
}

#pragma mark - IDAddressPickerViewDataSource
- (NSArray *)addressArray {
    return _dataArray;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)fingerTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(void)alertShowWithString:(NSString *)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)btnClick:(id)sender {
    if (self.name.length == 0 || self.mobile.length == 0 || self.area.length == 0 || self.address.length == 0) {
        [self alertShowWithString:@"请输入完整信息"];
    }else if(self.mobile.length != 11)
    {
        [self alertShowWithString:@"手机号码输入错误"];
    }
    else{
        [self operateAddress];
    }
}

-(void)operateAddress
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    
    if ([self.chooseType isEqualToString:@"Edit"]) {
        jsonDic=@{ @"Command":@"Edit",@"TableName":@"CMS_MyAddress",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Contact":self.name,@"Mobile":self.mobile,@"Area":self.area,@"Address":self.address,@"DefaultAddr":self.defaultAddr,@"ID":self.addressModel.ID,@"MemberNo":self.model.SHOPID}]};
    }else
    {
    jsonDic=@{ @"Command":@"Add",@"TableName":@"CMS_MyAddress",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Contact":self.name,@"Mobile":self.mobile,@"Area":self.area,@"Address":self.address,@"DefaultAddr":self.defaultAddr,@"MemberNo":self.model.SHOPID}]};
    }
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            
            if ([self.chooseType isEqualToString:@"Edit"]) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.backBlock();
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithString:str];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
