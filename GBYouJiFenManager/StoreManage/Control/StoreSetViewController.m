//
//  StoreSetViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/12.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "StoreSetViewController.h"
#import "AddDetailTableViewCell.h"
#import "StoreOneTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "IDAddressPickerView.h"
#import "RegionModel.h"
#import "StoreThreeTableViewCell.h"
#import "UpPictureViewController.h"
#import "StorePreviewViewController.h"
#import "CoverView.h"
#import "MapFunViewController.h"
#import <IQKeyboardManager.h>
#import "BusinessAreaViewController.h"
#import "ChooseTipsView.h"
@interface StoreSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IDAddressPickerViewDataSource,UITextViewDelegate,UITextViewDelegate>
{
    float offset;
}
@property(nonatomic,strong)CoverView *coverView;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)MemberModel *model;
@property (nonatomic, strong)IDAddressPickerView *addressPickerView;
@property(nonatomic,strong)NSMutableDictionary *areaDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,strong)NSMutableArray *citypeArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,assign)float height;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
/**
 参数
 */
@property(nonatomic,copy)NSString *Contact;
@property(nonatomic,copy)NSString *phone ;
@property(nonatomic,copy)NSString *region ;
@property(nonatomic,copy)NSString *detailAdress ;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *provinceCode;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *AreaName;
@property(nonatomic,copy)NSString *AreaCode;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic,copy)NSString *ShopCategory;
@property(nonatomic,copy)NSString *circleCode;
@property(nonatomic,copy)NSString *circleName;
/**
 营业时间
 */
@property(nonatomic,copy)NSString *UDF02;
/**
 起送金额
 */
@property(nonatomic,copy)NSString *UDF07;
//参与抽奖
@property(nonatomic,copy)NSString *isUpdate;


@property(nonatomic,strong)UISwitch *drawSwitch;


@end

@implementation StoreSetViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.translucent=YES;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.translucent=NO;
    //[[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _dataArray=[NSMutableArray array];
    _provinceArray=[NSMutableArray array];
    _citypeArray=[NSMutableArray array];
    _areaArray=[NSMutableArray array];
    _doneButton.backgroundColor=MainColor;
   //获得初始值
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    self.phone=self.model.Phone;
    self.Contact=self.model.Contact;
    self.provinceName=self.model.provName;
    self.cityName=self.model.cityName;
    self.AreaName=self.model.boroName;
    self.provinceCode=self.model.provCode;
    self.cityCode=self.model.cityCode;
    self.AreaCode=self.model.boroCode;
    self.detailAdress=self.model.Address;
    self.latitude=self.model.Latitude;
    self.longitude=self.model.Longitude;
    self.Remark=self.model.Remark;
    self.isUpdate = self.model.IsUpdate;
    self.circleCode = self.model.circleCode?self.model.circleCode:@"";
    self.circleName = self.model.circleName?self.model.circleName:@"";
    [self getbusinessDataWithStr:self.model.ShopCategory];
    //[self addKeyBoardNotify];
    _titleArray=@[@"店铺名称",@"店铺图标",@"店铺电话",@"联系人",@"行业类型",@"商户结算",@"地区",@"详细地址",@"商圈",@"坐标",@"参与抽奖"];
    _tableview.hidden=YES;
    [self addRightButton];
    self.keyTableView = _tableview;
    [ChooseTipsView startChooseTipsCallBack:^(NSString * _Nonnull values) {
        
    }];
}
-(void)addRightButton
{

    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 35);
    [button setTitle:@"预览" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"yulan"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(yulan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=right;
 
}
-(void)yulan
{
    //店铺预览
    
                StorePreviewViewController *comm=[[StorePreviewViewController alloc]init];
                comm.title=@"店铺预览";
                [comm setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:comm animated:YES];
}
#pragma mark - IDAddressPickerViewDataSource
- (NSArray *)addressArray {
    return _dataArray;
}
-(void)getbusinessDataWithStr:(NSString*)str
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *condition=[NSString stringWithFormat:@"classifytype$=$05$AND$ClassifyNo$=$%@",self.model.ShopCategory];
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"----%@",dic1);
        [self changeWithStr:dic1[@"DataSet"][@"Table"][0][@"ClassifyName"]];
        [self getprovinceData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
    
}
#pragma mark--delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row<_titleArray.count)
    {
        if (indexPath.row==1)
        {
            StoreOneTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"StoreOneTableViewCell" owner:nil options:nil][0];
            cell.nameLable.text=_titleArray[indexPath.row];
            NSString *path=[NSString stringWithFormat:@"%@/%@",PICTUREPATH,_model.LogoUrl];
            NSString *codePath=[path URLEncodedString];
            [cell.shopPic sd_setImageWithURL:[NSURL URLWithString:codePath] placeholderImage:[UIImage imageNamed:@"placeholder_2"]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            static NSString *AddDetailTableViewCell_ID = @"AddDetailTableViewCell_id";
            AddDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDetailTableViewCell_ID];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"AddDetailTableViewCell" owner:nil options:nil][0];
            }
            //参与抽奖
            if (indexPath.row == 10) {
                cell.nameLable.text=_titleArray[indexPath.row];
                cell.inputText.enabled = NO;
                _drawSwitch = [[UISwitch alloc]init];
                [cell addSubview:_drawSwitch];
                [_drawSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell).offset(-WIDTH_PRO(15));
                    make.centerY.equalTo(cell);
                }];
                [_drawSwitch addTarget:self action:@selector(trunOnWith:) forControlEvents:UIControlEventValueChanged];
                [_drawSwitch setOn:[self.isUpdate isEqualToString:@"True"]?YES:NO];
            }else{
                if (indexPath.row==9) {
                    //坐标
                    cell.inputText.textAlignment = NSTextAlignmentRight;
                    cell.inputText.enabled=NO;
                }
                if (indexPath.row == 8) {
                    //商圈
                    cell.inputText.enabled=NO;
                    
                }
                cell.nameLable.text=_titleArray[indexPath.row];
                cell.inputText.delegate=self;
                cell.inputText.tag=indexPath.row+1;
                [self swich:cell :indexPath.row];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if (indexPath.row==_titleArray.count-2) {
                    //传照片
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    cell.inputText.enabled=NO;
                }
            }
            return cell;

        }
    }else if(indexPath.row==_titleArray.count)
    {
        StoreThreeTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"StoreThreeTableViewCell" owner:nil options:nil][0];
        cell.textview.delegate=self;
        cell.textview.text=self.Remark;
        return cell;
    }else
    {
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.textLabel.text=@"店铺环境图片上传";
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    return nil;
    
}

#pragma mark - 张卫煌添加 开启关闭 抽奖
-(void)trunOnWith:(UISwitch *)swith{
//    NSLog(@"abc");
    self.isUpdate = [self.isUpdate isEqualToString:@"True"]?@"False":@"True";
}

-(void)swich:(AddDetailTableViewCell*)cell :(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            //店铺名称
            cell.inputText.text=_model.ShopName;
            
        }
            break;
        case 1:
        {
            //店铺图标
            
        }
            break;
        case 2:
        {
            //店铺电话
            cell.inputText.textColor=[UIColor blackColor];
              cell.inputText.text=_model.Phone;
        }
            break;
        case 3:
        {
            //联系人
             cell.inputText.textColor=[UIColor blackColor];
              cell.inputText.text=_model.Contact;
            
        }
            break;
        case 4:
        {
             //行业类型
             cell.inputText.text=self.ShopCategory;
            
        }
            break;
        case 5:
        {
             //折扣
            float dis = [_model.ShopDiscount floatValue]*10;
            NSString *disStr = [NSString stringWithFormat:@"%.1f折",dis];
            cell.inputText.text=disStr;
            
        }
            break;
        case 6:
        {
             //地区
             cell.inputText.textColor=[UIColor blackColor];
            NSMutableString *add=[NSMutableString stringWithString:_model.provName];
            [add appendString:_model.cityName];
            [add appendString:_model.boroName];
              cell.inputText.text=add;
            
        }
            break;
        case 7:
        {
             //详细地址
             cell.inputText.textColor=[UIColor blackColor];
              cell.inputText.text=_model.Address;
            
        }
            break;
        case 8:
        {
            //商圈
            cell.inputText.textColor=[UIColor blackColor];
            cell.inputText.text=self.circleName;
            
        }
            break;
        case 9:
        {
             //坐标
             cell.inputText.textColor=[UIColor blackColor];
              cell.inputText.text=@"已设置";
            
        }
            break;
            
            
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row==_titleArray.count) {
        return 100;
    }else
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    if (indexPath.row==_titleArray.count+1)
    {
        UpPictureViewController *pic=[[UpPictureViewController alloc]init];
        pic.title=@"上传图片";
        [self.navigationController pushViewController:pic animated:YES];
    }
    if (indexPath.row==9) {
        NSLog(@"介入地图");
        if (self.cityName.length&&self.detailAdress.length)
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
    
    if (indexPath.row==8){
        //商圈
        if (!self.AreaCode.length) {
            [QMUITips showInfo:@"请先选择地址才能选择商圈"];
            return;
        }
        BusinessAreaViewController *vc = [[BusinessAreaViewController alloc]init];
        vc.boroCode = self.AreaCode;
        DefineWeakSelf;
        vc.callBack = ^(NSString * _Nonnull circleName, NSString * _Nonnull circleCode){
            weakSelf.circleName = circleName;
            weakSelf.cityCode = circleCode;
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO] ;
            
        };
        [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark textfield
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
        {
            return NO;
            //店铺名称
            
        }
            break;
        case 3:
        {
            //获取textfiled在view上的frame
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.height=textField.frame.size.height+rect.origin.y+5;
            return YES;
            //店铺电话
            
            
        }
            break;
        case 4:
        {
            //获取textfiled在view上的frame
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.height=textField.frame.size.height+rect.origin.y+5;
            return YES;
            //联系人
            
            
        }
            break;
        case 5:
        {
            //行业类型
            return NO;
            
            
        }
            break;
        case 6:
        {
            //折扣
            return NO;
            
        }
            break;
        case 7:
        {
            //地区
          
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
                        UITextField *textField=[weakSelf.tableview viewWithTag:7];
                        weakSelf.provinceName=dic[@"Province"];
                        weakSelf.cityName=dic[@"CityKey"];
                        weakSelf.AreaName=dic[@"AreaKey"];
                        
                        NSMutableString *address=[NSMutableString stringWithString:dic[@"Province"]];
                        [address appendString:dic[@"CityKey"]];
                        [address appendString:dic[@"AreaKey"]];
                        textField.text=address;
                        weakSelf.region=address;
                        [weakSelf.coverView removeFromSuperview];
                        
                    }
                };
                _addressPickerView.dataSource = self;
                [_coverView addSubview:_addressPickerView];
          
            

            return NO;
            
            
        }
            break;
        case 8:
        {
            //详细地址
            //获取textfiled在view上的frame
            CGRect rect=[textField convertRect:textField.frame toView:self.view];
            self.height=textField.frame.size.height+rect.origin.y+5;
            return YES;
            
            
        }
            break;
        case 9:
        {
            //商圈
            return NO;
            
            
        }
            break;
        case 10:
        {
            //坐标设置
            return NO;
            
            
        }
            break;
            
        default:
            
            
            break;
    }
    
    return YES;
}
-(void)getprovinceCodeWithStr:(NSString*)str
{
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"CMS_Provice",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"provName$=$%@",str],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        
        NSDictionary *dic1=[JsonTools getData:responseObject];
        //        NSLog(@"%@",dic1);
        self.provinceCode=dic1[@"DataSet"][@"Table"][0][@"provCode"];
        
    
        
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
        [self getprovinceData];
        [self getAllData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
#pragma mark--data

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
        _tableview.hidden=NO;
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
            
            //            NSMutableArray *area=[NSMutableArray array];
            
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

-(void)changeWithStr:(NSString*)str
{
    UITextField *filed=(UITextField*)[self.tableview viewWithTag:5];
    filed.text=str;
    _ShopCategory=str;
}
-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
    switch (textField.tag) {
        case 1:
        {
       
            //店铺名称
            
            
        }
            break;
        case 3:
        {
          
            //店铺电话
            
            self.phone=textField.text;
            
            
        }
            break;
        case 4:
        {
            
            //联系人
            self.Contact=textField.text;
            NSLog(@"%@",self.Contact);
            
            
        }
            break;
        case 5:
        {
            //行业类型
          
            
            
        }
            break;
        case 6:
        {
            //折扣
         
            
        }
            break;
        case 7:
        {
            //地区
            
            
            
        }
            break;
        case 8:
        {
            //详细地址
               self.detailAdress=textField.text;
        
            
            
        }
            break;
        case 9:
        {
          
            
            
        }
            break;
            
        default:
            
            
            break;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.Remark=textView.text;
    NSLog(@"店铺简介:%@",self.Remark);
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rect=[textView convertRect:textView.frame toView:self.view];
    self.height=textView.frame.size.height+rect.origin.y+5;
    return YES;
   
}
- (IBAction)done:(UIButton *)sender
{
    if (self.phone.length==0||self.Contact.length==0||self.provinceName.length==0||self.detailAdress.length==0)
    {
  
        [self alertShowWithStr:@"资料没有填写完整"];
        
    }else
    {
     
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认修改信息？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self change];
            
        }];
        [alert addAction:action];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
       
        
    }
}
-(void)change
{
    //修改店铺信息
    [SVProgressHUD showWithStatus:@"加载中"];
    if (!self.Remark.length) {
        self.Remark=@"";
    }
    NSDictionary *jsonDic;
    jsonDic=@{@"Command":@"Edit",@"TableName":@"CMS_Shop",@"Data":@[@{@"Latitude":self.latitude,@"Contact":self.Contact,@"cityName":self.cityName,@"boroName":self.AreaName,@"Phone":self.phone,@"cityCode":self.cityCode,@"provName":self.provinceName,@"Longitude":self.longitude,@"Address":self.detailAdress,@"boroCode":self.AreaCode,@"provCode":self.provinceCode,@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"Remark":self.Remark,@"IsUpdate":self.isUpdate,@"circleCode":self.circleCode,@"circleName":self.circleName}]};
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        NSString *str=[JsonTools getNSString:responseObject];
        NSLog(@"-----%@",str);
        if ([str isEqualToString:@"OK"])
        {
            self.model=[[FMDBMember shareInstance]getMemberData][0];
            self.model.Phone=self.phone;
            self.model.Contact=self.Contact;
            self.model.provName=self.provinceName;
            self.model.cityName=self.cityName;
            self.model.boroName=self.AreaName;
            self.model.provCode=self.provinceCode;
            self.model.cityCode=self.cityCode;
            self.model.boroCode=self.AreaCode;
            self.model.Address=self.detailAdress;
            self.model.Latitude=self.latitude;
            self.model.Longitude=self.longitude;
            self.model.Remark=self.Remark;
            self.model.IsUpdate = self.isUpdate;
            self.model.circleName = self.circleName;
            self.model.circleCode = self.circleCode;
            [[FMDBMember shareInstance]updateUser:self.model];
            [self alertShowWithStr:@"修改成功"];
            
        }else
        {
            [self alertShowWithStr:@"修改失败,稍后再试"];
        }
        
        
    } Faile:^(NSError *error) {
        
        NSLog(@"失败%@",error);
    }];

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
          
            [self.navigationController  popViewControllerAnimated:YES];
        }];
    }else
    {
        action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    }
    
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
