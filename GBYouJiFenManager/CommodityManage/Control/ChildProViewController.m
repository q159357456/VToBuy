//
//  ChildProViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/8.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ChildProViewController.h"
#import "AddDetailTableViewCell.h"
#import "AddDetailTwoTableViewCell.h"
#import "CombFirstTableViewCell.h"
#import "UpPictureTableViewCell.h"
#import "BigPictureViewController.h"
#import "FMDBMember.h"
#import "MemberModel.h"
@interface ChildProViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tabview;
@property(nonatomic,strong)NSArray *titleArray;
@property (strong, nonatomic) IBOutlet UIButton *doenButton;
@property(nonatomic,copy)NSMutableArray *pictureArray;
@property(nonatomic,assign)NSInteger selectedIndex;
/**
 上传商品信息参数
 */
@property(nonatomic,copy)NSString *ProductName;
@property(nonatomic,copy)NSString *RetailPrice;
@property(nonatomic,copy)NSString *SellPrice1;
@property(nonatomic,copy)NSString *IsUpDown;
@property(nonatomic,copy)NSString *IsReceive;
@end

@implementation ChildProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
     _titleArray=@[@"商品名称",@"零售价",@"会员价",@"上架否",@"招待否"];
    _doenButton.backgroundColor=MainColor;
    _pictureArray=[NSMutableArray array];
    [self getAllData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)getAllData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$Property$=$C$AND$ProductNo$=$%@",model.SHOPID,_model.ProductNo];
    NSDictionary *dic=@{@"FromTableName":@"inv_product",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
       
        NSArray *dataArray=[ProductModel getDataWithDic:dic1];
        ProductModel *model=dataArray[0];
        [self initDataWithModel:model];
        [self.tabview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

-(NSString*)ProductName
{
    if (!_ProductName) {
        _ProductName=@"";
    }
    return _ProductName;
}
-(NSString*)RetailPrice
{
    if (!_RetailPrice) {
        _RetailPrice=@"";
    }
    return _RetailPrice;
}
-(NSString*)SellPrice1
{
    if (!_SellPrice1) {
        _SellPrice1=@"";
    }
    return _SellPrice1;
}
-(void)initDataWithModel:(ProductModel*)model
{
    if (model.ProductName.length) {
        _ProductName=model.ProductName;
    }
    if (model.RetailPrice.length) {
        _RetailPrice=model.RetailPrice;
    }
    if (model.SellPrice1.length) {
   ;
        _SellPrice1=model.SellPrice1;
    }
    if (model.IsUpDown.length) {
     
        _IsUpDown=model.IsUpDown;
    }else
    {
        _IsUpDown=@"True";
    }
    if (model.IsReceive.length)
    {
        _IsReceive=model.IsReceive;
    }else
    {
        _IsReceive=@"True";
    }
    if (model.PicAddress1.length) {
        NSString *str=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1];
        NSString *urlStr=[str URLEncodedString];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        [_pictureArray insertObject:data atIndex:0];
    }else
    {
          [_pictureArray addObject:@"uppic_2"];
    }
    
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
    [self.tabview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6  inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
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
    [self.tabview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0] ]withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArray.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//       _titleArray=@[@"商品名称",@"零售价",@"会员价",@"上架否",@"招待否"];
   static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
    switch (indexPath.row) {
        case 0:
        {
           
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            cell.nameLable.text=_titleArray[indexPath.row];
            cell.inputText.text=_ProductName;
            cell.inputText.tag=indexPath.row;
            cell.inputText.delegate=self;
            return cell;
        }
            break;
        case 1:
        {
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
             cell.nameLable.text=_titleArray[indexPath.row];
            cell.inputText.text=_RetailPrice;
            cell.inputText.tag=indexPath.row;
             cell.inputText.delegate=self;
            return cell;
        }
            break;
        case 2:
        {
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
             cell.nameLable.text=_titleArray[indexPath.row];
            cell.inputText.text=_SellPrice1;
            cell.inputText.tag=indexPath.row;
             cell.inputText.delegate=self;
            return cell;
            
        }
            break;
        case 3:
        {
            
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
           
            cell.textLabel.text=@"上架否";
            if ([self.IsUpDown isEqualToString:@"True"])
                {
                    cell.choseSegMent.selectedSegmentIndex=0;
              
                }else
                {
                    cell.choseSegMent.selectedSegmentIndex=1;
                }
            DefineWeakSelf;
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.IsUpDown=str;
                
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 4:
        {
            AddDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"AddDetailTwoTableViewCell" owner:nil options:nil][0];
            
            cell.textLabel.text=@"招待否";
//            NSLog(@"--%@",self.IsUpDown);

            if ([self.IsReceive isEqualToString:@"True"])
            {
                cell.choseSegMent.selectedSegmentIndex=0;
                
            }else
            {
                cell.choseSegMent.selectedSegmentIndex=1;
            }
            DefineWeakSelf;
            cell.statuseBlock=^(NSString *str){
                
                weakSelf.IsReceive=str;
                
                
            };
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 5:
        {
            UITableViewCell *cell=[[UITableViewCell alloc]init];
            cell.textLabel.text=@"菜品图片上传";
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 6:
        {
            UpPictureTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"UpPictureTableViewCell" owner:nil options:nil][0];
            //        cell.dataArray=self.pictureArray;
            [cell setDataArrayWithStr:2 :self.pictureArray];
            DefineWeakSelf;
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
            break;
            
        default:
            break;
    }
        return nil;

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
        {
            _ProductName=textField.text;
        }
            break;
        case 1:
        {
             _RetailPrice=textField.text;
        }
            break;
        case 2:
        {
             _SellPrice1=textField.text;
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row==6)
    {
        return 102;
    }else
        return 50;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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

-(void)editProduct
{
    [SVProgressHUD showWithStatus:@"加载中"];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSDictionary *jsonDic;
    jsonDic=@{@"Command":@"Edit",@"TableName":@"Inv_Product",@"Data":@[@{@"COMPANY":model.COMPANY,@"SHOPID":model.SHOPID,@"CREATOR":@"admin",@"Classify_2":_model.Classify_2,@"ProductName":self.ProductName,@"IsUpDown":_IsUpDown,@"RetailPrice":self.RetailPrice,@"ProductNo":_model.ProductNo,@"SellPrice1":self.SellPrice1,@"IsReceive":_IsReceive,@"Property":@"C"}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"----%@",jsonStr);
    NSString *encodedImageStr;
     if ([_pictureArray[0]isKindOfClass:[NSData class]])
     {
        encodedImageStr = [_pictureArray[0] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
     }else
     {
         encodedImageStr=@"";
     }
  
   
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":encodedImageStr,@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD dismiss];
           [self alertShowWithStr:@"信息保存成功"];
            
            
        }else
        {
            [SVProgressHUD dismiss];
            [self alertShowWithStr:str];
        }
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
- (IBAction)done:(UIButton *)sender
{
    [self editProduct];
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
