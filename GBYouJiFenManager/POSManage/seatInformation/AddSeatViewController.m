//
//  AddSeatViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/7/14.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "AddSeatViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "FloorModel.h"
#import "RoomTypeModel.h"
#import "ChooseTableViewCell.h"
#import "SeatSetViewController.h"
#import "NoneView.h"
#import "CoverView.h"
@interface AddSeatViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *zwhzuoButton;
@property (weak, nonatomic) IBOutlet UITextField *zwhzuoTextfield;
@property (weak, nonatomic) IBOutlet UIView *zwhzuoView;
@property (strong, nonatomic) IBOutlet UITextField *areaTextfield;
@property (strong, nonatomic) IBOutlet UIButton *areaButton;
@property (strong, nonatomic) IBOutlet UITextField *typeTextfield;
@property (strong, nonatomic) IBOutlet UIButton *typeButton;
@property (strong, nonatomic) IBOutlet UIView *areaView;
@property (strong, nonatomic) IBOutlet UIView *typeView;
@property (strong, nonatomic) IBOutlet UIView *seatView;
@property (strong, nonatomic) IBOutlet UIView *personView;
@property (strong, nonatomic) IBOutlet UIButton *typeSetButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *reserveButton;
@property (strong, nonatomic) IBOutlet UIButton *areaSetButton;
@property(nonatomic,strong)CoverView *coverView;
@property(nonatomic,strong)NoneView *noneView;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *typeArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *zwhzuoArray;
@property(nonatomic,strong)NSMutableArray *typeInAreaArray;
@property(nonatomic,strong)MemberModel *model;
@property(strong,nonatomic)UITableView *table;
@property(nonatomic,copy)NSString *areaNo;
@property(nonatomic,copy)NSString *typeNo;
@property(nonatomic,copy)NSString *zuoNo;
@property(nonatomic,copy)NSString *reserver;
@property(nonatomic,copy)NSString *see;
@property(nonatomic,assign)BOOL is;
@property(nonatomic,copy)NSString *modelType;
@property (strong, nonatomic) IBOutlet UITextField *seatTextfield;
//@property (strong, nonatomic) IBOutlet UIButton *reserverButton;
@property (strong, nonatomic) IBOutlet UIButton *seeButton;
@property (strong, nonatomic) IBOutlet UITextField *personCountTextFiied;

@end

@implementation AddSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addEvent];
    [self getAreaArraydata];
 
    [self initButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"changeSuccess" object:nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)change:(NSNotification*)info
{
    self.modelType=info.userInfo[@"Type"];
    [self getAreaArraydata];
}

-(void)initButton
{
   
    if (_seatModel)
    {
        _areaNo=_seatModel.floorArea;
        _typeNo=_seatModel.roomType;
        _reserver=_seatModel.isBook;
        _see=_seatModel.isValid;
        _seatTextfield.text=_seatModel.roomName;
        _typeTextfield.text=_seatModel.ST002;
        _areaTextfield.text=_seatModel.AF002;
        _personCountTextFiied.text=_seatModel.SI007;
        _zwhzuoTextfield.text = _seatModel.UDF06;
        _zuoNo = _seatModel.SI017;
//        _areaTextfield.text=_seatModel.isProxy;
        //如果此房台的区域被删除在此处提示去创建
//        if (!_seatModel.itemNo.length) {
//            
//        }
        
    }else
    {
        
        self.reserver=@"True";
        self.see=@"True";
    }
    if (_reserver.boolValue) {
        _reserveButton.selected=YES;
    }else
    {
        _reserveButton.selected=NO;
    }
 
    if (_see.boolValue) {
        _seeButton.selected=YES;
    }else
    {
        _seeButton.selected=NO;
    }
   
    [_seeButton setBackgroundImage:[UIImage imageNamed:@"slected_1"] forState:UIControlStateNormal];
    [_seeButton setBackgroundImage:[UIImage imageNamed:@"slected_2"] forState:UIControlStateSelected];
    [_reserveButton setBackgroundImage:[UIImage imageNamed:@"slected_1"] forState:UIControlStateNormal];
    [_reserveButton setBackgroundImage:[UIImage imageNamed:@"slected_2"] forState:UIControlStateSelected];

    
    
}
-(void)createTableUIWithField:(UITextField*)textFied Array:(NSMutableArray*)array
{
    if (textFied==_areaTextfield)
    {
        _is=YES;
    }else
    {
        _is=NO;
    }
    
    self.dataArray=array;
    if ([self.view.subviews containsObject:_table])
    {
        [_table reloadData];
    }else
    {
        _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.isClick=YES;
        _coverView.click=^{
            textFied.text=nil;
            
        };
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:_coverView];
        _table = [[UITableView alloc] init];
        _table.delegate = self;
        _table.dataSource = self;
        [_coverView addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textFied.mas_bottom);
            make.left.mas_equalTo(textFied.mas_left);
            make.right.mas_equalTo(textFied.mas_right).offset(50);
            make.height.mas_equalTo(array.count*44);
            
        }];
        _table.layer.borderWidth=1;
        _table.layer.borderColor=[UIColor lightGrayColor].CGColor;

    }
}

-(MemberModel *)model
{
    if (!_model) {
        _model=[[FMDBMember shareInstance]getMemberData][0];
    }
    return _model;
}
-(NSMutableArray*)typeArray
{
    if (!_typeArray) {
        _typeArray=[NSMutableArray array];
    }
    return _typeArray;
}
-(NSMutableArray*)areaArray
{
    if (!_areaArray) {
        _areaArray=[NSMutableArray array];
    }
    return _areaArray;
    
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
    
}
-(NSMutableArray*)typeInAreaArray
{
    if (!_typeInAreaArray) {
        _typeInAreaArray=[NSMutableArray array];
    }
    return _typeInAreaArray;
    
}

-(void)addEvent
{
    self.seatView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.seatView.layer.borderWidth=1;
    self.seatView.layer.cornerRadius=2;
    self.seatView.layer.masksToBounds=YES;
    self.typeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.typeView.layer.borderWidth=1;
    self.typeView.layer.cornerRadius=2;
    self.typeView.layer.masksToBounds=YES;
    self.areaView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.areaView.layer.borderWidth=1;
    self.areaView.layer.cornerRadius=2;
    self.areaView.layer.masksToBounds=YES;
    self.zwhzuoView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.zwhzuoView.layer.borderWidth=1;
    self.zwhzuoView.layer.cornerRadius=2;
    self.zwhzuoView.layer.masksToBounds=YES;
    self.personView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.personView.layer.borderWidth=1;
    self.personView.layer.cornerRadius=2;
    self.personView.layer.masksToBounds=YES;
    self.areaSetButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.areaSetButton.layer.borderWidth=1;
    self.areaSetButton.layer.cornerRadius=2;
    self.areaSetButton.layer.masksToBounds=YES;
    self.typeSetButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.typeSetButton.layer.borderWidth=1;
    self.typeSetButton.layer.cornerRadius=2;
    self.typeSetButton.layer.masksToBounds=YES;
    self.reserveButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.reserveButton.layer.borderWidth=1;
    self.reserveButton.layer.cornerRadius=2;
    self.reserveButton.layer.masksToBounds=YES;
    
    if (_seatModel)
    {
        [self.doneButton setTitle:@"编辑房台" forState:UIControlStateNormal];
    }
    self.doneButton.backgroundColor=MainColor;
    _areaTextfield.delegate=self;
    _typeTextfield.delegate=self;
    [_areaTextfield addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_typeTextfield addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)textFieldTextDidChange:(UITextField *)textfield
{
 
    if (textfield==_areaTextfield)
    {
     
           NSMutableArray *array=[NSMutableArray array];
        if (textfield.text.length==0) {
            _typeTextfield.text=nil;
            if ([_coverView.subviews containsObject:_noneView]) {
                [_coverView removeFromSuperview];
                [_noneView removeFromSuperview];
            }
            if ([_coverView.subviews containsObject:_table]) {
                [_coverView removeFromSuperview];
                [_table removeFromSuperview];
            }
        }else
        {
            for (FloorModel *model in _areaArray) {
                
                if ([model.FloorInfo hasPrefix:textfield.text]) {
                    [array addObject:model];
                }
            }
            if (array.count==0)
            {
                if ([_coverView.subviews containsObject:_table]) {
                    [_coverView removeFromSuperview];
                    [_table removeFromSuperview];
                }
                [self NoneViewWithText:textfield];
            }else
            {
                if ([_coverView.subviews containsObject:_noneView]) {
                     [_coverView removeFromSuperview];
                    [_noneView removeFromSuperview];
                }
                
                [self createTableUIWithField:textfield Array:array];
            }

        }
    }else
    {
       //先获取区域下面的所有类型
        NSMutableArray *array=[NSMutableArray array];
        if (textfield.text.length==0) {
            _typeTextfield.text=nil;
            if ([_coverView.subviews containsObject:_noneView]) {
                [_noneView removeFromSuperview];
            }
            if ([_coverView.subviews containsObject:_table]) {
                [_table removeFromSuperview];
            }
        }else
        {

            for (RoomTypeModel *model in _typeInAreaArray) {
                
                if ([model.RoomName hasPrefix:textfield.text]) {
                    [array addObject:model];
                }
            }
            
            
            if (array.count==0)
            {
                if ([_coverView.subviews containsObject:_table]) {
                    [_table removeFromSuperview];
                }
                [self NoneViewWithText:textfield];
            }else
            {
                if ([_coverView.subviews containsObject:_noneView]) {
                    [_noneView removeFromSuperview];
                }
                
                [self createTableUIWithField:textfield Array:array];
            }
            
        }

            
        }

       
}

-(void)NoneViewWithText:(UITextField*)textField
{
       if (![_coverView.subviews containsObject:_noneView])
       {
           
           _coverView=[[CoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            _coverView.isClick=YES;
           _coverView.click=^{
               textField.text=nil;
               
           };
           UIWindow *window=[UIApplication sharedApplication].keyWindow;
           [window addSubview:_coverView];

           _noneView=[[NSBundle mainBundle]loadNibNamed:@"NoneView" owner:nil options:nil][0];
       
           _noneView.layer.borderColor=[UIColor lightGrayColor].CGColor;
           _noneView.layer.borderWidth=1;
           
           [_coverView addSubview:_noneView];
           [_noneView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(textField.mas_bottom);
               make.left.mas_equalTo(textField.mas_left);
               make.right.mas_equalTo(textField.mas_right).offset(50);
               make.height.mas_equalTo(3*44);
               
           }];
       }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_typeTextfield) {
        if (_areaTextfield.text.length==0) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"请先填写区域"];
            return NO;
        }
        if (self.is==YES) {
            return NO;
        }
    }
    return YES;
}

#pragma mark-getdata
-(void)getAreaArraydata
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
   
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    NSDictionary *dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        NSDictionary *dic1=[JsonTools getData:responseObject];
        self.areaArray=[FloorModel getDataWithDic:dic1];
        NSLog(@"%@",dic1);
        [self gettypeArraydata];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
}
-(void)gettypeArraydata
{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
//    NSLog(@"%@",condition);
    NSDictionary *dic=@{@"FromTableName":@"POSST",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        self.typeArray=[RoomTypeModel getDataWithDic:dic1];
//        NSLog(@"%ld",self.typeArray.count);
        [self getZWHZuoArraydata];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}


-(void)getZWHZuoArraydata{
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    //NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    //    NSLog(@"%@",condition);
    NSString *condition=@"";
    NSDictionary *dic=@{@"FromTableName":@"POSQT",@"SelectField":@"typeno,rtrim(typename)+rtrim(isnull(remark,'')) typename",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        NSLog(@"%@",dic1);
        self.zwhzuoArray=[RoomTypeModel getDataWithDic:dic1];
        //        NSLog(@"%ld",self.typeArray.count);
        [self getTypeInAreaArrayData];
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}

#pragma mark--tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
   
    
    ChooseTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    if (_is)
    {
        FloorModel *model=_dataArray[indexPath.row];
        cell.contentLable.text=model.FloorInfo;
        
    }else
    {
         RoomTypeModel *model=_dataArray[indexPath.row];
        cell.contentLable.text=model.RoomName;
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_is)
    {
        FloorModel *model=_dataArray[indexPath.row];
        _areaTextfield.text=model.FloorInfo;
         _areaNo=model.itemNo;
        [_coverView removeFromSuperview];
        [_table removeFromSuperview];
        _is=NO;
        [self.view endEditing:YES];
        [self getTypeInAreaArrayData];
        
        
    }else
    {
        RoomTypeModel *model=_dataArray[indexPath.row];
        _typeTextfield.text=model.RoomName;
        _typeNo=model.itemNo;
        [_coverView removeFromSuperview];
        [_table removeFromSuperview];
        [self.view endEditing:YES];
        
    }
    
}
-(void)getTypeInAreaArrayData
{

    [self.typeInAreaArray removeAllObjects];
    if (self.areaNo) {
        for (RoomTypeModel *model in _typeArray) {
            if ([model.roomArea isEqualToString:_areaNo]) {
                [self.typeInAreaArray addObject:model];
            }
        }
        if (_typeInAreaArray.count>0)
        {
            RoomTypeModel *model=_typeInAreaArray[0];
            _typeTextfield.text=model.RoomName;
            self.typeNo=model.itemNo;
            
        }else
        {
            if ([self.modelType isEqualToString:@"delet"]) {
                return;
            }else
            {
                _typeTextfield.text=nil;
                _typeNo=nil;
                NSString *str=[NSString stringWithFormat:@"%@暂时没有类型,是否需要创建?",_areaTextfield.text];
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SeatSetViewController *set=[[SeatSetViewController alloc]init];
                    set.title=@"类型设置";
                    set.floorName=_areaTextfield.text;
                    set.floorNo=_areaNo;
                    set.funType=@"Type";
                    [self.navigationController pushViewController:set animated:YES];
                    
                }];
                [alert addAction:action];
                [alert addAction:action1];
                
                [self presentViewController:alert animated:YES completion:nil];

            }
           
        }
   
    }else
    {
        FloorModel *model=self.areaArray[0];
        self.areaNo=model.itemNo;
        _areaTextfield.text=model.FloorInfo;
        [self getTypeInAreaArrayData];
        
        
    }
}
-(void)goToCreatArea
{
    NSString *str=[NSString stringWithFormat:@"%@还没有创建区域,去创建?",_areaTextfield.text];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SeatSetViewController *set=[[SeatSetViewController alloc]init];
        set.title=@"区域设置";
        set.goTocreatArea=YES;
        set.funType=@"Area";
        [self.navigationController pushViewController:set animated:YES];
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - 选择类型
- (IBAction)zwhzuoBtnMethod:(id)sender {
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"桌子大小";
    NSMutableArray *titleArr = [NSMutableArray array];
    for (RoomTypeModel *model in self.zwhzuoArray) {
        [titleArr addObject:model.typename];
    }
    dialogViewController.items = titleArr;
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        RoomTypeModel *model = _zwhzuoArray[itemIndex];
        _zuoNo = model.typeno;
        _zwhzuoTextfield.text = model.typename;
        [aDialogViewController hide];
    };
    [dialogViewController show];
}
- (IBAction)areaButton:(UIButton *)sender
{

     if ([self.view.subviews containsObject:_noneView])
     {
         [_noneView removeFromSuperview];
     }
//    if ([self.view.subviews containsObject:_table])
//    {
//        if (_is) {
//            [_table removeFromSuperview];
//        }
//       
//    }else
//    {
        [self createTableUIWithField:_areaTextfield Array:_areaArray];
//    }
    

    
 
    
}
- (IBAction)typeButton:(UIButton *)sender
{
    if (_areaTextfield.text.length)
    {

        if ([self.view.subviews containsObject:_table]) {
            return;
        }else
        {
            if (_typeInAreaArray.count)
            {
                        if ([self.view.subviews containsObject:_noneView])
                        {
                            [_noneView removeFromSuperview];
                        }
//                  if ([self.view.subviews containsObject:_table])
//                  {
//                      if (!_is) {
//                          [_table removeFromSuperview];
//                      }
//                    
//                  }else
//                  {
                        [self createTableUIWithField:_typeTextfield Array:_typeInAreaArray];
//                  }
          
            
            }else
            {
                return;
            }
            

        }

//         [self createTableUIWithField:_typeTextfield Array:_typeInAreaArray];
    }else
    {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请先填写区域"];
        return;
    }
}
- (IBAction)addSeatInfo:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self juge];
}

//上传房台信息
-(void)editSeatInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];

    NSDictionary *jsonDic;
         jsonDic=@{ @"Command":@"Edit",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"SI002":_seatTextfield.text,@"SI003":_typeNo,@"SI004":_areaNo,@"SI015":_see,@"SI018":_reserver,@"SI001":self.seatModel.itemNo,@"SI007":_personCountTextFiied.text,@"SI017":_zuoNo,@"UDF06":_zwhzuoTextfield.text}]};
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
 
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD dismiss];
            NSString *masage=[NSString stringWithFormat:@"%@已经修改成功!",_seatTextfield.text];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:masage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.backBlock();
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            [alert addAction:action];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"编辑失败稍后再试"];
        }

    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
//编辑房台信息
-(void)upSeatInfo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *jsonDic;
    jsonDic=@{ @"Command":@"Add",@"TableName":@"POSSI",@"Data":@[@{@"COMPANY":self.model.COMPANY,@"SHOPID":self.model.SHOPID,@"CREATOR":@"admin",@"SI002":_seatTextfield.text,@"SI003":self.typeNo,@"SI004":self.areaNo,@"SI015":self.see,@"SI018":self.reserver,@"SI007":_personCountTextFiied.text,@"SI017":_zuoNo,@"UDF06":_zwhzuoTextfield.text}]};
    NSLog(@"%@",jsonDic);
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    NSDictionary *dic=@{@"strJson":jsonStr,@"bPhoto":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/DataProcess_New" With:dic and:^(id responseObject) {
        
        
        
        NSString *str=[JsonTools getNSString:responseObject];
        if ([str isEqualToString:@"OK"])
        {
            [SVProgressHUD dismiss];
            //NSString *masage=[NSString stringWithFormat:@"%@已经创建成功!",_seatTextfield.text];
//            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:masage preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *action=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                self.areaNo=nil;
//                self.typeNo=nil;
//                self.seatTextfield.text=nil;
//                self.typeTextfield.text=nil;
//                self.areaTextfield.text=nil;
//                self.personCountTextFiied.text=nil;
//                
//            }];
//            
//            [alert addAction:action];
//            
//            
//            [self presentViewController:alert animated:YES completion:nil];
            self.backBlock();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"上传失败稍后再试"];
        }
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}


#pragma mark--判断
-(void)juge
{
//    NSLog(@"%@",_seatTextfield.text);
    if (self.areaNo.length>0&&self.typeNo.length>0&&_seatTextfield.text.length>0&&_personCountTextFiied.text.length>0&&self.zuoNo.length>0)
    {
        //上传房台信息
        if (_seatModel)
        {
             [self editSeatInfo];
          
        }else
        {
             [self upSeatInfo];
        }
     
        
    }else
    {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整房台资料" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:nil];
              [alert addAction:action];
     
        
        [self presentViewController:alert animated:YES completion:nil];
      
    }

    
}




-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:nil];
     UIAlertAction *action1=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         self.areaTextfield.text=nil;
         self.typeTextfield.text=nil;
         self.seatTextfield.text=nil;
     }];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)isReserver:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected)
    {
       
        self.reserver=@"True";
     
    }else
    {
        
       
        self.reserver=@"False";
    }
}


- (IBAction)isSee:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected)
    {
       
        self.see=@"True";
   
    }else
    {
      
         self.see=@"False";
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)areaSet:(UIButton *)sender
{
    SeatSetViewController *set=[[SeatSetViewController alloc]init];
    set.title=@"区域设置";
    set.funType=@"Area";
    [self.navigationController pushViewController:set animated:YES];
    
}
- (IBAction)typeSet:(UIButton *)sender
{
    SeatSetViewController *set=[[SeatSetViewController alloc]init];
    set.title=@"类型设置";
    set.funType=@"Type";
    [self.navigationController pushViewController:set animated:YES];
    
}


@end
