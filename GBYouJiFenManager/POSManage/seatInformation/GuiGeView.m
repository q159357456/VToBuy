//
//  GuiGeView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/28.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "GuiGeView.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "POSDIModel.h"
#import "ReasonTableViewCell.h"
@interface GuiGeView()<UITableViewDelegate,UITableViewDataSource>
    
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)PlaceholderView *placeView;
@property (strong, nonatomic) IBOutlet UILabel *sepaLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@end
@implementation GuiGeView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
    {
        self=[super initWithCoder:aDecoder];
        if (self) {
          
            [self getData];
        }
        return self;
        
}
-(void)setTitleLable:(UILabel *)titleLable
{
    _titleLable=titleLable;
    _titleLable.textColor=navigationBarColor;
}
-(void)setSepaLable:(UILabel *)sepaLable
{
    _sepaLable=sepaLable;
    _sepaLable.backgroundColor=navigationBarColor;
}
-(PlaceholderView *)placeView
{
    if (!_placeView) {
        _placeView=PLACEVIEW;
        _placeView.frame=self.tableview.frame;
    }
    return _placeView;
}
-(void)setTableview:(UITableView *)tableview
    {
        _tableview=tableview;
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableview.delegate=self;
        _tableview.dataSource=self;
        
    }
-(void)setDoneButton:(UIButton *)doneButton
    {
        _doneButton=doneButton;
        
        [_doneButton border:1 color:[UIColor groupTableViewBackgroundColor]];
    }
-(void)getData
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$B.DC003$=$",model.COMPANY,model.SHOPID];
    NSDictionary *dic=@{@"FromTableName":@"POSDI[A]||POSDC[B]{inner (A.company=B.company and A.shopid=B.shopid and A.DI003=B.DC001)}",@"SelectField":@"A.*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
     NSLog(@"-----%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
       
        self.dataArray=[POSDIModel getDatawithdic:dic1];
      
        if (_dataArray.count)
        {
            if ([self.subviews containsObject:self.placeView]) {
                [self.placeView removeFromSuperview];
            }
            [self.tableview reloadData];
            
        }else
        {
            
            [self  addSubview:self.placeView];
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
 
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString *cellID = @"WorkerGroupTableViewCell";
    ReasonTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ReasonTableViewCell" owner:nil options:nil][0];
    }
    POSDIModel *model=self.dataArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (model.isSelected==YES)
    {
        cell.selectImage.image=[UIImage imageNamed:@"slected_2"];
        
    }else
    {
        cell.selectImage.image=[UIImage imageNamed:@"slected_1"];
    }
    cell.resonLable.text=model.DI002;
    
    return cell;
   
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    POSDIModel *model=self.dataArray[indexPath.row];
    model.isSelected=!model.isSelected;
    [self.tableview reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        return 50;
        
        
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
    
    
}
    
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (IBAction)done:(UIButton *)sender {

    NSMutableArray *posArray=[NSMutableArray array];
    NSMutableArray  *posNameArray=[NSMutableArray array];
    for (POSDIModel *model in self.dataArray) {
        if (model.isSelected) {
            
            [posArray addObject:model.DI001];
            [posNameArray addObject:model.DI002];
        }
    }
    NSString *noStr=[posArray componentsJoinedByString:@";"];
    noStr=[noStr stringByAppendingString:@";"];
    NSString *nameStr=[posNameArray componentsJoinedByString:@";"];
    nameStr=[nameStr stringByAppendingString:@";"];
    
    if ([noStr isEqualToString:@";"]) {
        noStr = @"";
    }
    if ([nameStr isEqualToString:@";"]) {
        nameStr = @"";
    }
    self.guigeBlock(nameStr,noStr);
    [self removeFromSuperview];
}
    


@end
