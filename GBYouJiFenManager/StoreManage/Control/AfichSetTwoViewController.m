//
//  AfichSetTwoViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/19.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AfichSetTwoViewController.h"
#import "AflchSetTableViewCell.h"
#import "AfichSetViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "AfivchModel.h"
@interface AfichSetTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)PlaceholderView *placeView;

@end

@implementation AfichSetTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    _doneButton.backgroundColor=MainColor;
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Notice",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _dataArray=[AfivchModel getDataWithDic:dic1];
        if (_dataArray.count)
        {
            if ([self.view.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.tableview reloadData];
            
        }else
        {
            [self.view addSubview:self.placeView];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
#pragma mark--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AfivchModel * model=_dataArray[indexPath.section];
    static NSString *AddDetailTableViewCell_ID = @"StoreTwoTableViewCell";
    AflchSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AflchSetTableViewCell" owner:nil options:nil][0];
    }
    cell.height.constant=model.height;
    cell.titleLable.text=[NSString stringWithFormat:@"标题:%@",model.Title];
    cell.contentLable.text=[NSString stringWithFormat:@"   %@",model.Msg];
    cell.contentLable.numberOfLines = 0;
    cell.contentLable.lineBreakMode = NSLineBreakByWordWrapping;
    cell.timeLable.text=model.CREATE_DATE;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf=self;
    cell.editBlock=^{
        AfichSetViewController *comm=[[AfichSetViewController alloc]init];
        comm.backBlock=^{
            [weakSelf getData];
        };
        comm.title=@"编辑公告";
        comm.type=@"edit";
        comm.model=model;
        
        [comm setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:comm animated:YES];
    };
    cell.deleteBlock=^{
        NSLog(@"删除");
        [weakSelf dedetModelWithModel:model];
    };
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AfivchModel * model=_dataArray[indexPath.section];
    return 20+model.height+50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"223");
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)dedetModelWithModel:(AfivchModel*)amodel
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Del",@"TableName":@"CMS_Notice",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"Title":amodel.Title,@"Msg":amodel.Msg,@"ID":amodel.ID}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"%@",str);
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [SVProgressHUD dismiss];
                [self getData];
            });
            
        }else
        {
            [SVProgressHUD dismiss];
            
            [self alertShowWithStr:@"上传失败,稍后再试"];
            
            
        }
        
        
    } Faile:^(NSError *error) {
       
      
        NSLog(@"失败%@",error);
    }];
    
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)done:(UIButton *)sender {
    AfichSetViewController *comm=[[AfichSetViewController alloc]init];
    comm.title=@"公告设置";
      __weak typeof(self)weakSelf=self;
    comm.backBlock=^{
        [weakSelf getData];
    };
    comm.type=@"add";
    [comm setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:comm animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
