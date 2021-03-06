//
//  AddProductViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/2.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddProductViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "UpPictureTableViewCell.h"
#import "AddClassifyViewController.h"
#import "ClassifyModel.h"
#import "BigPictureViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface AddProductViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITextField *specialfield;
@property(nonatomic,copy)NSMutableArray *pictureArray;
@property(nonatomic,strong)MemberModel *model;

/**
 上传商品信息参数
 */
@property(nonatomic,copy)NSString *statuse;
@property(nonatomic,copy)NSString *valid;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productNo;
@property(nonatomic,copy)NSString *tiaoxinNo;
@property(nonatomic,copy)NSString *danwei;
@property(nonatomic,copy)NSString *productClassify;
@property(nonatomic,copy)NSString *productClassiName;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *IsHotGoods;
@property(nonatomic,copy)NSString *IsReceive;
@property(nonatomic,copy)NSString *memberPrice;


@end

@implementation AddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.doneButton.backgroundColor=MainColor;
 
    self.model = [[FMDBMember shareInstance] getMemberData][0];
    
    _pictureArray=[NSMutableArray array];
    self.productClassiName=@"--选择商品所属分类--";

    
    if ( [self.funType isEqualToString:@"Edit"])
    {
        //编辑

        self.productName=self.productModel.ProductName;
        self.tiaoxinNo=self.productModel.UPC_BarCode;
        self.danwei=self.productModel.Unit;
        self.price=self.productModel.RetailPrice;
        self.memberPrice=self.productModel.SellPrice1;
        self.statuse=self.productModel.IsUpDown;
        self.valid=self.productModel.IsWeigh;
        self.IsHotGoods=self.productModel.IsHotGoods;//特价否
        self.IsReceive=self.productModel.IsReceive;
        NSString *str=[NSString stringWithFormat:@"%@%@",PICTUREPATH,self.productModel.PicAddress1];
        NSString *urlStr=[str URLEncodedString];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        [_pictureArray  insertObject:data atIndex:0];
        NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
        if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {
             _titleArray=@[@"商品分类",@"商品编号",@"商品名称",@"单位",@"价格(元)",@"会员价"];
        }else
        {
           _titleArray=@[@"商品分类",@"商品编号",@"商品名称",@"条码编号",@"单位",@"价格(元)",@"会员价"];
        }
        
    }else
    {
      
        //上架
        self.statuse=@"True";
        //称重否
        self.valid=@"False";
        
        //特价否
        self.IsHotGoods=@"False";
        //招待否
        self.IsReceive=@"True";
        NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
        if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {
            _titleArray=@[@"商品分类",@"商品名称",@"单位",@"价格(元)",@"会员价"];
        }else
        {
            _titleArray=@[@"商品分类",@"商品名称",@"条码编号",@"单位",@"价格(元)",@"会员价"];
        }

        
        
        [_pictureArray addObject:@"uppic_2"];
        
    }
    // Do any additional setup after loading the view from its nib.
}
-(UITextField *)specialfield
{
    
    if (!_specialfield) {
        _specialfield=[[UITextField alloc]init];
        _specialfield.textAlignment=NSTextAlignmentCenter;
        _specialfield.text=@"";
        _specialfield.textColor=[UIColor lightGrayColor];
        _specialfield.frame=CGRectMake(85, 0, screen_width-198,50);
        _specialfield.keyboardType=UIKeyboardTypeNumberPad;
    }
    return _specialfield;
}
-(void)setTableview:(UITableView *)tableview
{
    _tableview=tableview;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    _tableview.tableFooterView = footView;
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, screen_width-60, 50)];
    addButton.backgroundColor = MainColor;
     if ( [self.funType isEqualToString:@"Edit"])
     {
          [addButton setTitle:@"确认修改" forState:UIControlStateNormal];
     }else
     {
          [addButton setTitle:@"确认添加" forState:UIControlStateNormal];
     }
   
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:addButton];

}
-(void)buttonClick
{
    if ([_pictureArray[0]isKindOfClass:[NSData class]])
    {
        if (self.productName.length==0||self.danwei.length==0||self.price.length==0||self.productClassify.length==0)
        {
            [self alertShowWithStr:@"信息没有填写完整"];
        }
        else
        {
            if ( [self.funType isEqualToString:@"Edit"])
            {
                [self editProduct];
            }else
            {
                [self addproduct];
            }
        }
        
        
    }else
    {
        [self alertShowWithStr:@"请添加图片"];
    }
    

}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count+6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
    if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {
       
        if (indexPath.row<=_titleArray.count-1)
        {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            
            cell.inputText.delegate=self;
            cell.inputText.tag=indexPath.row+1;
            if (cell.inputText.tag==1) {
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    cell.inputText.text=self.productModel.ClassifyName;
                    cell.inputText.enabled=NO;
                    self.productClassify=self.productModel.ClassifyName;
                }else
                {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                
            }
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if (cell.inputText.tag==2)
                {
                    cell.inputText.text=self.productModel.ProductNo;
                    cell.inputText.enabled=NO;
                    
                }
                if (cell.inputText.tag==3)
                {
                    cell.inputText.text=self.productName;
                    
                    
                }

                if (cell.inputText.tag==4)
                {
                    cell.inputText.text=self.danwei;
                    
                    
                }
                if (cell.inputText.tag==5)
                {
                    cell.inputText.text=_price;
                    cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
                    
                    
                }
                if (cell.inputText.tag==6)
                {
                    cell.inputText.text=_memberPrice;
                    cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
                    
                    
                }
                
            }else
            {
                [self getCellDataWithCell:cell index:indexPath.row];
            }
            
            
            
            cell.nameLable.text=_titleArray[indexPath.row];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }else if(indexPath.row==_titleArray.count)
        {
            __weak typeof(self)weakSelf=self;
            
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            __weak typeof(AddDetailTwoTableViewCell*)weakCell=cell;
            cell.textLabel.text=@"是否参与特价";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.IsHotGoods isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                    [weakCell addSubview:weakSelf.specialfield];
                    _specialfield.text=_productModel.SellPrice2;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                //默认否
                cell.choseSegMent.selectedSegmentIndex=1;
                
            }
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.IsHotGoods=str;
                //如果可以特价的
                if (str.boolValue)
                {
                    
                    [weakCell addSubview:weakSelf.specialfield];
                    [weakSelf.specialfield becomeFirstResponder];
                }else
                {
                    weakSelf.specialfield.text=@"";
                    [weakSelf.specialfield removeFromSuperview];
                }
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
        else if(indexPath.row==_titleArray.count+1)
        {
            __weak typeof(self)weakSelf=self;
            
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            cell.textLabel.text=@"是否需要称重";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.valid isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
                
            }
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.valid=str;
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if(indexPath.row==_titleArray.count+2)
        {
            __weak typeof(self)weakSelf=self;
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            cell.textLabel.text=@"是否上架销售";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.statuse isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
                
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }
            
            cell.statuseBlock=^(NSString *str){
                weakSelf.statuse=str;
                
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if(indexPath.row==_titleArray.count+3)
        {
            
            __weak typeof(self)weakSelf=self;
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.IsReceive isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }
            
            cell.textLabel.text=@"是否参与免单";
            cell.statuseBlock=^(NSString *str){
                weakSelf.IsReceive=str;
                NSLog(@"可招待否:%@",weakSelf.IsReceive);
            };
            return cell;
        }
        else if(indexPath.row==_titleArray.count+4)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            cell.textLabel.text=@"图片上传";
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }else
        {
            __weak typeof(self)weakSelf=self;
            UpPictureTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"UpPictureTableViewCell" owner:nil options:nil][0];
            //        cell.dataArray=self.pictureArray;
            [cell setDataArrayWithStr:2 :self.pictureArray];
            cell.addBlock=^(NSInteger index){
                
                weakSelf.selectedIndex=index;
                [weakSelf addPicture];
            };
            //删除
            cell.closeBlock=^(NSInteger index){
                NSLog(@"删除");
                [weakSelf deletPictureWithIndex:index];
            };
            cell.extendBlock=^(NSInteger index){
                NSLog(@"大图");
                [weakSelf bigPictureWithIndex:index];
            };
            return cell;
        }

        
    }else
    {
        if (indexPath.row<=_titleArray.count-1)
        {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            
            cell.inputText.delegate=self;
            cell.inputText.tag=indexPath.row+1;
            if (cell.inputText.tag==1) {
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    cell.inputText.text=self.productModel.ClassifyName;
                    cell.inputText.enabled=NO;
                    self.productClassify=self.productModel.ClassifyName;
                }else
                {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                
            }
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if (cell.inputText.tag==2)
                {
                    cell.inputText.text=self.productModel.ProductNo;
                    cell.inputText.enabled=NO;
                    
                }
                if (cell.inputText.tag==3)
                {
                    cell.inputText.text=self.productName;
                    
                    
                }
                if (cell.inputText.tag==4)
                {
                    cell.inputText.text=self.tiaoxinNo;
                    cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
                    
                }
                if (cell.inputText.tag==5)
                {
                    cell.inputText.text=self.danwei;
                    
                    
                }
                if (cell.inputText.tag==6)
                {
                    cell.inputText.text=_price;
                    cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
                    
                    
                }
                if (cell.inputText.tag==7)
                {
                    cell.inputText.text=_memberPrice;
                    cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
                    
                    
                }
                
            }else
            {
                [self getCellDataWithCell:cell index:indexPath.row];
            }
            
            
            
            cell.nameLable.text=_titleArray[indexPath.row];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }else if(indexPath.row==_titleArray.count)
        {
            __weak typeof(self)weakSelf=self;
            
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            __weak typeof(AddDetailTwoTableViewCell*)weakCell=cell;
            cell.textLabel.text=@"是否参与特价";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.IsHotGoods isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                    [weakCell addSubview:weakSelf.specialfield];
                    _specialfield.text=_productModel.SellPrice2;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                //默认否
                cell.choseSegMent.selectedSegmentIndex=1;
                
            }
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.IsHotGoods=str;
                //如果可以特价的
                if (str.boolValue)
                {
                    
                    [weakCell addSubview:weakSelf.specialfield];
                    [weakSelf.specialfield becomeFirstResponder];
                }else
                {
                    weakSelf.specialfield.text=@"";
                    [weakSelf.specialfield removeFromSuperview];
                }
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }
        else if(indexPath.row==_titleArray.count+1)
        {
            __weak typeof(self)weakSelf=self;
            
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            cell.textLabel.text=@"是否需要称重";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.valid isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
                
            }
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.valid=str;
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if(indexPath.row==_titleArray.count+2)
        {
            __weak typeof(self)weakSelf=self;
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            cell.textLabel.text=@"是否上架销售";
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.statuse isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
                
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }
            
            cell.statuseBlock=^(NSString *str){
                weakSelf.statuse=str;
                
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else if(indexPath.row==_titleArray.count+3)
        {
            
            __weak typeof(self)weakSelf=self;
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            if ( [self.funType isEqualToString:@"Edit"])
            {
                if ([self.IsReceive isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=0;
            }
            
            cell.textLabel.text=@"是否参与免单";
            cell.statuseBlock=^(NSString *str){
                weakSelf.IsReceive=str;
                NSLog(@"可招待否:%@",weakSelf.IsReceive);
            };
            return cell;
        }
        else if(indexPath.row==_titleArray.count+4)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            cell.textLabel.text=@"图片上传";
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }else
        {
            __weak typeof(self)weakSelf=self;
            UpPictureTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"UpPictureTableViewCell" owner:nil options:nil][0];
            //        cell.dataArray=self.pictureArray;
            [cell setDataArrayWithStr:2 :self.pictureArray];
            cell.addBlock=^(NSInteger index){
                
                weakSelf.selectedIndex=index;
                [weakSelf addPicture];
            };
            //删除
            cell.closeBlock=^(NSInteger index){
                NSLog(@"删除");
                [weakSelf deletPictureWithIndex:index];
            };
            cell.extendBlock=^(NSInteger index){
                NSLog(@"大图");
                [weakSelf bigPictureWithIndex:index];
            };
            return cell;
        }

    }
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_titleArray.count+5)
    {
        return 102;
    }else
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
#pragma mark textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            //商品分类
            AddClassifyViewController *add=[[AddClassifyViewController alloc]init];
            add.funType=@"choose";
            add.title=@"选择分类";
            __weak typeof(self)weakSelf=self;
            add.backBlock=^(ClassifyModel *clasiModel){
                weakSelf.productClassify=clasiModel.classifyNo;
                weakSelf.productClassiName=clasiModel.classifyName;
                [weakSelf changeWithStr:clasiModel.classifyName];
                
            };
            [add setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:add animated:YES];
            return NO;
            
            
        }
            break;
            
        default:
            
            
            break;
    }

    return YES;
}
-(void)changeWithStr:(NSString*)str
{
    UITextField *filed=(UITextField*)[self.tableview viewWithTag:1];
    filed.text=str;
}
-(void)getCellDataWithCell:(AddDetailTableViewCell*)cell index:(NSInteger)index
{
    NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
    if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {
        
        switch (index) {
            case 0:
            {
                
                cell.inputText.text=self.productClassiName;
            }
                break;
            case 1:
            {
                cell.inputText.text=self.productName;
            }
                break;
//            case 2:
//            {
//                cell.inputText.text=self.tiaoxinNo;
//                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
//            }
//                break;
            case 2:
            {
                cell.inputText.text=self.danwei;
            }
                break;
            case 3:
            {
                cell.inputText.text=self.price;
                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
            }
                break;
            case 4:
            {
                cell.inputText.text=self.memberPrice;
                cell.inputText.placeholder = @"会员价可填可不填";
                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
            }
                break;
                
            default:
                break;
        }

        
    }else
    {
        switch (index) {
            case 0:
            {
                
                cell.inputText.text=self.productClassiName;
            }
                break;
            case 1:
            {
                cell.inputText.text=self.productName;
            }
                break;
            case 2:
            {
                cell.inputText.text=self.tiaoxinNo;
                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
            }
                break;
            case 3:
            {
                cell.inputText.text=self.danwei;
            }
                break;
            case 4:
            {
                cell.inputText.text=self.price;
                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
            }
                break;
            case 5:
            {
                cell.inputText.text=self.memberPrice;
                cell.inputText.placeholder = @"会员价可填可不填";
                cell.inputText.keyboardType=UIKeyboardTypeDecimalPad;
            }
                break;
                
            default:
                break;
        }

    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
    if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {

        switch (textField.tag) {
            case 1:
            {
                //商品分类
                
                
            }
                break;
            case 2:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.productNo=textField.text;
                }else
                {
                    self.productName=textField.text;
                }
                
                
            }
                break;
//            case 3:
//            {
//                //
//                if ( [self.funType isEqualToString:@"Edit"])
//                {
//                    self.productName=textField.text;
//                }else
//                {
//                    self.tiaoxinNo=textField.text;
//                }
//                
//            }
//                break;
            case 3:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.productName=textField.text;
                }else
                {
                    self.danwei=textField.text;
                }
                
            }
                break;
            case 4:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.danwei=textField.text;
                    
                }else
                {
                    self.price=textField.text;
                }
                
            }
                break;
            case 5:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.price=textField.text;
                    
                }else
                {
                    self.memberPrice=textField.text;
                }
                
            }
                break;
            case 6:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.memberPrice=textField.text;
                    
                }else
                {
                    
                }
                
            }
                break;
                
            default:
                
                break;
        }

        
    }else
    {
        switch (textField.tag) {
            case 1:
            {
                //商品分类
                
                
            }
                break;
            case 2:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.productNo=textField.text;
                }else
                {
                    self.productName=textField.text;
                }
                
                
            }
                break;
            case 3:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.productName=textField.text;
                }else
                {
                    self.tiaoxinNo=textField.text;
                }
                
            }
                break;
            case 4:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    
                    self.tiaoxinNo=textField.text;
                }else
                {
                    self.danwei=textField.text;
                }
                
            }
                break;
            case 5:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.danwei=textField.text;
                    
                }else
                {
                    self.price=textField.text;
                }
                
            }
                break;
            case 6:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.price=textField.text;
                    
                }else
                {
                    self.memberPrice=textField.text;
                }
                
            }
                break;
            case 7:
            {
                //
                if ( [self.funType isEqualToString:@"Edit"])
                {
                    self.memberPrice=textField.text;
                    
                }else
                {
                    
                }
                
            }
                break;
                
            default:
                
                break;
        }

    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)bigPictureWithIndex:(NSInteger)index
{
    
    BigPictureViewController *big=[[BigPictureViewController alloc]init];
    UIImage *image=[UIImage imageWithData:_pictureArray[index]];
    big.image=image;
    [self presentViewController:big animated:YES completion:nil];
}
-(void)deletPictureWithIndex:(NSInteger)index
{
    [_pictureArray replaceObjectAtIndex:index withObject:@"uppic_2"];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+5 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
}
-(void)addPicture
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用照相机
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.delegate=self;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用相册
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate=self;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
      
    }];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    NSData *data=UIImageJPEGRepresentation(image, 1.0f);
//    [_pictureArray insertObject:data atIndex:_pictureArray.count-1];

     [_pictureArray replaceObjectAtIndex:self.selectedIndex withObject:data];
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+5 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
}
-(void)addproduct
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;

        
    NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
    if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"])
    {
        if (_IsHotGoods.boolValue)
        {
            if(self.memberPrice == nil ||self == NULL||[self.memberPrice isEqualToString:@""]){
       jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }
        }else
        {
            
            if(self.memberPrice == nil ||self == NULL||[self.memberPrice isEqualToString:@""]){
            jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
            }
        }

        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSString *encodedImageStr = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
            
            
            NSString *str=[JsonTools getNSString:responseObject];
            
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
                [SVProgressHUD dismiss];
                [self alertShowWithStr:str];
            }
            
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

        
        
        
    }else
    {
        if (self.tiaoxinNo.length>0) {
            
        
        if (_IsHotGoods.boolValue)
        {
            if(self.memberPrice == nil ||self == NULL||[self.memberPrice isEqualToString:@""])
            {
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }
        }else
        {
            if(self.memberPrice == nil ||self == NULL||[self.memberPrice isEqualToString:@""])
            {
           jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Add",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"Property":@"p",@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
            }
        }
            
            
            NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonStr);
            NSString *encodedImageStr = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
            [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
                
                
                NSString *str=[JsonTools getNSString:responseObject];
                
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
                    [SVProgressHUD dismiss];
                    [self alertShowWithStr:str];
                }
                
                
            } Faile:^(NSError *error) {
                NSLog(@"失败%@",error);
            }];

            
            
            
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:@"请输入商品条形码!"];
        }
    }
   

    
}
-(void)editProduct
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];

    NSDictionary *jsonDic;
    
    
    
    NSString *runModel=[[NSUserDefaults standardUserDefaults]objectForKey:@"POS_RunModel"];
    if ([runModel isEqualToString:@"01"]||[runModel isEqualToString:@"02"]) {
        if (_IsHotGoods.boolValue)
        {
            if (self.memberPrice == nil || self.memberPrice == NULL ||[self.memberPrice isEqualToString:@""]){
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }
        }else
        {
           if (self.memberPrice == nil || self.memberPrice == NULL ||[self.memberPrice isEqualToString:@""]){
               jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
          }else
          {
            jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
         }
    }

        NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        NSString *encodedImageStr = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
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
                [SVProgressHUD dismiss];
                [self alertShowWithStr:str];
            }
            
            
        } Faile:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];

        
        
    }else
    {
        if (self.tiaoxinNo.length>0) {
            
           if (_IsHotGoods.boolValue)
           {
            if (self.memberPrice == nil || self.memberPrice == NULL ||[self.memberPrice isEqualToString:@""]){
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }else
            {
                jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"SellPrice2":_specialfield.text,@"IsReceive":_IsReceive}]};
            }
        }else
           {
           if (self.memberPrice == nil || self.memberPrice == NULL ||[self.memberPrice isEqualToString:@""]){
         jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
           }else
            {
         jsonDic=@{ @"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":self.productClassify,@"ProductName":self.productName,@"UPC_BarCode":self.tiaoxinNo,@"Unit":self.danwei,@"IsUpDown":self.statuse,@"IsWeigh":self.valid,@"RetailPrice":self.price,@"ProductDesc":@"详细说明",@"ProductNo":self.productModel.ProductNo,@"SellPrice1":_memberPrice,@"IsHotGoods":_IsHotGoods,@"IsReceive":_IsReceive}]};
           }
        }
            
            
            
            NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonStr);
            NSString *encodedImageStr = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
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
                    [SVProgressHUD dismiss];
                    [self alertShowWithStr:str];
                }
                
                
            } Faile:^(NSError *error) {
                NSLog(@"失败%@",error);
            }];
            
            
         }else
         {
             [SVProgressHUD dismiss];
            [self alertShowWithStr:@"请输入商品条形码!"];
         }
    }
        
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
