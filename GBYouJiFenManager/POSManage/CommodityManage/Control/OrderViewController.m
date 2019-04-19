//
//  OrderViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/26.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "OrderViewController.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "FloorModel.h"
#import "RoomTypeModel.h"
#import "SeatSatueModel.h"
#import "ChooseTableViewCell.h"
#import "SeatCollectionViewCell.h"
#import "StateCollectionViewCell.h"
#import "FMDBMember.h"
#import "MemberModel.h"
#import "SeatModel.h"
#import "PersonCountViewController.h"
#import "BillDetailViewController.h"
#import "ReserveTimeViewController.h"
@interface OrderViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITextField *searchField;
    UILabel *_bottomLablel1;
    UILabel *_bottomLablel2;
    UIButton *_bottomButton;
    BOOL  isFloor;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stateTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stateHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectBottom;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview1;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,strong)NSMutableArray *seatAreaArray;
@property(nonatomic,strong)NSMutableArray *seatTypeArray;
@property(nonatomic,strong)NSMutableArray *seatArray;
@property(nonatomic,strong)NSMutableArray *stateArray;

//房台类型
@property(nonatomic,copy)NSString *reginStr;
//区域楼层编号
@property(nonatomic,copy)NSString *formStr;
//房台状态
@property(nonatomic,copy)NSString *statuStr;
//是否可以预定
@property(nonatomic,copy)NSString *SI018;

@property(nonatomic,copy)NSString *companyID;
@property(nonatomic,copy)NSString *shopID;
@property(nonatomic,strong)SeatModel *sModel;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (screen_width<=325) {
        self.tableHeight.constant=80;
    }
    if (_chooseType)
    {
        _SI018=@"true";
        self.statuStr=nil;
        self.tableBottom.constant=50;
        self.collectBottom.constant=50;
        self.stateTop.constant=70;
        self.stateHeight.constant=0;
        [self creatBottom];
    }else
    {
        self.statuStr=nil;
         [self ctreatUI];
    }
    _seatAreaArray=[NSMutableArray array];
    _seatTypeArray=[NSMutableArray array];
    _stateArray=[NSMutableArray array];
    _seatArray=[NSMutableArray array];
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    _companyID=model.COMPANY;
    _shopID=model.SHOPID;
    isFloor=YES;
    //注册
    [self.collectionview registerNib:[UINib nibWithNibName:@"SeatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SeatCollectionViewCell"];
    [self.collectionview1 registerNib:[UINib nibWithNibName:@"StateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StateCollectionViewCell"];
    self.model=[[FMDBMember shareInstance]getMemberData][0];
    [self getSeatAreaData];
   //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendBillSuccess) name:@"sendBillSuccess" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CodepaySuccess:) name:@"CodepaySuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)creatBottom
{
    UIView *linview=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-55,screen_width, 1)];
    linview.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:linview];
    //
    UIView *groudView=[[UIView alloc]initWithFrame:CGRectMake(0, screen_height-54, screen_width*2/3, 54)];
    groudView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:groudView];
    //
    _bottomLablel1=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, groudView.width*2/3-8, groudView.height)];
    _bottomLablel1.text=@"-请选择房台-";
    _bottomLablel1.textColor=[UIColor lightGrayColor];
    _bottomLablel1.font=[UIFont boldSystemFontOfSize:20];
    _bottomLablel1.textAlignment=NSTextAlignmentCenter;
    [groudView addSubview:_bottomLablel1];
    //
    _bottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame=CGRectMake(screen_width*2/3, screen_height-54,screen_width/3, 54);
    [_bottomButton setTitle:@"选择时间" forState:UIControlStateNormal];
    _bottomButton.backgroundColor=navigationBarColor;
    [self.view addSubview:_bottomButton];
    [_bottomButton addTarget:self action:@selector(buttClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomButton.enabled=NO;
    _bottomButton.backgroundColor=[UIColor lightGrayColor];
    
}
-(void)buttClick
{
    ReserveTimeViewController *time=[[ReserveTimeViewController alloc]init];
    time.model=_sModel;
    [self.navigationController pushViewController:time animated:YES];
}
-(void)sendBillSuccess
{
    [self getFangtaiInforMation];
}
-(void)paySuccess
{
    NSLog(@"付款成功");
    [self getFangtaiInforMation];
}
-(void)CodepaySuccess:(NSNotification*)notice
{
    NSDictionary *dic=notice.userInfo;
//    NSLog(@"%@",dic[@"SI001"]);
      NSLog(@"扫码付款成功");
     [self changeState:@"0":dic[@"SI001"]];
//    [self getFangtaiInforMation];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//判断
-(void)getFangtaiInforMation
{
//    NSLog(@"--%@",_statuStr);
    //判断
    if (_reginStr.length>0)
    {
        if (_formStr.length>0)
        {
            if (_statuStr.length>0)
            {
                //三个字符串长度都大于0
                if (_SI018.length)
                {
                     NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI003$=$%@$AND$SI005$=$%@$AND$SI018$=$%@",_companyID,_shopID,_reginStr,_formStr,_statuStr,_SI018];
                     [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI003$=$%@$AND$SI005$=$%@",_companyID,_shopID,_reginStr,_formStr,_statuStr];
                     [self getSeatDataWithStr:conditionStr];
                }
               
               
                
                
                
            }else
            {

                if (_SI018.length)
                {
                       NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI003$=$%@$AND$SI018$=$%@",_companyID,_shopID,_reginStr,_formStr,_SI018];
                     [self getSeatDataWithStr:conditionStr];
                }else
                {
                       NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI003$=$%@",_companyID,_shopID,_reginStr,_formStr];
                     [self getSeatDataWithStr:conditionStr];
                }
             
             
                
                
            }
            
            
        }
        else
        {
//             $AND$SI018$=$%@
            if (_statuStr.length>0)
            {
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI005$=$%@$AND$SI018$=$%@",_companyID,_shopID,_reginStr,_statuStr,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI005$=$%@",_companyID,_shopID,_reginStr,_statuStr];
                    [self getSeatDataWithStr:conditionStr];
                }
               
                
                
            }else
            {
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@$AND$SI018$=$%@",_companyID,_shopID,_reginStr,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI004$=$%@",_companyID,_shopID,_reginStr];
                    [self getSeatDataWithStr:conditionStr];
                }
              
            }
            
        }
        
    }else
    {
        if (_formStr.length>0)
        {
            if (_statuStr.length>0)
            {
                
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI003$=$%@$AND$SI005$=$%@$AND$SI018$=$%@",_companyID,_shopID,_formStr,_statuStr,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI003$=$%@$AND$SI005$=$%@",_companyID,_shopID,_formStr,_statuStr];
                    [self getSeatDataWithStr:conditionStr];
                }
              
            }else
            {
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI003$=$%@$AND$SI018$=$%@",_companyID,_shopID,_formStr,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI003$=$%@",_companyID,_shopID,_formStr];
                    [self getSeatDataWithStr:conditionStr];
                }
               
            }
            
        }else
        {
            if (_statuStr.length>0)
            {
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI005$=$%@$AND$SI018$=$%@",_companyID,_shopID,_statuStr,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI005$=$%@",_companyID,_shopID,_statuStr];
                    [self getSeatDataWithStr:conditionStr];
                }
             
            }else
            {
                
                if (_SI018.length)
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@$AND$SI018$=$%@",_companyID,_shopID,_SI018];
                    [self getSeatDataWithStr:conditionStr];
                }else
                {
                    NSString *conditionStr=[NSString stringWithFormat:@"A.COMPANY$=$%@$AND$A.SHOPID$=$%@",_companyID,_shopID];
                    [self getSeatDataWithStr:conditionStr];
                }
              
            }
        }
        
        
    }
    
}
-(void)getSeatDataWithStr:(NSString*)str
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    

    NSDictionary *dic=@{@"FromTableName":@"POSSI[A]||POSSS[B]{left (rtrim(si005)=rtrim(SS001))}",@"SelectField":@"A.*,B.SS007",@"Condition":str,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"%@",dic1);
        _seatArray=[SeatModel getDataWithDic:dic1];
        [self.collectionview reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)ctreatUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableview.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.tableview.layer.borderWidth=1;
    //创建搜索栏
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(20,13, screen_width-40, 40)];
    searchField.placeholder = @"搜索";
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.borderWidth = 1.0f;
    searchField.layer.cornerRadius = 8;
    searchField.layer.masksToBounds = YES;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.delegate=self;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchField.frame.size.width-45,5, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //searchBtn.backgroundColor = [UIColor redColor];
    [searchBtn addTarget:self action:@selector(SearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchField addSubview:searchBtn];
    [self.view addSubview:searchField];
}
-(void)SearchBtnClick
{
    
    
}
-(void)getSeatAreaData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
  
    
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@",self.model.SHOPID,self.model.COMPANY];
    
    NSDictionary *dic=@{@"FromTableName":@"POSAF",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        [_seatAreaArray removeAllObjects];
        [_seatAreaArray addObject:[self addAllWithStr:nil]];
        [_seatAreaArray addObjectsFromArray:[FloorModel getDataWithDic:dic1]];
       


        [self.tableview reloadData];
         [self selectSecondIndexWitnIndex:0];
        [self getStateData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}
-(void)getSeatTypeDataWithStr:(NSString*)str
{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
   
//  $AND$ST005$=$%@
    NSString *condition=[NSString stringWithFormat:@"SHOPID$=$%@$AND$COMPANY$=$%@$AND$ST005$=$%@",self.model.SHOPID,self.model.COMPANY,str];
    
    NSDictionary *dic=@{@"FromTableName":@"POSST",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        if ([RoomTypeModel getDataWithDic:dic1].count>0) {
            [_seatTypeArray removeAllObjects];
            [_seatTypeArray addObject:[self addBack]];
            [_seatTypeArray addObjectsFromArray:[RoomTypeModel getDataWithDic:dic1]];
            [self.tableview reloadData];
             [self selectSecondIndexWitnIndex:1];
        }else
        {
            isFloor=YES;
            [self getFangtaiInforMation];
        }
           
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

    
}
-(RoomTypeModel*)addBack
{
    RoomTypeModel *model=[[RoomTypeModel alloc]init];
    model.RoomName=@"^返回^";
    return model;
    
}
-(FloorModel*)addAllWithStr:(NSString*)str
{
    
    FloorModel *model=[[FloorModel alloc]init];
    model.FloorInfo=@"全部";
    model.itemNo=nil;
//    model.classifyNo=@"all";
    
    return model;
    
}
-(void)getStateData
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dic=@{@"FromTableName":@"POSSS",@"SelectField":@"*",@"Condition":@"SS017$=$1",@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};

    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        _stateArray=[SeatSatueModel getDataWithDic:dic1];
  
        [self.collectionview1 reloadData];
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
    
 
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFloor) {
        return _seatAreaArray.count;
    }else
    {
        return _seatTypeArray.count;
        
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"ChooseTableViewCell";
   
    ChooseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
    }
    if (isFloor) {
         FloorModel *model=_seatAreaArray[indexPath.row];
         cell.contentLable.text=model.FloorInfo;
    }else
    {
        RoomTypeModel *model=_seatTypeArray[indexPath.row];
        if (model.itemNo.length==0) {
            cell.contentLable.textColor=MainColor;
        }
        cell.contentLable.text=model.RoomName;
        
    }

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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


    if (isFloor)
    {
       // 区域
        FloorModel *model=_seatAreaArray[indexPath.row];
        self.reginStr=model.itemNo;
        if (!model.itemNo.length)
        {
            //全部
            
            _reginStr=nil;
            _formStr=nil;

            [self getFangtaiInforMation];
            
        }else
        {
            
            isFloor=NO;
            
             self.reginStr=model.itemNo;
             [self getSeatTypeDataWithStr:model.itemNo];
        }
       
        
      
        
    }else
    {
        //类型
        RoomTypeModel *model=_seatTypeArray[indexPath.row];
        
        if (!model.itemNo)
        {
            //返回
            isFloor=YES;
            [self getSeatAreaData];
        }else
        {

          
            self.formStr=model.itemNo;
//              NSLog(@"%@%@%@",self.reginStr,self.formStr,self.statuStr);
            [self getFangtaiInforMation];
            
        }

        
        
    }
   
}
-(void)selectSecondIndexWitnIndex:(NSInteger)index
{
                //分类
    
            NSIndexPath * selIndex = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableview selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
              NSIndexPath * path = [NSIndexPath indexPathForItem:index inSection:0];
               [self tableView:self.tableview didSelectRowAtIndexPath:path];
    
 
    
}

#pragma mark--collect
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.collectionview)
    {
         return _seatArray.count;
        
    }else
    {
        return _stateArray.count;
    }
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionview)
    {
        SeatModel *model=_seatArray[indexPath.row];
        SeatCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SeatCollectionViewCell" forIndexPath:indexPath];
       
        [cell setDataWithModel:model];
        return cell;
        
    }else
    {
    
        SeatSatueModel *model=_stateArray[indexPath.row];
        StateCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"StateCollectionViewCell" forIndexPath:indexPath];
        [cell setDataWithModel:model];
        return cell;
    }
    
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionview)
    {
        if (_chooseType)
        {
             SeatModel *model=_seatArray[indexPath.row];
            for (SeatModel *model1 in _seatArray)
            {
                if ([model1.SI001 isEqualToString:model.SI001])
                {
                     model1.isSelet=YES;
                    _bottomLablel1.attributedText=[self stringWithSeatNum:model.SI002];
                    _sModel=model1;
                    _bottomButton.enabled=YES;
                     _bottomButton.backgroundColor=navigationBarColor;
                }else
                {
                     model1.isSelet=NO;
                }
            }
            [self.collectionview reloadData];
            
        }else
        {
            SeatModel *model=_seatArray[indexPath.row];
            //根据房台状态判定
            if ([model.SI005 isEqualToString:@"2 "])
            {
                //开台状态
                //判断如果存在订单则进入账单，没有则改为空台的状态
                [self getDataWithCondition:model];
                
                
            }
            else if([model.SI005 isEqualToString:@"0 "])
            {
                //判断可不可用
                
                [self lockSeatWithFangTaiModel:model];
            }
 
        }
        
     
        
    }else
    {
        SeatSatueModel *smodel=_stateArray[indexPath.row];
        for (SeatSatueModel *model in _stateArray)
        {
            if ([model.SS001 isEqualToString:smodel.SS001])
            {
                
                model.isSlected=!model.isSlected;
                if (model.isSlected)
                {
                     self.statuStr=model.SS001;
                }else
                {
                    self.statuStr=nil; 
                }
               
                [self getFangtaiInforMation];
            }else
            {
                model.isSlected=NO;
            }
                
            
        }
        [self.collectionview1 reloadData];
        
    }

    
}
#pragma mark---锁台
-(void)lockSeatWithFangTaiModel:(SeatModel*)model
{
    
    
    NSString *DeviceNo=[[NSUserDefaults standardUserDefaults]objectForKey:@"DN001"];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"Company":_companyID,@"ShopID":_shopID,@"UserNo":_model.Mobile,@"DeviceNo":DeviceNo,@"SeatNo":model.SI001,@"IsLock":@"Y",@"LockInfo":@""};
    NSLog(@"------%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/GetLockSeatInfo" With:dic and:^(id responseObject)
     {
         NSString *str=[JsonTools getNSString:responseObject];
         NSArray *stateStrArray=[str componentsSeparatedByString:@","];
         if ([stateStrArray[0] containsString:@"1"]||[stateStrArray[1] isEqualToString:DeviceNo])
         {
             [SVProgressHUD showSuccessWithStatus:@"锁台成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 //空台状态
                 PersonCountViewController *person=[[PersonCountViewController alloc]init];
                 person.title=@"输入人数";
                 person.model=model;
                 [self.navigationController pushViewController:person animated:YES];
                 
             });
             
         }
         else
         {
           
             [SVProgressHUD showErrorWithStatus:str];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
             });
         }
     } Faile:^(NSError *error)
     {
        
     }];
    
    
}

-(NSMutableAttributedString *)stringWithSeatNum:(NSString *)string
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前房台为:%@",string]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,string.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10,5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ArialMT" size:15.0] range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20.0] range:NSMakeRange(6,string.length)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0] range:NSMakeRange(10, 5)];
    return str;
}
#pragma mark--(获取订单号)
-(void)getDataWithCondition:(SeatModel*)model
{
    NSDictionary *dic=@{@"FromTableName":@"POSSB",@"SelectField":@"SB002,SB001",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$SB005$=$%@$AND$SB003$=$%@$AND$SB004$<>$4$AND$SB004$<>$5",_companyID,_shopID,model.SI001 ,[self getTime]],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    NSLog(@"%@",[self getTime]);
    
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject)
     {
         NSDictionary *dic1=[JsonTools getData:responseObject];
         NSString *dingDanNo;
          dingDanNo=[dic1[@"DataSet"][@"Table"] lastObject][@"SB002"];
         
     
         
         if (dingDanNo.length>0)
         {
           //
             BillDetailViewController *person=[[BillDetailViewController alloc]init];
             person.title=model.SI002;
             person.model=model;
             person.dingDanNo=dingDanNo;
             [self.navigationController pushViewController:person animated:YES];
         }else
         {
             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"此房台不存在订单,改成空台状态" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [self changeState:@"0":model.SI001];

             }];
             [alert addAction:action];
             [self presentViewController:alert animated:YES completion:nil];
         }
         //
     } Faile:^(NSError *error) {
         
         
     }];
    
}
#pragma mark--点击房台时改变状态
-(void)changeState:(NSString *)state :(NSString*)seatNo
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":_companyID,@"shopid":_shopID,@"seatNo":seatNo,@"state":state,@"CipherText":CIPHERTEXT};
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/PosService.asmx/UpdateSeatState" With:dic and:^(id responseObject)
     {
         NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"%@",str);
         if ([str containsString:@"true"])
         {
             [SVProgressHUD showSuccessWithStatus:@"修改成功"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
                 [self getFangtaiInforMation];
             });
             
         }else
         {
              [SVProgressHUD dismiss];
             [self addAllWithStr:str];
         }
         
     } Faile:^(NSError *error)
     {
          [SVProgressHUD dismiss];
         NSLog(@"网络错误");
     }];
}

#pragma mark--获取时间
-(NSString *)getTime
{
    
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"BusinessDate"];
    NSArray *timeArray=[time componentsSeparatedByString:@","];
    return timeArray[1];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.collectionview)
    {
        return CGSizeMake((self.collectionview.width-40)/3,(self.collectionview.width-40)/3);
        
    }else
    {
         return CGSizeMake(75,50);
    }
    
   
    
}
//设置section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上  左   下  右
    if (collectionView==self.collectionview)
    {
        return
        UIEdgeInsetsMake(10, 10,10, 10);
        
    }else
    {
        return
        UIEdgeInsetsMake(1,1, 1, 30);
    }
    

    
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==self.collectionview)
    {
           return 10;
        
    }else
    {
       return 1;
    }
 
    
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10;
    
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
