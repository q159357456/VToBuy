//
//  BargainManagerViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/5.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "BargainManagerViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddClipTwoTableViewCell.h"
#import "CommodityBtnViewController.h"
#import "ProductModel.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "XHDatePickerView.h"
#import "NSDate+Extension.h"
@interface BargainManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    float offset;
}
@property(nonatomic,assign)float Theight;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSDate *defautDate;
@property(nonatomic,strong)NSDate *date1;
@property(nonatomic,strong)NSDate *date2;
/**
 参数
 */
@property(nonatomic,copy)NSString *productNo;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *yuanPrice;
@property(nonatomic,copy)NSString *diPrice;
@property(nonatomic,copy)NSString *pushCount;
@property(nonatomic,copy)NSString *limitCount;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *startPrice;
@property(nonatomic,copy)NSString *endPrice;



@end

@implementation BargainManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _doneButton.backgroundColor=MainColor;
    [self getInitData];
    [self addKeyBoardNotify];
    
    

}
-(void)addKeyBoardNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark--键盘事件
//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    offset = self.Theight - (self.view.frame.size.height - kbHeight);
    
    
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset >0) {
        
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)getInitData
{
    self.productNo=@"--选择商品--";
    self.startTime=@"--选择开始时间--";
    self.endTime=@"--选择结束时间--";
    self.startPrice=@"";
    self.endPrice=@"";

}
-(NSDate *)defautDate
{
    if (!_defautDate) {
        _defautDate=[NSDate date];
    }
    return _defautDate;
}
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray=@[@"商品编号",@"商品名称",@"商品原价",@"商品低价",@"发行份数",@"限制参与次数",@"开放时间",@"结束时间",@"随机单价"];
    }
    return _titleArray;
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row!=8) {
        static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
        AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
        }
        if (indexPath.row==0) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==3||indexPath.row==4||indexPath.row==5) {
           cell.inputText.keyboardType=UIKeyboardTypeNumberPad;
        }
        cell.nameLable.font=[UIFont systemFontOfSize:14];
        cell.inputText.font=[UIFont systemFontOfSize:15];
        cell.nameLable.text=self.titleArray[indexPath.row];
        cell.inputText.delegate=self;
        cell.inputText.tag=indexPath.row+1;
        [self getCellDataWithCell:cell index:indexPath.row];
        return cell;
        
    }else
        
    {
      
        AddClipTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddClipTwoTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.TWidth.constant=88;
        [self getCellDataWithCell:cell index:indexPath.row];
        cell.endData.tag=indexPath.row+1;
        cell.endData.placeholder=@"最高金额";
         cell.startData.placeholder=@"最低金额";
        cell.startData.tag=indexPath.row+2;
        cell.endData.delegate=self;
        cell.startData.delegate=self;
        cell.nameLable.font=[UIFont systemFontOfSize:14];
        cell.nameLable.text=self.titleArray[indexPath.row];
        cell.startData.keyboardType=UIKeyboardTypeNumberPad;
        cell.endData.keyboardType=UIKeyboardTypeNumberPad;
        
        
        return cell;
        
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
-(void)getCellDataWithCell:(UITableViewCell*)cell index:(NSInteger)index
{
 
    switch (index) {
        case 0:
        {
           AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.productNo;
            
            
            
        }
            break;
        case 1:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.productName;
        }
            break;
            
        case 2:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.yuanPrice;
            
        }
            break;
            
        case 3:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.diPrice;
            
        }
            break;
            
        case 4:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.pushCount;
        }
            break;
            
        case 5:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.limitCount;
        }
            break;
            
        case 6:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.startTime;
        }
            break;
            
        case 7:
        {
            AddDetailTableViewCell *dcell=(AddDetailTableViewCell*)cell;
            dcell.inputText.text=self.endTime;
        }
            break;
            
        case 8:
        {
        
            AddClipTwoTableViewCell *tcell=(AddClipTwoTableViewCell*)cell;
            tcell.startData.text=self.startPrice;
            tcell.endData.text=self.endPrice;
        }
            break;
            
            
        default:
            break;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            CommodityBtnViewController *com=[[CommodityBtnViewController alloc]init];
            com.title=@"选择商品";
            com.funType=@"KanJia";
            __weak typeof(self)weakSelf=self;
            com.KanJiaBlock=^(ProductModel *model){
                
                weakSelf.productNo=model.ProductNo;
                weakSelf.productName=model.ProductName;
                weakSelf.yuanPrice=model.RetailPrice;
                [weakSelf.tableview reloadData];
            };
            [self.navigationController pushViewController:com animated:YES];

            return NO;
        }
            break;
        case 2:
        {
            
             return NO;
        }
            break;
        case 3:
        {
             return NO;
        }
            break;
        case 4:
        {
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.Theight=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 5:
        {
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.Theight=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 6:
        {
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.Theight=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 7:
        {
            //开始时间
            [self.view endEditing:YES];
            XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCurrentDate:self.defautDate CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
                self.startTime = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
                UITextField *field=(UITextField*)[self.view viewWithTag:7];
                field.text=self.startTime;
                _date1=startDate;
            }];
            
            datepicker.dateType=1;
            datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
            datepicker.dateType = DateTypeStartDate;
//            datepicker.minLimitDate = [NSDate date:@"2017-2-28 12:22" WithFormat:@"yyyy-MM-dd HH:mm"];
//            datepicker.maxLimitDate = [NSDate date:@"2018-2-28 12:12" WithFormat:@"yyyy-MM-dd HH:mm"];
            [datepicker show];
             return NO;
        }
            break;
        case 8:
        {
            //结束时间
              [self.view endEditing:YES];
            XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCurrentDate:self.defautDate CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
                self.endTime = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
                 UITextField *field=(UITextField*)[self.view viewWithTag:8];
                field.text=self.endTime;
                _date2=startDate;

            }];
            datepicker.dateType=0;
            datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
            datepicker.dateType = DateTypeStartDate;

            [datepicker show];
             return NO;
        }
            break;
        case 9:
        {
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.Theight=textField.frame.size.height+rect.origin.y+5;
            
        }
            break;
        case 10:
        {
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.Theight=textField.frame.size.height+rect.origin.y+5;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 1:
        {
            
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            self.diPrice=textField.text;
        }
            break;
        case 5:
        {
            self.pushCount=textField.text;
        }
            break;
        case 6:
            
        {
        
            self.limitCount=textField.text;
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            
        }
            break;
        case 9:
        {
            
            self.endPrice=textField.text;
          
    
        }
            break;
        case 10:
        {
        
              self.startPrice=textField.text;
        }
            break;
            
        default:
            break;
    }

}
- (IBAction)done:(UIButton *)sender
{
    if (_productNo.length&&_productName.length&&_diPrice.length&&_pushCount.length&&_limitCount.length&&_startTime.length&&_endTime.length&&_startPrice.length&&_endPrice.length)
    {
        if (_startPrice.floatValue<_endPrice.floatValue)
        {
           
            if (_date2>_date1)
            {
              
                [SVProgressHUD showWithStatus:@"加载中"];
                MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
                NSDictionary *jsonDic;
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Sales_Bargain",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"ProductNo":_productNo,@"ProductName":_productName,@"Amount1":_yuanPrice,@"Amount2":_diPrice,@"Quantity1":_pushCount,@"Quantity2":@"0",@"LimitQuantity":_limitCount,@"StartDate":_startTime,@"EndDate":_endTime,@"Price1":_startPrice,@"Price2":_endPrice}]};
                NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                NSLog(@"%@",jsonStr);
                
                NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
                [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                    
                    
                    NSString *str=[JsonTools getNSString:responseObject];
                    [SVProgressHUD dismiss];
                    NSLog(@"%@",str);
                    
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
                                [self alertShowWithStr:str];
                            }
                    
                    
                } Faile:^(NSError *error) {
                    NSLog(@"失败%@",error);
                }];
                
            }else
            {
                [self alertShowWithStr:@"时间输入有误"];
            }

        }else
        {
            [self alertShowWithStr:@"金额输入有误"];
        }
      
        
    }else
    {
        [self alertShowWithStr:@"请填写完整资料"];
    }
    
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
