//
//  BuyDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/6/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "ChooseTableViewCell.h"
#import "AddDetailTableViewCell.h"
#import "PayDetailOneTableViewCell.h"
#import "PayDetailTwoTableViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "SBPModel.h"
#import "BuyRecordeView.h"
#import "PcModel.h"
#import "ScoreTableViewCell.h"
@interface BuyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *totalprice;
@property(nonatomic,strong)NSArray *payArray;
@end

@implementation BuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    _model=[[FMDBMember shareInstance]getMemberData][0];
    if (_pmodel.SB023.floatValue>=0) {
           [self addRightButton];
    }
 
    [self getPayDetailWithString:_pmodel.SB002];
   
    // Do any additional setup after loading the view from its nib.
}
-(void)addRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"退款" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)commit
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退款吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tuikuan];
    }];
    [alert addAction:action];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];

    
}
-(void)tuikuan{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dic=@{@"billno":_pmodel.SB002,@"CipherText":CIPHERTEXT};
//    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/MallService.asmx/MallQuitBill" With:dic and:^(id responseObject) {
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"0"])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"退款成功"];
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
        
    }];

}

-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
//获得支付详情
-(void)getPayDetailWithString:(NSString *)str
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$PC002$=$%@",_model.COMPANY,_model.SHOPID,str];
    NSDictionary *dic=@{@"FromTableName":@"POSPC",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    NSLog(@"详情---%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"详情---%@",dic1);
        self.payArray=[PcModel getDataWithDic:dic1];
//       NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [self.tableview reloadSections:indexSet withRowAnimation:NO];
        [self.tableview reloadData];
        [self getDetailDingDanWithString:_pmodel.SB002];
        
    } Faile:^(NSError *error) {
        
    }];

}
//通过订单号获取商品明细并调整结构
-(void)getDetailDingDanWithString:(NSString *)str
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SBP002$=$%@",_model.COMPANY,_model.SHOPID,str];
    NSDictionary *dic=@{@"FromTableName":@"POSSBP",@"SelectField":@"SBP005,SBP009,SBP010,SBP011,SBP004,SBP003,SBP026,SBP027,SBP016,SBP017,SBP032,SBP014,SBP015,PSQuantity,TFQuantity",@"Condition":condition,@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":@"6you7QLfbASAFzt0HYAaRJA4yHwAIS4uY3OmqkaeXsSdjcP8cEBrQQ=="};
 
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
         NSLog(@"---%@",dic1);
        self.dataArray=[SBPModel getDataWithDic:dic1];
         [self getTotalPrice];
      
     
    } Faile:^(NSError *error) {
        
    }];

}
-(void)getTotalPrice
{
    NSString *conditinStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB002$=$%@",_model.COMPANY,_model.SHOPID,_pmodel.SB002];
    
    NSDictionary*dic=@{@"FromTableName":@"possb",@"SelectField":@"SB023,SB009,SB016,SB005",@"Condition":conditinStr,@"SelectOrderBy":@"",@"SelectGroupBy":@"",@"HavingCondition":@"",@"PageNumber":@"0",@"PageSize":@"0",@"CipherText":CIPHERTEXT};
    
  
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo1" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
       
        
        NSArray *array=dic1[@"DataSet"][@"Table"];
        if (array.count) {
         self.totalprice=dic1[@"DataSet"][@"Table"][0][@"SB023"];
        }
         [self getAllData];
     
    } Faile:^(NSError *error) {
        
    }];
}
#pragma mark--获取时间
-(NSString *)getTime
{
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"BusinessDate"];
    NSArray *timeArray=[time componentsSeparatedByString:@","];
    return timeArray[1];
}
-(void)getAllData
{
    //主键数据
    _productArray=[NSMutableArray array];
    for (SBPModel *model in _dataArray) {
        
        if (model.SBP027.intValue==0) {
            [_productArray addObject:model];
        }
    }
    //子件加入主键
    for (SBPModel *model in _productArray) {
        for (SBPModel *model2 in _dataArray) {
            if (model2.SBP027.intValue==model.SBP003.intValue) {
                [model.sonProductArray addObject:model2];
            }
        }
    }

    for (SBPModel *model in _productArray) {
        [self getModelDataWithModel:model];
    }
//    NSLog(@"----%ld",_productArray.count);
    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:2];
     NSIndexPath *path1=[NSIndexPath indexPathForRow:1 inSection:2];
    [self.tableview reloadRowsAtIndexPaths:@[path,path1] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)getModelDataWithModel:(SBPModel*)model
{
    
    //套餐
    if (model.sonProductArray.count>0) {
        
        for (SBPModel *pmodel in model.sonProductArray) {
            
            
            NSString *str=[NSString stringWithFormat:@"+%@X%@",pmodel.SBP005,[pmodel.SBP009 removeZeroWithStr]];
            [model.detailMuStr appendString:str];
            
            
        }
        if (model.detailMuStr.length>0) {
            [model.detailMuStr deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
    }
    
    
    if (model.SBP026.length) {
        [model.detailMuStr appendString:model.SBP026];
        
    }
    //
    UILabel *lable=[[UILabel alloc]init];
    lable.numberOfLines=0;
    lable.text=model.detailMuStr;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lable sizeThatFits:CGSizeMake(screen_width-26, MAXFLOAT)];
    model.Bheight=size.height;
    //    NSLog(@"%f",model.height);
}


#pragma mark--delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.payArray.count) {
        return 3;
    }else
        return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {

            if (self.payArray.count==2)
            {
                return 3;
            }else
            {
                  PcModel *model=self.payArray[0];
                  //判断三种情况
                if ([model.PC004 isEqualToString:@"Scores"])
                {
                    //全积分支付
                    return 3;
                    
                }else
                {
                    if ([self.pmodel.SB036 isEqualToString:@"0.00"])
                    {
                        //正常支付
                        return 2;
                        
                    }else
                    {
                        //店铺自定义折扣
                        return 3;
                    }
                }
              
              
            }
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        case 2:
        {
            return 2;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            
             if (self.payArray.count==1)
             {
                 //没有平台优惠的情况
                 PcModel *model=self.payArray[0];
                 if ([model.PC004 isEqualToString:@"Scores"])
                 {
                     //全积分支付
                     switch (indexPath.row) {
                         case 0:
                         {
                             //付款金额
                             static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                             AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                             if (!cell) {
                                 cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                             }
                             cell.inputText.enabled=NO;
                             cell.inputText.text=_pmodel.SB023;
                             cell.nameLable.text=@"付款金额";
                             cell.inputText.textAlignment=NSTextAlignmentRight;
                             return cell;
                         }
                             break;
                         case 1:
                         {
                             //积分抵现
                             static NSString *AddDetailTableViewCell_ID = @"ScoreTableViewCell";
                             ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                             if (!cell) {
                                 cell = [[NSBundle mainBundle]loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil][0];
                             }
                             cell.nameLable.text=@"会员折扣";
                             PcModel *model=self.payArray[0];
                             if ([model.PC004 isEqualToString:@"Scores"])
                             {
                                 //积分
                                 NSInteger score=model.PC008.floatValue*10;
                                 float scorpay=model.PC008.floatValue*0.9;
                                 
                                 cell.lable1.text=[NSString stringWithFormat:@"%ld积分抵%.2f元",score,model.PC008.floatValue];
                                 cell.lable2.text=[NSString stringWithFormat:@"+%.2f",scorpay];
                                 
                             }
                             return cell;
                         }
                             break;
                         case 2:
                         {
                             //实结金额
                             static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                             AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                             if (!cell) {
                                 cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                             }
                             cell.nameLable.text=@"实结金额";
                             cell.inputText.enabled=NO;
                             cell.inputText.text=_pmodel.ShopAmount;
                             cell.inputText.textAlignment=NSTextAlignmentRight;
                             return cell;
                         }
                             break;
                             
                     }

                   
                     
                 }else
                 {
                     if ([self.pmodel.SB036 isEqualToString:@"0.00"])
                     {
                         //正常支付
                         switch (indexPath.row) {
                             case 0:
                             {   //付款金额
                                 static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                                 AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                                 if (!cell) {
                                     cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                                 }
                                 
                                 cell.nameLable.text=@"付款金额";
                                 cell.inputText.enabled=NO;
                                 cell.inputText.text=_pmodel.SB023;
                                 cell.inputText.textAlignment=NSTextAlignmentRight;
                                 return cell;
                                 
                             }
                                 break;
                                 
                             case 1:
                             {
                                 //实结金额
                                 static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                                 AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                                 if (!cell) {
                                     cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                                 }
                                 cell.nameLable.text=@"实结金额";
                                 cell.inputText.enabled=NO;
                                 cell.inputText.text=_pmodel.ShopAmount;
                                 cell.inputText.textAlignment=NSTextAlignmentRight;
                                 return cell;
                             }
                                 break;
                         }

                         
                         
                     }else
                     {
                         //店铺自定义折扣
                         switch (indexPath.row) {
                             case 0:
                             {
                                 //付款金额
                                 static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                                 AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                                 if (!cell) {
                                     cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                                 }
                                 cell.inputText.enabled=NO;
                                 cell.inputText.text=_pmodel.SB023;
                                 cell.nameLable.text=@"付款金额";
                                 cell.inputText.textAlignment=NSTextAlignmentRight;
                                 return cell;
                             }
                                 break;
                             case 1:
                             {
                                 //店铺自定义折扣
                                 static NSString *AddDetailTableViewCell_ID = @"ScoreTableViewCell";
                                 ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                                 if (!cell) {
                                     cell = [[NSBundle mainBundle]loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil][0];
                                 }
                                 cell.nameLable.text=@"会员折扣";
                                 cell.lable2.text=[NSString stringWithFormat:@"%.2f",self.model.ShopDiscount.floatValue];
                                 
                                 return cell;
                             }
                                 break;
                             case 2:
                             {
                                 //实结金额
                                 static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                                 AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                                 if (!cell) {
                                     cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                                 }
                                 cell.nameLable.text=@"实结金额";
                                 cell.inputText.enabled=NO;
                                 cell.inputText.text=_pmodel.ShopAmount;
                                 cell.inputText.textAlignment=NSTextAlignmentRight;
                                 return cell;
                             }
                                 break;
                                 
                         }

                       
                     }
                 }

                 
             }else
             {
                 //有平台优惠的情况
                 switch (indexPath.row) {
                     case 0:
                     {
                          //付款金额
                         static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                         AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                         if (!cell) {
                             cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                         }
                         cell.inputText.enabled=NO;
                         cell.inputText.text=_pmodel.SB023;
                         cell.nameLable.text=@"付款金额";
                        cell.inputText.textAlignment=NSTextAlignmentRight;
                         return cell;
                     }
                         break;
                     case 1:
                     {
                         //积分抵现
                         static NSString *AddDetailTableViewCell_ID = @"ScoreTableViewCell";
                         ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                         if (!cell) {
                             cell = [[NSBundle mainBundle]loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil][0];
                         }
                         cell.nameLable.text=@"会员折扣";
                         PcModel *model=self.payArray[0];
                         if ([model.PC004 isEqualToString:@"Scores"])
                         {
                             //积分
                             NSInteger score=model.PC008.floatValue*10;
                             float scorpay=model.PC008.floatValue*0.9;
                             
                             cell.lable1.text=[NSString stringWithFormat:@"%ld积分抵%.2f元",score,model.PC008.floatValue];
                             cell.lable2.text=[NSString stringWithFormat:@"-%.2f",scorpay];
                             
                         }else if ([model.PC004 isEqualToString:@"Coupon"])
                         {
                             //卡券
                             cell.lable1.text=[NSString stringWithFormat:@"卡券抵扣%.2f元",model.PC008.floatValue];
                             cell.lable2.text=[NSString stringWithFormat:@"-%.2f",model.PC008.floatValue];
                             
                         }else
                         {
                             //满减
                             cell.lable1.text=[NSString stringWithFormat:@"满减抵扣%.2f元",model.PC008.floatValue];
                             cell.lable2.text=[NSString stringWithFormat:@"-%.2f",model.PC008.floatValue];
                             
                         }
                        
                         return cell;
                     }
                         break;
//                     case 2:
//                     {
//                         //额外支付
//                         static NSString *AddDetailTableViewCell_ID = @"ScoreTableViewCell";
//                         ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
//                         if (!cell) {
//                             cell = [[NSBundle mainBundle]loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil][0];
//                         }
//                         cell.nameLable.text=@"额外支付";
//                         NSArray *array=[_pmodel.Payment1 componentsSeparatedByString:@"+"];
//                         cell.lable1.text=array[1];
//                         PcModel *model=self.payArray[1];
//                         cell.lable2.text=[NSString stringWithFormat:@"%.2f",model.PC008.floatValue];
//                         
//                         return cell;
//                     }
//                         break;
                     case 2:
                     {
                         //实结金额
                         static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
                         AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
                         if (!cell) {
                             cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
                         }
                         cell.nameLable.text=@"实结金额";
                         cell.inputText.enabled=NO;
                         cell.inputText.text=_pmodel.ShopAmount;
                          cell.inputText.textAlignment=NSTextAlignmentRight;
                         return cell;
                     }
                         break;
                   
                 }
             }
            
            
            
        }
            break;
        case 1:
        {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.inputText.enabled=NO;
             cell.inputText.textAlignment=NSTextAlignmentRight;
             if (indexPath.row==0)
             {
                cell.nameLable.text=@"交易时间";
                cell.inputText.text=_pmodel.sb015;
                
                 
             }else if(indexPath.row==1)
             {
                cell.nameLable.text=@"支付方式";
                 cell.inputText.text=_pmodel.Payment1;
                 
             }else
             {
                 cell.nameLable.text=@"订单编号";
                 cell.inputText.text=_pmodel.SB002;
                
                 
             }
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row==0)
            {
                PayDetailOneTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"PayDetailOneTableViewCell" owner:nil options:nil][0];
                cell.productArray=_productArray;
                return cell;
            }else
            {
                PayDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"PayDetailTwoTableViewCell" owner:nil options:nil][0];
            
                cell.totalPrice.text=[NSString stringWithFormat:@"总计:¥%@",[self.totalprice removeZeroWithStr]];
                return cell;

            }
            
        }
            break;
            
        default:
            break;
    }
    
   
    return nil;
    
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==2&&indexPath.row==0) {
        float s=0;
        for (SBPModel *model in _productArray) {
            s=s+model.Bheight+30+16;
        }
        return s;
    }
    else
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==2) {
        return 40;
    }else if(section==0)
    {
        return 40;
    }else
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        UILabel *lable=[[UILabel alloc]init];
        lable.text=@"  订单详情";
        lable.backgroundColor=[UIColor groupTableViewBackgroundColor];
        return lable;
        
    }else if(section==0)
    {
        UILabel *lable=[[UILabel alloc]init];
        lable.text=@"  收款明细";
        lable.backgroundColor=[UIColor groupTableViewBackgroundColor];
        return lable;
    }
    else
        return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"223");
}
-(UIView*)getHeaderview
{
//{
    UIView *cover=[[UIView alloc]initWithFrame:CGRectMake(0, -screen_width/3, screen_width, screen_width/3)];
//    view.backgroundColor=navigationBarColor;
//    return view;
    BuyRecordeView *view=[[NSBundle mainBundle]loadNibNamed:@"BuyRecordeView" owner:nil options:nil][0];
    view.frame=CGRectMake(0, 0, cover.width, cover.height);
    view.backgroundColor=navigationBarColor;
    view.nameLable.text=_pmodel.MS002;
    view.numberLable.text=_pmodel.MS001;
    [cover addSubview:view];
    return cover;

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
