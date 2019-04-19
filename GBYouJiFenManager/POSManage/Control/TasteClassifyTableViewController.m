
//  TasteClassifyTableViewController.m
//  GBYouJiFenManager
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 xia. All rights reserved.


#import "TasteClassifyTableViewController.h"
#import "ChooseTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface TasteClassifyTableViewController ()
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@end

@implementation TasteClassifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    self.conitionStr = [NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
    
    [self initButton];
    
    [self initArray];

    [self getClassify];
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),0)];
    self.tableView.tableFooterView = v;
    [self.tableView dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];
}

-(void)initArray
{
    self.selectArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.ClassifyArray = [NSMutableArray array];
}

-(void)getClassify
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"玩命加载中"];
    NSDictionary *dic;
    if (_tagNum == 300 || _tagNum == 918) {
        dic = @{@"FromTableName":@"Inv_classify",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 301){
         dic = @{@"FromTableName":@"CMS_Menu",@"SelectField":@"*",@"Condition":@"ParentPnoNo$=$QT",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 302){
        dic = @{@"FromTableName":@"CMS_Role",@"SelectField":@"*",@"Condition":_conitionStr,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    if (_tagNum == 303){
        dic = @{@"FromTableName":@"CMS_Menu",@"SelectField":@"*",@"Condition":@"ParentPnoNo$=$QT",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    }
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        if (_tagNum == 300|| _tagNum == 918) {
            _dataArray = [TasteClassifyModel getDataWithDic:dic1];
        }
        if (_tagNum == 301) {
            _dataArray = [MenuFunctionModel getDataWithDic:dic1];
        }
        
        if (_tagNum == 302) {
            _dataArray = [QianTainRoleModel getDataWithDic:dic1];
        }
        
        if (_tagNum == 303) {
            _dataArray = [MenuFunctionModel getDataWithDic:dic1];
        }
        
        
        [self.tableView reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)initButton
{
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    
    [selectedBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    self.navigationItem.rightBarButtonItem =selectItem;
}

-(void)selectedBtn:(UIButton *)btn
{
    if (_tagNum == 300 || _tagNum == 918) {
        if (self.selectArray.count>0) {
            self.backBlock(self.selectArray);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择口味分类"];
        }
    }
    
    if (_tagNum == 301) {
        if (self.selectArray.count>0) {
            self.backBlock(self.selectArray);
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择菜单功能"];
        }
    }
    
    if (_tagNum == 302) {
        if (self.selectArray.count>0) {
            self.backBlock(self.selectArray);
            //创建通知
            
            NSMutableDictionary *dicRole = [NSMutableDictionary dictionary];
            for (int i = 0; i<self.selectArray.count; i++) {
                [dicRole setObject:self.selectArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            NSNotification *notification1 = [NSNotification notificationWithName:@"InfoOfRole" object:self userInfo:dicRole];
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择角色"];
        }
    }
    
    if (_tagNum == 303) {
        if (self.selectArray.count>0) {
            self.backBlock(self.selectArray);
            
            NSMutableDictionary *dicMenu = [NSMutableDictionary dictionary];
            for (int i = 0; i<self.selectArray.count; i++) {
                [dicMenu setObject:self.selectArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            NSNotification *notification2 = [NSNotification notificationWithName:@"InfoOfMenu" object:self userInfo:dicMenu];
            [[NSNotificationCenter defaultCenter] postNotification:notification2];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [self alertShowWithStr:@"请选择菜单功能"];
        }
    }

    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    cell.contentLable.font = [UIFont systemFontOfSize:13];
    if (_tagNum == 300||_tagNum == 918) {
        TasteClassifyModel *model = _dataArray[indexPath.row];
        cell.contentLable.text= model.classifyName;
    }
    if (_tagNum == 301) {
        MenuFunctionModel *model = _dataArray[indexPath.row];
        cell.contentLable.text = model.Pna;
    }
    if (_tagNum == 302) {
        QianTainRoleModel *model = _dataArray[indexPath.row];
        cell.contentLable.text = model.RoleNa;
    }
    
    if (_tagNum == 303) {
        MenuFunctionModel *model = _dataArray[indexPath.row];
        cell.contentLable.text = model.Pna;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 [self.selectArray addObject:[self.dataArray objectAtIndex:indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
[self.selectArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"删除表数据");
       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"取消选择的cell数据");
    }
}

-(void)alertShowWithStr:(NSString*)str
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
