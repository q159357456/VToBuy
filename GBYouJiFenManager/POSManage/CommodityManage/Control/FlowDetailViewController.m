//
//  FlowDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/20.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "FlowDetailViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
@interface FlowDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)BOOL is;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

/**
 参数
 */
@property(nonatomic,copy)NSString *count1;
@property(nonatomic,copy)NSString *count2;
@property(nonatomic,copy)NSString *isUp;

@end

@implementation FlowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=MainColor;
    _titleArray=@[@"商品分类",@"商品编号",@"条形编码",@"商品名称",@"规格",@"品牌",@"市场销售",@"积分",@"结算价格",@"库存数量",@"已兑数量",@"单位",@"仓库编号",@"促销有效期",@"失效日期"];
    self.isUp = _model.IsUpDown;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row<_titleArray.count)
    {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.nameLable.text=_titleArray[indexPath.row];
            cell.tag=indexPath.row;

            cell.inputText.enabled=NO;
            [self swich:cell :indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row==9) {
            [self addButtonWithCell:cell];
        }
        if (indexPath.row==10) {
            [self addButtonWithCell:cell];
        }
            return cell;
            
        
        
    
    }else
    {
        __weak typeof(self)weakSelf=self;
        AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
        cell.textLabel.text=@"是否上架";
        if ([_model.IsUpDown isEqualToString:@"True"]) {
            cell.choseSegMent.selectedSegmentIndex = 0;
        }else
        {
            cell.choseSegMent.selectedSegmentIndex = 1;
        }
        cell.statuseBlock=^(NSString *str){
            weakSelf.isUp=str;
            NSLog(@"%@",weakSelf.isUp);
            
        };

       
        return cell;
        
    }
    return nil;
    
}
-(void)addButtonWithCell:(AddDetailTableViewCell*)cell
{
    UIButton *pluse=[UIButton buttonWithType:UIButtonTypeCustom];
     UIButton *mince=[UIButton buttonWithType:UIButtonTypeCustom];
    [pluse setBackgroundImage:[UIImage imageNamed:@"pluse"] forState:UIControlStateNormal];
   
    pluse.tag=cell.tag;
    
    [mince setBackgroundImage:[UIImage imageNamed:@"mince"] forState:UIControlStateNormal];
    mince.tag=cell.tag+10;
    [pluse addTarget:self action:@selector(pluseClick:) forControlEvents:UIControlEventTouchUpInside];
    [mince addTarget:self action:@selector(minceClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:pluse];
    [cell addSubview:mince];
    cell.right.constant=110;
    [pluse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(cell.mas_centerY);
        
    }];
    [mince mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(pluse.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    
    
}
-(void)pluseClick:(UIButton*)butt
{
    if (butt.tag==9)
    {
        NSLog(@"库存");
        float k=[self.count1 floatValue];
        k++;
        self.count1=[NSString stringWithFormat:@"%.2f",k];
        AddDetailTableViewCell *cell=(AddDetailTableViewCell*)[self.view viewWithTag:9];
        cell.inputText.text=self.count1;
        
    }else
    {
        NSLog(@"已对");
        float k=[self.count2 floatValue];
        k++;
        self.count2=[NSString stringWithFormat:@"%.2f",k];
        AddDetailTableViewCell *cell=(AddDetailTableViewCell*)[self.view viewWithTag:10];
        cell.inputText.text=self.count2;
    
    
    }
    
    
}
-(void)minceClick:(UIButton*)butt
{
    
    if (butt.tag==19)
    {
        
        float k=[self.count1 floatValue];
        if (k>0) {
            k--;
            self.count1=[NSString stringWithFormat:@"%.2f",k];
            AddDetailTableViewCell *cell=(AddDetailTableViewCell*)[self.view viewWithTag:9];
            cell.inputText.text=self.count1;
        }

    }else
    {
        
        float k=[self.count2 floatValue];
        if (k>0) {
            k--;
            self.count2=[NSString stringWithFormat:@"%.2f",k];
            AddDetailTableViewCell *cell=(AddDetailTableViewCell*)[self.view viewWithTag:10];
            cell.inputText.text=self.count2;
        }

        
    }
    
}
-(void)swich:(AddDetailTableViewCell*)cell :(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            //分类名称
            cell.inputText.text=_model.ClassifyName;
            
        }
            break;
        case 1:
        {
            //商品编号
              cell.inputText.text=_model.ProductNo;
            
        }
            break;
        case 2:
        {
            //条形编码
             cell.inputText.text=_model.UPC_BarCode;
            
        }
            break;
        case 3:
        {
            //商品名称
            cell.inputText.text=_model.ProductName;
          
        }
            break;
        case 4:
        {
            //规格
             
//            NSLog(@"－－－－－%@",_model.ProductSpec);
//            cell.inputText.text=_model.ProductSpec;

            
        }
            break;
        case 5:
        {
            //品牌
          
            
        }
            break;
        case 6:
        {
            //市场销售
        
        }
            break;
        case 7:
        {
            //积分
            //cell.inputText.text = _model.Bonus;
            float jifen = [_model.Bonus floatValue];
            cell.inputText.text = [NSString stringWithFormat:@"%.2f",jifen];
            
        }
            break;
        case 8:
        {
            //计算价格
            float price = [_model.RetailPrice floatValue];
            //cell.inputText.text=_model.RetailPrice;
            cell.inputText.text = [NSString stringWithFormat:@"%.2f",price];
            
        
        }
            break;
        case 9:
        {
            //库存数量
              self.count1=_model.InventoryQty;
//           cell.inputText.text=_model.InventoryQty;
            
            float price = [_model.InventoryQty floatValue];
            
            cell.inputText.text = [NSString stringWithFormat:@"%.2f",price];

            
        }
            break;
        case 10:
        {
            //已对数量
              self.count2=_model.E_BatchQty;
            // cell.inputText.text=_model.E_BatchQty;
            
            float price = [_model.E_BatchQty floatValue];
            cell.inputText.text = [NSString stringWithFormat:@"%.2f",price];

            
        }
            break;
        case 11:
        {
            //单位
              cell.inputText.text=_model.Unit;
            
        }
            break;
        case 12:
        {
            //仓库编号
            
            
        }
            break;
        case 13:
        {
            //促销有效期
                        NSLog(@"－－－%@",_model.EffectiveDate);
             cell.inputText.text=_model.EffectiveDate;
            
            
        }
            break;
        case 14:
        {
            //失效日期
             NSLog(@"－－－%@",_model.ExpiryDate);
             cell.inputText.text=_model.ExpiryDate;
            
        }
            break;
            
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


- (IBAction)done:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Edit",@"TableName":@"INV_MallProduct",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ProductNo":self.model.ProductNo,@"InventoryQty":self.count1,@"E_BatchQty":self.count2,@"IsUpDown":self.isUp}]};
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
                [SVProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });
            
            
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
