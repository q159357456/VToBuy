//
//  EvaluatmanagViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "EvaluatmanagViewController.h"
#import "EvaluatmanagTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "evaluatModel.h"
#import "AnswerViewController.h"
#import "ZWHMaintainViewController.h"


@interface EvaluatmanagViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)PlaceholderView *placeView;
@end

@implementation EvaluatmanagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model=[[FMDBMember shareInstance]getMemberData][0];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    [self getData];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithTitle:@"基础维护" target:self action:@selector(zwhMaintain)];
    self.navigationItem.rightBarButtonItem = item;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"evaluatrefresh" object:nil];
}

#pragma mark - 基础维护
-(void)zwhMaintain{
    ZWHMaintainViewController *vc = [[ZWHMaintainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
-(void)getData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"A.shopid$=$%@",self.model.SHOPID];
    //CRM_Evaluation[A]||crmMS[B]{left (A.shopid=B.shopid and A.MemberNo=B.MS001 and A.company=B.company)}
    NSDictionary *dic=@{@"FromTableName":@"CRM_Evaluation[A]||crmMS[B]{left (A.MemberNo=B.MS001)}",@"SelectField":@"A.*,B.MS002",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _dataArray=[evaluatModel getDataWithDic:dic1];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    evaluatModel *model=_dataArray[indexPath.section];
    static NSString *EvaluatmanagTableViewCell_ID = @"EvaluatmanagTableViewCell";
    EvaluatmanagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EvaluatmanagTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"EvaluatmanagTableViewCell" owner:nil options:nil][0];
    }
  
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf=self;
    cell.answerBlock=^{
        AnswerViewController *ans=[[AnswerViewController alloc]init];
        ans.title=@"回复";
        ans.model=model;
        [weakSelf.navigationController pushViewController:ans animated:YES];
    };
    [cell setDataWithModel:model];
    return cell;
    
 
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    evaluatModel *model=_dataArray[indexPath.section];
    
    return 78+model.height+1+model.AnswerHeight+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
