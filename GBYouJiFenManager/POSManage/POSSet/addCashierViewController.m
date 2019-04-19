//
//  addCashierViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/7/31.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "addCashierViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface addCashierViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *title1;
@property(nonatomic,strong)NSArray *title2;
@property(nonatomic,strong)NSArray *title3;
@property(nonatomic,strong)MemberModel *model;

@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *phoneNumber;//手机号码
@property(nonatomic,copy)NSString *screat;//密码
@property(nonatomic,copy)NSString *sureScreat;//确认密码
@property(nonatomic,copy)NSString *addRoom;;//创建房台
@property(nonatomic,copy)NSString *addGood;//新增商品
@property(nonatomic,copy)NSString *systemSet;//系统设置
@property(nonatomic,copy)NSString *memberManage;//会员管理
@property(nonatomic,copy)NSString *cashManage;//收银管理
@property(nonatomic,copy)NSString *changeMoney;//单品改价
@property(nonatomic,copy)NSString *isReport;//报表管理
@property(nonatomic,copy)NSString *discountSettle;//折扣
@property(nonatomic,copy)NSString *zengSong;//招待
@property(nonatomic,copy)NSString *Moling;//抹零
@property(nonatomic,copy)NSString *freezeAccount;//冻结账户

@end

@implementation addCashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self initArray];
    
    [self initTable];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:tap];
    
    if ([self.typeString isEqualToString:@"detail"]) {
        self.name = self.cashModel.name;
        self.phoneNumber = self.cashModel.phoneNumber;
        self.addGood = self.cashModel.addGood;
        self.addRoom = self.cashModel.addRoom;
        self.systemSet = self.cashModel.systemSet;
        self.memberManage = self.cashModel.memberManage;
        self.cashManage = self.cashModel.cashManage;
        self.changeMoney = self.cashModel.changeMoney;
        self.isReport = self.cashModel.isReport;
        self.discountSettle = self.cashModel.discountSettle;
        self.Moling = self.cashModel.Moling;
        self.zengSong = self.cashModel.zengSong;
        self.freezeAccount = self.cashModel.freezeAccount;
        
        [self addRightButton];
        
    }else
    {
        self.addGood = @"True";
        self.addRoom = @"True";
        self.systemSet = @"True";
        self.memberManage = @"True";
        self.cashManage = @"True";
        self.changeMoney = @"True";
        self.isReport = @"True";
        self.discountSettle = @"True";
        self.Moling = @"True";
        self.zengSong = @"True";
        self.freezeAccount = @"false";
    }
    
    
}

-(void)addRightButton
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}



-(void)initArray
{
    self.title1 = [NSArray arrayWithObjects:@"姓名",@"手机号码",@"密码",@"确认密码",nil];
    self.title2 = [NSArray arrayWithObjects:@"房台创建",@"新增商品",@"系统设置",@"会员管理",@"收银管理",@"单品改价",@"报表管理",@"折扣",@"招待",@"抹零",nil];
    self.title3 = [NSArray arrayWithObjects:@"是否冻结账号",nil];
}

-(void)initTable
{
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.table registerNib:[UINib nibWithNibName:@"AddDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTableViewCell"];
    [self.table registerNib:[UINib nibWithNibName:@"AddDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDetailTwoTableViewCell"];
    
    
    if ([self.typeString isEqualToString:@"detail"]) {
        
    }else
    {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
        self.table.tableFooterView = footView;
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 20, screen_width-100, 40)];
        addButton.backgroundColor = navigationBarColor;
        [addButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:addButton];
    }
    
}

-(void)buttonClick
{
   
    
    if ([self.typeString isEqualToString:@"detail"]) {
        
        [SVProgressHUD showWithStatus:@"加载中"];
        NSDictionary *jsonDic;
        
        if (self.screat.length == 0 ) {
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"CMS_Accounts",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Account_No":_phoneNumber,@"Account_Name":_name,@"IsRoomAdd":_addRoom,@"IsGoodsAdd":_addGood,@"IsSystemSet":_systemSet,@"IsMemberManager":self.memberManage,@"IsCashManager":self.cashManage,@"IsPriceChange":self.changeMoney,@"IsDiscount":self.discountSettle,@"IsFree":self.zengSong,@"IsMoling":self.Moling,@"IsLock":self.freezeAccount,@"IsReportManager":self.isReport}]};
            
        }else{
            if ([self.screat isEqualToString: self.sureScreat]) {
                
 jsonDic=@{ @"Command":@"Edit",@"TableName":@"CMS_Accounts",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Account_No":_phoneNumber,@"Account_Name":_name,@"PassWord":_screat,@"IsRoomAdd":_addRoom,@"IsGoodsAdd":_addGood,@"IsSystemSet":_systemSet,@"IsMemberManager":self.memberManage,@"IsCashManager":self.cashManage,@"IsPriceChange":self.changeMoney,@"IsDiscount":self.discountSettle,@"IsFree":self.zengSong,@"IsMoling":self.Moling,@"IsLock":self.freezeAccount,@"IsReportManager":self.isReport}]};
                
            }else
            {
                [self alertShowWithStr:@"修改的密码输入不一致，请重新输入。。。"];
            }
        }

        
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",jsonStr);
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

        
        
        
        
        
        
    }else
    {
        if (self.name.length == 0 ||self.phoneNumber.length == 0 || self.screat.length == 0 || self.sureScreat.length == 0) {
            [self alertShowWithStr:@"信息输入不完整。。"];
        }else
        {
            if ([self.screat isEqualToString:self.sureScreat]) {
                [SVProgressHUD showWithStatus:@"加载中"];
                NSDictionary *jsonDic;
            jsonDic=@{ @"Command":@"Add",@"TableName":@"CMS_Accounts",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Account_No":_phoneNumber,@"Account_Name":_name,@"PassWord":_screat,@"IsRoomAdd":_addRoom,@"IsGoodsAdd":_addGood,@"IsSystemSet":_systemSet,@"IsMemberManager":self.memberManage,@"IsCashManager":self.cashManage,@"IsPriceChange":self.changeMoney,@"IsDiscount":self.discountSettle,@"IsFree":self.zengSong,@"IsMoling":self.Moling,@"IsLock":self.freezeAccount,@"IsReportManager":self.isReport}]};
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
                
            }else
            {
                [self alertShowWithStr:@"密码输入不一致，请重新输入!"];
            }

        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _title1.count;
    }else if (section == 1)
    {
        return _title2.count;
    }else
    {
        return _title3.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDetailTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        }
        cell.nameLable.text = self.title1[indexPath.row];
        cell.nameLable.font = [UIFont systemFontOfSize:13];
        cell.nameLable.textAlignment = NSTextAlignmentCenter;
        
        [self getCellDataWithCell:cell index:indexPath.row];
        
        cell.inputText.delegate = self;
        cell.inputText.tag = indexPath.row;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 2) {
            if ([self.typeString isEqualToString:@"detail"]) {
                cell.inputText.placeholder = @"请输入新密码";
            }
        }
        if (indexPath.row == 3) {
            if ([self.typeString isEqualToString:@"detail"]) {
                cell.inputText.placeholder = @"请再次输入新密码";
            }
        }
        
        return cell;
    }else if(indexPath.section == 1)
    {
        AddDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDetailTwoTableViewCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        }

        cell.titleLable.text = self.title2[indexPath.row];
        
        [self getStateWithCell:cell index:indexPath.row];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else
    {
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        __weak typeof(self)weakSelf = self;
        cell.titleLable.text = self.title3[0];
        cell.Twidth.constant=110;
        if ([self.typeString isEqualToString:@"detail"]) {
            if ([self.freezeAccount isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 1;
        }

        cell.statuseBlock = ^(NSString *string){
            weakSelf.freezeAccount = string;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.inputText.text = self.phoneNumber;
            cell.inputText.keyboardType = UIKeyboardTypePhonePad;
            
        }
            break;
        case 2:
        {
            
            cell.inputText.text = self.screat;
            
        }
            break;
        case 3:
        {
            cell.inputText.text = self.sureScreat;
            
        }
            break;
    
        default:
            break;
    }
}

-(void)getStateWithCell:(AddDetailTwoTableViewCell *)cell index:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.addRoom isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.addRoom = string ;
            };
        }
            break;
        case 1:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.addGood isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.addGood = string ;
            };
        }
            break;
        case 2:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.systemSet isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.systemSet = string ;
            };
        }
            break;
        case 3:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.memberManage isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.memberManage = string ;
            };
        }
            break;
        case 4:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.cashManage isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.cashManage = string ;
            };
        }
            break;
        case 5:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.changeMoney isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.changeMoney = string ;
            };
        }
            break;
        case 6:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.isReport isEqualToString:@"True"])
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
            
            cell.statuseBlock = ^(NSString *string){
                self.isReport = string ;
            };
        }
            break;
        case 7:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.discountSettle isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.discountSettle = string ;
            };
        }
            break;
        case 8:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.zengSong isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.zengSong = string ;
            };
        }
            break;
        case 9:
        {
            if ([self.typeString isEqualToString:@"detail"]) {
                if ([self.Moling isEqualToString:@"True"])
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

            cell.statuseBlock = ^(NSString *string){
                self.Moling = string ;
            };
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.1;
    }else
    {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }else
    {
        return 10;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"配置收银员权限";
    }
     return @"";
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 0:
        {
            self.name = textField.text;
        }
            break;
        case 1:
        {
            self.phoneNumber = textField.text;
        }
            break;
            
        case 2:
        {
            self.screat = textField.text;
        }
            break;
        case 3:
        {
            self.sureScreat = textField.text;
        }
            break;
            
        default:
            break;
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
