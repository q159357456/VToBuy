//
//  MarketingInforViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/4.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "MarketingInforViewController.h"
#import "AddDetailTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "BusinessClassify.h"
#import "RegionModel.h"
#import "IDAddressPickerView.h"
#import "UpPictureTableViewCell.h"
#import "BigPictureViewController.h"
#import "MyDiscountChoseView.h"
#import "CoverView.h"
#import "ChoosePOSSetModeViewController.h"
#import "chooseTimeTableViewCell.h"
#import "MapFunViewController.h"
#import <IQKeyboardManager.h>

@interface MarketingInforViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IDAddressPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat offset;
}

@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIView *PickerView;
@property(nonatomic,strong)UIView *coverView1;
@property(nonatomic,assign)BOOL is;

@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)MyDiscountChoseView *chooseView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property(strong,nonatomic)UITableView *table;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *busiTypeArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *citypeArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property(nonatomic,strong)NSMutableArray *pictureArray1;
@property (nonatomic, strong) IDAddressPickerView *addressPickerView;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger selectedRow;
@property(nonatomic,strong)NSMutableDictionary *areaDic;
@property(nonatomic,assign)CGFloat height;

/**
 参数
 */
//longitude
//latitude

@property(nonatomic,copy)NSString *shopName;
@property(nonatomic,copy)NSString *chargePerson;
@property(nonatomic,copy)NSString *shopPhoneNum;
@property(nonatomic,copy)NSString *businessNo;
@property(nonatomic,copy)NSString *businessType;
@property(nonatomic,copy)NSString *businessName;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *detailAdress;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *provinceCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *AreaName;
@property(nonatomic,copy)NSString *AreaCode;
@property(nonatomic,copy)NSString *ShopDiscount;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *mainAdress;
@property(nonatomic,copy)NSString *shopMode;//店铺模式
@property(nonatomic,copy)NSString *workTime;//营业时间
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *lestMoney;//起送金额
@property(nonatomic,copy)NSString *circleCode;
@property(nonatomic,copy)NSString *circleName;
@end

@implementation MarketingInforViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _busiTypeArray=[NSMutableArray array];
    _dataArray=[NSMutableArray array];
    _provinceArray=[NSMutableArray array];
    _citypeArray=[NSMutableArray array];
    _areaArray=[NSMutableArray array];
    _pictureArray=[NSMutableArray array];
    _pictureArray1 = [NSMutableArray array];
    [self addLefttButton];
    
    self.doneButton.backgroundColor=MainColor;
    for (NSInteger i=0; i<1; i++) {
        [_pictureArray addObject:@"uppic_2"];
    }
    for (NSInteger i=0; i<2; i++) {
        [_pictureArray1 addObject:@"uppic_2"];
    }
    
    _titleArray=@[@"店铺名称",@"联系人",@"联系电话",@"工商注册号",@"行业类型",@"选择城市",@"详细地址",@"店铺位置",@"店铺模式",@"营业时间",@"起送金额(元)",@"商户结算"];
    self.businessName=@"-请选择-";
    self.mainAdress=@"-请选择-";
    self.ShopDiscount=@"-请选择-";
    self.shopMode = @"02";
    [self addKeyBoardNotify];
    [self getbusinessData];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.keyTableView = _tableview;
 
}

#pragma mark - IDAddressPickerViewDataSource
- (NSArray *)addressArray {
    return _dataArray;
}

#pragma mark--data
-(void)getbusinessData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"ClassifyType,ClassifyNo,ClassifyName,ParentNo",@"Condition":@"classifytype$=$05",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"--%@",dic1);
        _busiTypeArray=[BusinessClassify getDataWithDic:dic1];
    ;
        [self getprovinceData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    

}
-(void)getprovinceData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Provice",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
       
        NSDictionary *dic1=[JsonTools getData:responseObject];
    
        _provinceArray=[RegionModel getDataWithDic:dic1 withStr:@"Provice"];
  
        [self getcityData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getcityData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_City",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
     
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _citypeArray=[RegionModel getDataWithDic:dic1 withStr:@"City"];
   
        [self getareaData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(void)getareaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Borough",@"SelectField":@"*",@"Condition":@"",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        _areaArray=[RegionModel getDataWithDic:dic1 withStr:@"Borough"];
        [self getAllData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)getAllData
{

    for (RegionModel *qmodel in _provinceArray)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:qmodel.provName forKey:@"state"];
        NSMutableArray *city=[NSMutableArray array];
        for (RegionModel *wmodel in _citypeArray)
        {
      
            NSMutableDictionary *cityDic=[NSMutableDictionary dictionary];
        

            
            if ([wmodel.provCode isEqualToString:qmodel.provCode])
            {
                
                [cityDic setValue:wmodel.cityName forKey:@"city"];
               NSMutableArray *borth=[NSMutableArray array];
                for (RegionModel*rmodel in _areaArray)
                {
                    
                    if ([rmodel.cityCode isEqualToString:wmodel.cityCode])
                    {
                        [borth addObject:rmodel.boroName];
                    }
                }
                
                [cityDic setValue:borth forKey:@"areas"];
                [city addObject:cityDic];
            }
            
        }
        
        [dic setValue:city forKey:@"cities"];
        [_dataArray addObject:dic];
        
    }
    [_dataArray removeObjectsInRange:NSMakeRange(_dataArray.count-3, 3)];

}
-(void)getprovinceCodeWithStr:(NSString*)str
{
  
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Provice",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"provName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
       
        NSDictionary *dic1=[JsonTools getData:responseObject];

        self.provinceCode=dic1[@"DataSet"][@"Table"][0][@"provCode"];

        NSLog(@"%@",  self.provinceCode);

        [self getcityCodeWithStr:self.areaDic[@"CityKey"]];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)getcityCodeWithStr:(NSString*)str
{
    NSDictionary *dic=@{@"FromTableName":@"CMS_City",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"cityName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
   
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
      
        NSDictionary *dic1=[JsonTools getData:responseObject];
       
        self.cityCode=dic1[@"DataSet"][@"Table"][0][@"cityCode"];

       NSLog(@"%@",  self.cityCode);
        [self getareaCodeWithStr:self.areaDic[@"AreaKey"]];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)getareaCodeWithStr:(NSString*)str
{
    NSDictionary *dic=@{@"FromTableName":@"CMS_Borough",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"boroName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
         self.AreaCode=dic1[@"DataSet"][@"Table"][0][@"boroCode"];
        NSLog(@"%@", self.AreaCode);

        [self getAllData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_table)
    {
        return _busiTypeArray.count;
    }else
    {
        return _titleArray.count+3;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_table)
    {
        BusinessClassify *model=_busiTypeArray[indexPath.row];
        ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        cell.contentLable.text=model.classifyName;
//        NSLog(@"--%@",model.ParentNo);
        cell.contentLable.textAlignment=NSTextAlignmentLeft;

        if (!model.ParentNo.length){
            cell.left.constant=8;
            cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            
        }else
        {
            cell.left.constant=38;
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    
    }else
    {
        if (indexPath.row<=_titleArray.count-1 && indexPath.row != 9)
        {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            if (indexPath.row==2) {
                cell.inputText.keyboardType= UIKeyboardTypeDecimalPad;
            }
            if (indexPath.row == 7) {
                cell.inputText.enabled = NO;
                if (self.latitude)
                {
                    cell.inputText.textColor=[UIColor lightGrayColor];
                    cell.inputText.text = @"已设置";
                }else
                {
                    cell.inputText.textColor=[UIColor blackColor];
                    cell.inputText.text = @"未设置";
                }
              
                cell.inputText.textAlignment = NSTextAlignmentRight;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.inputText.delegate=self;
            cell.inputText.tag=indexPath.row+1;

            cell.nameLable.text=_titleArray[indexPath.row];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            [self getCelldata:cell :indexPath.row];
            return cell;

        }else if(indexPath.row == 9)
        {
            chooseTimeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"chooseTimeTableViewCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.startTime.tag = 20;
            cell.endTime.tag = 21;
            cell.startTime.delegate = self;
            cell.endTime.delegate = self;
            return cell;
        }
        else if (indexPath.row==_titleArray.count)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            cell.textLabel.text=@"店铺图片上传";
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
         
        }else if(indexPath.row == _titleArray.count + 1)
        {
            __weak typeof(self)weakSelf=self;
            
            UpPictureTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"UpPictureTableViewCell" owner:nil options:nil][0];
            [cell setDataArrayWithStr:1:self.pictureArray];
            //添加
            cell.addBlock=^(NSInteger index){
                weakSelf.selectedRow = indexPath.row;
                weakSelf.selectedIndex=index;
                [weakSelf addPicture];
            };
            //删除
            cell.closeBlock=^(NSInteger index){
                NSLog(@"删除");
                weakSelf.selectedRow = indexPath.row;
                [weakSelf deletPictureWithIndex:index];
            };
            cell.extendBlock=^(NSInteger index){
                NSLog(@"大图");
                weakSelf.selectedRow = indexPath.row;
                [weakSelf bigPictureWithIndex:index];
            };
            return cell;

        }else
        {
            __weak typeof(self)weakSelf=self;
            
            UpPictureTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"UpPictureTableViewCell" owner:nil options:nil][0];
            [cell setDataArrayWithStr:3:self.pictureArray1];
            //添加
            cell.addBlock=^(NSInteger index){
                weakSelf.selectedRow = indexPath.row;
                weakSelf.selectedIndex=index;
                [weakSelf addPicture];
            };
            //删除
            cell.closeBlock=^(NSInteger index){
                NSLog(@"删除");
                weakSelf.selectedRow = indexPath.row;
                [weakSelf deletPictureWithIndex:index];
            };
            cell.extendBlock=^(NSInteger index){
                NSLog(@"大图");
                weakSelf.selectedRow = indexPath.row;
                [weakSelf bigPictureWithIndex:index];
            };
            return cell;

        }
       
    }
}


-(void)getCelldata:(AddDetailTableViewCell*)cell :(NSInteger)inex
{

      _titleArray=@[@"店铺名称",@"联系人",@"联系电话",@"工商注册号",@"行业类型",@"选择城市",@"详细地址",@"店铺位置",@"店铺模式",@"营业时间",@"起送金额",@"商户结算"];
    switch (inex) {
        case 0:
        {
            cell.inputText.text=self.shopName;
        }
            break;
        case 1:
        {
               cell.inputText.text=self.chargePerson;
        }
            break;
        case 2:
        {
               cell.inputText.text=self.shopPhoneNum;
            
        }
            break;
        case 3:
        {
            cell.inputText.text=self.businessNo;
            cell.inputText.keyboardType = UIKeyboardTypeNamePhonePad;
        }
            break;
        case 4:
        {
               cell.inputText.text=self.businessName;
        }
            break;
        case 5:
        {
            cell.inputText.text=_mainAdress;;
        }
            break;
        case 6:
        {
            cell.inputText.text=self.detailAdress;;
        }
            break;
        case 7:
        {
            //设置店铺位置
            //cell.inputText.text=self.detailAdress;;
        }
            break;
        case 8:
        {
            
            //cell.inputText.text=self.shopMode;
            if ([self.shopMode isEqualToString:@"01"]) {
                cell.inputText.text = @"餐厅";
            }else if ([self.shopMode isEqualToString:@"02"])
            {
                cell.inputText.text = @"快餐";
            }else if ([self.shopMode isEqualToString:@"03"])
            {
                cell.inputText.text = @"零售";
            }else
            {
                cell.inputText.text = @"生鲜";
            }
            
        }
            break;
        case 9:
        {
            //cell.inputText.text=self.workTime;
        }
            break;

        case 10:
        {
            cell.inputText.text=self.lestMoney;
            cell.inputText.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;

        case 11:
        {
            cell.inputText.text=self.ShopDiscount;
        }
            break;

        default:
            break;
    }
    
}
-(void)bigPictureWithIndex:(NSInteger)index
{
    if (self.selectedRow == _titleArray.count +1 ) {
        BigPictureViewController *big=[[BigPictureViewController alloc]init];
        UIImage *image=[UIImage imageWithData:_pictureArray[index]];
        big.image=image;
        [self presentViewController:big animated:YES completion:nil];
    }else
    {
        BigPictureViewController *big=[[BigPictureViewController alloc]init];
        UIImage *image=[UIImage imageWithData:_pictureArray1[index]];
        big.image=image;
        [self presentViewController:big animated:YES completion:nil];
    }
}
-(void)deletPictureWithIndex:(NSInteger)index
{
    if (self.selectedRow == _titleArray.count + 1) {
        [_pictureArray replaceObjectAtIndex:index withObject:@"uppic_2"];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+1 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
    }else
    {
        [_pictureArray1 replaceObjectAtIndex:index withObject:@"uppic_2"];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+2 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
    }
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data=UIImageJPEGRepresentation(image, 0.5f);
    
    if (self.selectedRow == _titleArray.count + 1) {
        [_pictureArray replaceObjectAtIndex:self.selectedIndex withObject:data];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+1 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
    }else
    {
        [_pictureArray1 replaceObjectAtIndex:self.selectedIndex withObject:data];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count+2 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
        }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_table)
    {
        return 0;
    }else
    {
           return 10;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_table)
    {
        return 44;
    }else
    {
        if (indexPath.row==_titleArray.count+1 || indexPath.row == _titleArray.count +2) {
            return 150;
        }else
         return 50;
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_table) {
      
        BusinessClassify *model=_busiTypeArray[indexPath.row];
        if (model.ParentNo.length)
        {
            self.businessType=model.classifyNo;
            self.businessName=model.classifyName;
            UITextField *textField=[self.tableview viewWithTag:5];
            textField.text=model.classifyName;
            [_table removeFromSuperview];
            [_coverView removeFromSuperview];
        }else
        {
            return;
        }
        
    }else
    {
        if (indexPath.row == 7) {
            if (self.cityName.length&&self.detailAdress.length )
            {
                MapFunViewController *pageController = [[MapFunViewController alloc]init];
                DefineWeakSelf;
                pageController.backBlock=^(NSString *latitude,NSString *longitude){
                    weakSelf.longitude=longitude;
                    weakSelf.latitude=latitude;
                    [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO] ;
                };
                pageController.city=self.cityName;
                pageController.detalAdress=self.detailAdress;
                pageController.district=self.AreaName;
                pageController.title=@"设置店铺坐标";
                [self.navigationController pushViewController:pageController animated:YES];
            }else
            {
                [self alertShowWithStr:@"请先选择城市填写详细地址后再设置坐标"];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 
    switch (textField.tag) {
        case 1:
        {
            //店铺名称
                CGRect rect=[textField convertRect:textField.frame toView:self.view];
                self.height=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 2:
        {
            //联系人
                CGRect rect=[textField convertRect:textField.frame toView:self.view];
                self.height=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 3:
        {
            //联系电话
                CGRect rect=[textField convertRect:textField.frame toView:self.view];
                self.height=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 4:
        {
           // 工商注册号
                CGRect rect=[textField convertRect:textField.frame toView:self.view];
                self.height=textField.frame.size.height+rect.origin.y+5;
        }
            break;
        case 5:
        {
            //行业类型
         [self.view endEditing:YES];
            [self createTableUI];
            
           
            return NO;
            
        }
            break;
        case 6:
        {
            //选择城市
             [self.view endEditing:YES];
                
                _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                [self.view addSubview:_coverView];
                _addressPickerView = [[IDAddressPickerView alloc] initWithFrame:CGRectMake(0, screen_height-250, screen_width, 250)];
                _addressPickerView.backgroundColor=[UIColor groupTableViewBackgroundColor];
                __weak typeof(self)weakSelf=self;
                _addressPickerView.backBlock=^(NSInteger index,NSMutableDictionary *dic){
                    if (index==1)
                    {
                        //取消
                        [weakSelf.coverView removeFromSuperview];
                        
                    }else
                    {
                        //确定
                        weakSelf.areaDic=dic;
                        
                        [weakSelf getprovinceCodeWithStr:dic[@"Province"]];
                        UITextField *textField=[weakSelf.tableview viewWithTag:6];
                        weakSelf.provinceName=dic[@"Province"];
                        weakSelf.cityName=dic[@"CityKey"];
                        weakSelf.AreaName=dic[@"AreaKey"];
                        NSMutableString *address=[NSMutableString stringWithString:dic[@"Province"]];
                        [address appendString:dic[@"CityKey"]];
                        [address appendString:dic[@"AreaKey"]];
                        textField.text=address;
                        _mainAdress=address;
                        [weakSelf.coverView removeFromSuperview];
                        
                    }
                };
                _addressPickerView.dataSource = self;
                [_coverView addSubview:_addressPickerView];
            
            
          
            return NO;
            
        }
            break;
        case 7:
        {
            //详细地址
                CGRect rect=[textField convertRect:textField.frame toView:self.view];
                self.height=textField.frame.size.height+rect.origin.y+5;
            
        }
            break;
        case 9:
        {
            //店铺模式
            UITextField *field = [self.view viewWithTag:9];
            ChoosePOSSetModeViewController *chooseVC = [[ChoosePOSSetModeViewController alloc] init];
            chooseVC.title = @"POS模式";
            chooseVC.tagNumber = 567;
            chooseVC.backBlock = ^(NSString *str){
                field.text = [str substringFromIndex:2];
                self.shopMode = [str substringToIndex:2];
            };
            [self.navigationController pushViewController:chooseVC animated:YES];
            return NO;
            
        }
            break;
            
        case 20:
        {
            //营业时间
            _is = YES;
            [self pickView];
            return NO;
            
        }
            break;
        case 21:
        {
            //关门时间
            _is = NO;
            [self pickView];
            return NO;
            
        }
            break;

            
        case 11:
        {
            //起送金额
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.height=textField.frame.size.height+rect.origin.y+5;
            
        }
            break;
            
        case 12:
        {
            //折扣
            _coverView=[[CoverView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
            _coverView.userInteractionEnabled=YES;

            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch)];
            [_coverView addGestureRecognizer:tap];
            _chooseView=[[MyDiscountChoseView alloc]initWithFrame:CGRectMake(0, self.view.height-300, self.view.width, 300)];
            DefineWeakSelf;
            _chooseView.buttBlock=^(NSString *str){
              
                textField.text=str;
                weakSelf.ShopDiscount=str;
                [weakSelf tapTouch];
                
            };
            [_coverView addSubview:_chooseView];
            [self.view addSubview:_coverView];
            return NO;
            
        }
            break;
            
        default:
            
            
            break;
    }
    
    return YES;
}

-(void)pickView
{
    [self createCover];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    
    //UIDatePicker显示样式
    
   
        _datePicker.datePickerMode =UIDatePickerModeTime;
        
        
        [_datePicker setLocale:[NSLocale systemLocale]];
   
    
    _datePicker.minuteInterval = 1;
    
    [_PickerView addSubview:_datePicker];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *defaultDate = [NSDate date];
    //    [NSDate dateWithTimeIntervalSince1970:[@"1460598080"doubleValue]];
    
    _datePicker.date = defaultDate;//设置UIDatePicker默认显示时间
    
    
}
-(void)createCover
{
    [self hideEdit];
    _coverView1=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView1.backgroundColor=[UIColor blackColor];
    _coverView1.alpha=0.3;
    [self.view.window addSubview:_coverView1];
    _PickerView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250)];
    _PickerView.backgroundColor=[UIColor whiteColor];
    [self.view.window addSubview:_PickerView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancel.frame = CGRectMake(10, 5, 40, 40);
    
    [cancel setTitle:@"取消"forState:UIControlStateNormal];
    
    [_PickerView addSubview:cancel];
    
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    commit.frame = CGRectMake(self.view.frame.size.width-50, 5, 40, 40);
    
    [commit setTitle:@"确定"forState:UIControlStateNormal];
    
    [_PickerView addSubview:commit];
    
    [commit addTarget:self action:@selector(commitB) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hideEdit
{
    [self.view endEditing:YES];
}

-(void)commitB{

    if (_datePicker) {
        NSLog(@"_datePicker");
        
        NSDateFormatter *forma = [[NSDateFormatter alloc]init];
        
        [forma setDateFormat:@"HH:mm"];
        
        NSString *str = [forma stringFromDate:_datePicker.date]; //UIDatePicker显示的时间
        
        
        if (_is)
        {
            UITextField *field=(UITextField*)[self.view viewWithTag:20];
            field.text=str;
            self.startTime=str;
        }else
        {
            UITextField *field=(UITextField*)[self.view viewWithTag:21];
            field.text=str;
            self.endTime=str;
        }
        
        
    }
    
    [self cancel];

    
    
}
-(void)cancel
{
    
    [_datePicker removeFromSuperview];
    [_PickerView removeFromSuperview];
    [_coverView1 removeFromSuperview];
}


-(void)tapTouch
{
    
    [_chooseView removeFromSuperview];
    [_coverView removeFromSuperview];

    
}
-(void)changeWithStr:(NSString*)str
{
    UITextField *filed=(UITextField*)[self.tableview viewWithTag:1];
    filed.text=str;
}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    switch (textField.tag) {
        case 1:
        {
            //店铺名称
            self.shopName=textField.text;
            NSLog(@"self.shopName:%@",self.shopName);
            
        }
            break;
        case 2:
        {
            //联系人
            self.chargePerson=textField.text;
            NSLog(@"self.chargePerson:%@", self.chargePerson);
            
            
        }
            break;
        case 3:
        {
            //联系电话
            self.shopPhoneNum=textField.text;
            NSLog(@"self.phoneNum:%@",self.shopPhoneNum);
          
            
        }
            break;
        case 4:
        {
            //工商注册号
            self.businessNo=textField.text;
            NSLog(@"businessNo:%@",self.businessNo);
        
            
        }
            break;
        case 5:
        {
            //行业类型
      
            
        }
            break;
        case 6:
        {
            //选择城市
        
            
        }
            break;
        case 7:
        {
            //选择城市
            //详细地址
            self.detailAdress=textField.text;
            NSLog(@"self.detailAdress:%@", self.detailAdress);
            
        }
            break;
        case 8:
        {
            //店铺模式
            NSLog(@"11111");
            
        }
            break;
        case 9:
        {
            //营业时间
              NSLog(@"22222222");
        }
            break;
        case 10:
        {
          
        }
            break;
    
        default:
        {
            //起送金额
            self.lestMoney=textField.text;
            NSLog(@"self.detailAdress:%@", self.lestMoney);
            
            
            
        }
            
            break;
    }
    
}

-(void)createTableUI
{
   
    _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor=  [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:_coverView];
    _table = [[UITableView alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    [_coverView addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_coverView.mas_top).offset(100);
        make.left.mas_equalTo(_coverView.mas_left).offset(30);
        make.right.mas_equalTo(_coverView.mas_right).offset(-30);
        make.bottom.mas_equalTo(_coverView.mas_bottom).offset(-100);
    }];
    [_table rounded:4 width:1 color:[UIColor whiteColor]];
    
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
- (IBAction)done:(UIButton *)sender
{

    NSLog(@"%@",self.shopName);
    NSLog(@"%@",self.detailAdress);
     NSLog(@"%@",self.businessType);
     NSLog(@"%@",self.shopPhoneNum);
     NSLog(@"%@",self.passWordNum);
     NSLog(@"%@",self.businessNo);
     NSLog(@"%@",self.chargePerson);
     NSLog(@"%@",self.detailAdress);
     NSLog(@"%@",self.provinceName);
     NSLog(@"%@",self.ShopDiscount);
     NSLog(@"%@",self.lestMoney);
     NSLog(@"%@",self.shopMode);
    if (self.shopName.length&&self.detailAdress.length&&self.businessType.length&&self.shopPhoneNum.length&&self.passWordNum.length&&self.businessNo.length&&self.chargePerson.length&&self.detailAdress.length&&self.provinceName.length&&self.ShopDiscount.length&&self.lestMoney&&self.shopMode) {
        if (self.longitude.length&&self.latitude.length)
        {
            if (_pictureArray1.count == 2&&[_pictureArray1[0] isKindOfClass:[NSData class]]&&[_pictureArray1[1] isKindOfClass:[NSData class]]) {
                
            
            if (_pictureArray.count==1&&[_pictureArray[0] isKindOfClass:[NSData class]])
            {
                if (self.startTime.length&&self.endTime.length) {
                    self.workTime = [NSString stringWithFormat:@"%@-%@",self.startTime,self.endTime];
                 [SVProgressHUD showWithStatus:@"加载中"];
                NSArray *jsonArray;
                jsonArray=@[@{@"ShopName":self.shopName,@"ShopCategory":self.businessType,@"Phone":self.shopPhoneNum,@"Mobile":self.phoneNum,@"Password":self.passWordNum,@"License":self.businessNo,@"Contact":self.chargePerson,@"Longitude":self.longitude,@"Latitude":self.latitude,@"Address":self.detailAdress,@"provCode":self.provinceCode,@"provName":self.provinceName,@"cityCode":self.cityCode,@"UDF02":self.shopMode,@"UDF03":self.workTime,@"UDF07":self.lestMoney,@"cityName":self.cityName,@"boroCode":self.AreaCode,@"boroName":self.AreaName,@"ShopDiscount":[NSString stringWithFormat:@"%f",_ShopDiscount.floatValue/10]}];
                NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonArray options:kNilOptions error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
                NSString *LogoUrl = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString *LicensePhoto = [_pictureArray1[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString *IDPhoto = [_pictureArray1[1] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
           
                NSDictionary *dic=@{@"ShopJson":jsonStr,@"LicensePhoto":LicensePhoto,@"IDPhoto":IDPhoto,@"LogoUrl":LogoUrl,@"CipherText":CIPHERTEXT};
                [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"crminfoservice.asmx/AddShop" With:dic and:^(id responseObject) {
                    [SVProgressHUD dismiss];
                    NSDictionary *dic1=[JsonTools getData:responseObject];
                    
                    if ([dic1[@"message"] isEqualToString:@"OK"])
                    {
                        [self alertShowWithStr:@"恭喜您注册成功^_^ 审核将在2小时内完成，请您耐心等待!"];
                        
                    }else
                    {
                        [self alertShowWithStr:dic1[@"message"]];
                    }
                    
                } Faile:^(NSError *error) {
                    
                    NSLog(@"失败%@",error);
                }];
                    
                }else
                {
                    [self alertShowWithStr:@"请选择营业时间"];
                }
                
            }else
            {
                [self alertShowWithStr:@"请上传店铺图片"];
                
            }
           
            }else
            {
                [self alertShowWithStr:@"请上传营业执照身份证等图片"];
            }
            
        }else
        {
             [self alertShowWithStr:@"请设置地图获取定位信息"];
        }
        
    }else
    {
        [self alertShowWithStr:@"请填写完整信息"];
    }
    
 
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [alert addAction:action2];
    UIAlertAction *action;
    if ([str containsString:@"成功"]) {
        
            action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
    }else
    {
             action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    }


      
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)addKeyBoardNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark--键盘事件
//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    NSLog(@"弹起");
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    offset = self.height - (self.view.frame.size.height - kbHeight);
    
    
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    NSLog(@"键盘消失");
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)addLefttButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [right setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem=right;
}
-(void)commit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
