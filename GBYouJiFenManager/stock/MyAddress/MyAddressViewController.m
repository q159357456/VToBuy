//
//  MyAddressViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MyAddressViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "AddressTableViewCell.h"
#import "AddressChooseTableViewCell.h"
#import "addAddressViewController.h"
@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conditionStr;
@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataArray = [NSMutableArray array];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    self.conditionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    if ([self.ChooseType isEqualToString:@"choose"]) {
        
    }else
    {
        [self createBottomBtn];
    }
    
    [self initTable];
    
    [self getAllAddress];
    
    
}

-(void)judge
{
    //判断默认地址是否被删除了  如果默认地址删除了 就将数组的第一个地址作为默认地址
    NSMutableArray *array = [NSMutableArray array];
    for (addressModel *sModel in _dataArray) {
        if ([sModel.defaultAddress isEqualToString:@"True"]) {
            [array addObject:sModel];
        }
    }
    if (array.count>0) {
        [_table reloadData];
    }else
    {
        addressModel *mModel = _dataArray[0];
        mModel.defaultAddress = @"True";
        [self editWithModel:mModel];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_table reloadData];
        });
    }

}

-(void)getAllAddress
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_MyAddress",@"SelectField":@"*",@"Condition":_conditionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        self.dataArray = [addressModel getDataWithDic:dic1];
        
        //数组排序
        NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"defaultAddress" ascending:YES]];
        [_dataArray sortUsingDescriptors:sortArr];
        
        _dataArray = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
        
        [self judge];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initTable
{
    if ([self.ChooseType isEqualToString:@"choose"]) {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    }else
    {
       self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, screen_width, screen_height-110) style:UITableViewStylePlain];
    }
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.table registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self.table registerNib:[UINib nibWithNibName:@"AddressChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressChooseTableViewCell"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    self.table.tableFooterView = v;
    
    [self.view addSubview:_table];
}

#pragma UITableView的代理方法的实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择地址时显示的cell
    if ([self.ChooseType isEqualToString:@"choose"]) {
        
        static NSString *cellID = @"AddressChooseTableViewCell";
        AddressChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddressChooseTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        addressModel *aModel = _dataArray[indexPath.row];
        cell.nameLabel.text = aModel.contact;
        cell.numberLabel.text = aModel.mobile;
        if ([aModel.defaultAddress isEqualToString:@"True"]) {
            NSString *str = [NSString stringWithFormat:@"【默认地址】%@%@",aModel.area,aModel.address];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:220/255.0 green:20/255.0 blue:60/255.0 alpha:1] range:NSMakeRange(0,6)];
            cell.addressLabel.attributedText = string;
        }else{
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",aModel.area,aModel.address];
        }
        
        return cell;
        
    }else
    {
        //新添加地址时显示的cell
        static NSString *cellID = @"AddressTableViewCell";
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        addressModel *addrModel = self.dataArray[indexPath.row];
        
        if ([addrModel.defaultAddress isEqualToString:@"True"])
        {
            cell.selectBtn.backgroundColor=navigationBarColor;
            cell.defaultLabel.text = @"默认地址";
            cell.defaultLabel.textColor = [UIColor redColor];
        }else
        {
            
            cell.selectBtn.backgroundColor=[UIColor whiteColor];
            cell.defaultLabel.text = @"设为默认";
            cell.defaultLabel.textColor = [UIColor lightGrayColor];
        }
        cell.nameLabel.text = addrModel.contact;
        cell.mobileLabel.text = addrModel.mobile;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",addrModel.area,addrModel.address];
        cell.setDefaultBlock = ^{
            
            for (addressModel *ssModel in _dataArray) {
                if ([ssModel.defaultAddress isEqualToString:@"True"]) {
                    ssModel.defaultAddress = @"False";
                }
                
                [self editWithModel:ssModel];
            }
            
            addrModel.defaultAddress = @"True";
            [self editWithModel:addrModel];
            
         
        };
        cell.deleteBlock = ^{
            
            [SVProgressHUD showWithStatus:@"加载中"];
            NSDictionary *jsonDic;
            
            jsonDic=@{ @"Command":@"Del",@"TableName":@"CMS_MyAddress",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"Contact":addrModel.contact,@"Mobile":addrModel.mobile,@"Area":addrModel.area,@"Address":addrModel.address,@"ID":addrModel.ID,@"MemberNo":addrModel.MemberNo}]};
            NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonStr);
            NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
            [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                
                NSString *str=[JsonTools getNSString:responseObject];
                
                if ([str isEqualToString:@"OK"])
                {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self getAllAddress];
                        [SVProgressHUD dismiss];
                        
                });
                    
                }else
                {
                    [SVProgressHUD dismiss];
                    
                    [self alertShowWithString:str];
                }
                
            } Faile:^(NSError *error) {
                NSLog(@"失败%@",error);
            }];
            
            
            
            
        };
        cell.editBlock = ^{
            
            addAddressViewController *addr = [[addAddressViewController alloc] init];
            addr.title = @"编辑地址";
            addr.chooseType = @"Edit";
            addr.addressModel = addrModel;
            addr.backBlock = ^{
                [self getAllAddress];
            };
            [addr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:addr animated:YES];
        };
        
        
        return cell;

    }
  
}


-(void)alertShowWithString:(NSString *)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
     [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ChooseType isEqualToString:@"choose"]) {
        return 100.0f;
    }else
    {
        return 140.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

            addressModel *model=_dataArray[indexPath.row];
    if ([self.ChooseType isEqualToString:@"choose"])
    {
        self.backBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        return;
    }
    
    
    
}

#pragma 按钮响应事件

- (void)btnClick {
    
    addAddressViewController *add = [[addAddressViewController alloc] init];
    add.title = @"新建地址";
    add.backBlock = ^{
        [self getAllAddress];
    };
    [add setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:add animated:YES];
    
}

-(void)createBottomBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, screen_height-50, screen_width, 50);
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    btn.backgroundColor = MainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


-(void)editWithModel:(addressModel *)ccmodel
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *jsonDic;
    
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"CMS_MyAddress",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"Contact":ccmodel.contact,@"Mobile":ccmodel.mobile,@"Area":ccmodel.area,@"Address":ccmodel.address,@"DefaultAddr":ccmodel.defaultAddress,@"ID":ccmodel.ID,@"MemberNo":ccmodel.MemberNo}]};
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"CipherText":CIPHERTEXT,@"bPhoto":@""};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        
        if ([str isEqualToString:@"OK"])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                [SVProgressHUD dismiss];
                [self.table reloadData];
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
-(void)dealloc
{
    NSLog(@"地址释放");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
