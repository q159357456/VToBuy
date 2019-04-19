//
//  TypeSetView.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/15.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "TypeSetView.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "AddDetailTableViewCell.h"
#import "ChooseView.h"
#import "CoverView.h"
#import "FloorModel.h"
#import "TreeTableView.h"
@interface TypeSetView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)ChooseView *chooseView;
@property(nonatomic,copy)NSString *areaNo;
@property(nonatomic,strong)TreeTableView *treeTable;
@property(nonatomic,strong)ClassifyModel *classifymodel;
@end
@implementation TypeSetView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius=4;
        self.layer.masksToBounds=YES;
        _model=[[FMDBMember shareInstance]getMemberData][0];
    }
    return self;
}
-(void)setDoneButton:(UIButton *)doneButton
{
    _doneButton=doneButton;

}
-(void)setFunType:(NSString *)funType
{
    _funType=funType;
    if ([_funType isEqualToString:@"comb"])
    {
        //创建套餐
         _titleArray=@[@"套餐名称",@"套餐所属分类"];
        
    }else
    {
        //创建房台类型
         _titleArray=@[@"类型名称",@"类型所属区域"];
        
    }
}

-(void)setTableview:(UITableView *)tableview
{
    _tableview=tableview;
    _tableview.delegate=self;
    _tableview.dataSource=self;
}
#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
    AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
    }
    cell.inputText.tag=indexPath.row+1;
    cell.inputText.delegate=self;
    cell.nameLable.font=[UIFont systemFontOfSize:13];
    cell.nameLable.text=_titleArray[indexPath.row];
    [self jugeTypeWithCell:cell cellForRowAtIndexPath:indexPath];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)jugeTypeWithCell:(AddDetailTableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_funType isEqualToString:@"comb"])
    {
        
        if (indexPath.row==0)
        {
            cell.inputText.placeholder=@"输入套餐名称...";
            [cell.inputText becomeFirstResponder];

        }else
        {
            cell.inputText.enabled=NO;
            cell.inputText.text=@"点击选择所属分类";
        }
        
        
    }else
    {
        if (_roomModel)
        {
            //编辑
            if (indexPath.row==0)
            {
                cell.inputText.text=_roomModel.RoomName;
            }else
            {
                cell.inputText.enabled=NO;
                cell.inputText.text=_roomModel.AF002;
                self.areaNo=_roomModel.roomArea;
                
            }
            
            
        }else
        {
            //增加
            if (indexPath.row==0)
            {
                cell.inputText.placeholder=@"输入类型例如包间....";
                [cell.inputText becomeFirstResponder];
            }else
            {
        
                if (self.floorNo.length)
                {
                    cell.inputText.enabled=NO;
                    _areaNo=_floorNo;
                    
                    cell.inputText.text=_floorName;
                    
                }else
                {
                    cell.inputText.enabled=NO;
                    cell.inputText.text=@"选择区域";
                }
                
                
            }
            
        }

    
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        [self endEditing:YES];
         if ([_funType isEqualToString:@"comb"])
         {
             [self getClassify];
         }else
         {
             //加入楼层
             _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
             _chooseView=[[NSBundle mainBundle]loadNibNamed:@"ChooseView" owner:nil options:nil][0];
             DefineWeakSelf;
             _chooseView.backBlock=^(FloorModel *model){
                 [weakSelf.coverView removeFromSuperview];
                 UITextField *textfield=(UITextField*)[weakSelf viewWithTag:2];
                 textfield.text=model.FloorInfo;
                 weakSelf.areaNo=model.itemNo;

             };
             [_coverView addSubview:_chooseView];
             [_chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
                 
                 make.centerX.mas_equalTo(_coverView.mas_centerX);
                 make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-20);
                 make.width.mas_equalTo(_coverView.mas_width).multipliedBy(0.8);
                 make.height.mas_equalTo(_coverView.mas_height).multipliedBy(0.7);
             }];
             [self.superview addSubview:_coverView];
         }
       

    }
    
}
-(UIView*)getFootview
{
    UIView *buttView=[[UIView alloc]initWithFrame:CGRectMake(30, 84+screen_height*0.7, screen_width-60, 50)];
    buttView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(20,5, buttView.width-40,40);
    button.backgroundColor=MainColor;
    button.layer.cornerRadius=8;
    [button setTitle:@"确认选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttClick) forControlEvents:UIControlEventTouchUpInside];
    [buttView addSubview:button];
    return buttView;
    
}
-(void)buttClick
{
    
    [_treeTable removeFromSuperview];
    [_coverView removeFromSuperview];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (IBAction)done:(UIButton *)sender
{
          if ([_funType isEqualToString:@"comb"])
          {
                 UITextField *textfield=(UITextField*)[self viewWithTag:1];
              if (self.classifymodel&&textfield.text.length) {
                  self.combBlock(self.classifymodel,textfield.text);
                  [self removeFromSuperview];
              }else
              {
                  [SVProgressHUD setMinimumDismissTimeInterval:1];
                  [SVProgressHUD showErrorWithStatus:@"必填信息不能为空"];
              }
              
          }else
              
          {
              
              [self upTypeInfo];
          }
    
}
-(void)getClassify
{

    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",model.SHOPID,model.COMPANY];
    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        [self creatClssifyTableWithClassifyArray:[ClassifyModel getDataWithDic:dic1]];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)creatClssifyTableWithClassifyArray:(NSMutableArray *)array
{
    //加入选类别
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.superview addSubview:_coverView];
    _treeTable = [[TreeTableView alloc] initWithFrame:CGRectMake(30, 84,screen_width-60, screen_height*0.7 ) withData:array];
   
    [_coverView addSubview:[self getFootview]];

    [_coverView addSubview:_treeTable];
    DefineWeakSelf;
    _treeTable.backBlock=^(ClassifyModel *model){
        if (model.selected)
        {
            
              weakSelf.classifymodel=model;
        }else
        {
              weakSelf.classifymodel=nil;
        }
        UITextField *textfield=(UITextField*)[weakSelf viewWithTag:2];
        textfield.text=weakSelf.classifymodel.classifyName;
      
    };
    

}
-(void)upTypeInfo
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
   UITextField *textfield=(UITextField*)[self viewWithTag:1];
    if (textfield.text.length>0&&_areaNo.length>0)
    {
        NSDictionary *jsonDic;
        if (_roomModel)
        {
            
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":textfield.text,@"ST001":self.roomModel.itemNo,@"ST005":_areaNo}]};
        }else
        {
            
            jsonDic=@{ @"Command":@"Add",@"TableName":@"POSST",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"ST002":textfield.text,@"ST005":self.areaNo}]};
        }
        
        
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            
            
            NSString *str=[JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"OK"])
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backBlock();
                    [self removeFromSuperview];
                    [SVProgressHUD dismiss];
                });
            }else
            {
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
            }
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

    }else
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"必填资料不能为空"];
    }
   
}

@end
