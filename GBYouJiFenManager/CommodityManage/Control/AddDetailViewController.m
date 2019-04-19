//
//  AddDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/4/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddDetailViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface AddDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,copy)NSArray *titleArray;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *statuse;

@end

@implementation AddDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets=NO;
    self.statuse=@"true";
    if ( [self.funType isEqualToString:@"Edit"])
    {
        //编辑
          _titleArray=@[@"原分类名称",@"分类名称",@"分类编号"];
       
        
    }else
    {
        //增加
          _titleArray=@[@"上级分类",@"分类名称"];
       
    }

    self.doneButton.backgroundColor=MainColor;

    // Do any additional setup after loading the view from its nib.
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row<=_titleArray.count-1)
    {
         static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        }
        cell.inputText.delegate=self;
        cell.inputText.tag=indexPath.row+1;
        if (indexPath.row==0) {

            cell.inputText.enabled=NO;
            NSLog(@"-----%@",self.clssiModel);
            if (!self.clssiModel.classifyNo.length)
            {
                //最上层
                cell.inputText.text=@"根目录";
                
            }else
            {
                cell.inputText.text=self.clssiModel.classifyName;
            }

            
        }
        if (indexPath.row==1) {
             cell.inputText.text=self.name;
        }
          if ( [self.funType isEqualToString:@"Edit"])
          {
              //编辑模式
              if (indexPath.row==2) {
                  cell.inputText.text=self.clssiModel.classifyNo;
                  cell.inputText.enabled=NO;
              }
              
          }
        cell.nameLable.text=_titleArray[indexPath.row];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;

        
    }else
    {
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.textLabel.text=@"有效否";
        cell.statuseBlock=^(NSString *str){
            weakSelf.statuse=str;
             NSLog(@"%@",weakSelf.statuse);
            
        };
        return cell;
        
    }
    return nil;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark textfield
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 1:
        {
            //分类方式
            
        }
            break;
        case 2:
        {
            //分类名称
            self.name=textField.text;
        }
            break;
        case 3:
        {
            //上级分类
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (IBAction)done:(UIButton *)sender
{
    //上传信息
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    if ( [self.funType isEqualToString:@"Edit"])
    {
        //编辑
        [self editClassify];
      
    }else
    {
        //增加
        [self addClassify];
    }
}
-(void)addClassify
{
    NSDictionary *jsonDic;
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
 
    if (self.clssiModel.classifyNo.length==0)
    {
        jsonDic=@{@"Command":@"Add",@"TableName":@"Inv_Classify",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ClassifyName":self.name,@"Status":self.statuse,@"ParentNo":@"",@"UDF01":@"0"}]};
    }else
    {
        self.clssiModel.depth++;
        jsonDic=@{@"Command":@"Add",@"TableName":@"Inv_Classify",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ClassifyName":self.name,@"Status":self.statuse,@"ParentNo":self.clssiModel.classifyNo,@"UDF01":[NSString stringWithFormat:@"%d",self.clssiModel.depth]}]};
    }
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSString *str=[JsonTools getNSString:responseObject];
        //        NSLog(@"----%@",str);
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
            [self alertShowWithStr:@"添加失败"];
        }
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    

}
-(void)editClassify
{
    //编辑信息
    NSDictionary *jsonDic;
     MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];

    jsonDic=@{@"Command":@"Edit",@"TableName":@"Inv_Classify",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"ClassifyName":self.name,@"Status":self.clssiModel.Status,@"ParentNo":self.clssiModel.classifyNo,@"ClassifyNo":self.clssiModel.classifyNo}]};
        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"--%@",jsonStr);
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSString *str=[JsonTools getNSString:responseObject];
            if ([str isEqualToString:@"OK"])
            {
                self.backBlock();
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [self alertShowWithStr:str];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
