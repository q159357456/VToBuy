//
//  DownOrderViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/5/27.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "DownOrderViewController.h"
#import "ChooseTableViewCell.h"
#import "DownOrderTableViewCell.h"
#import "MemberModel.h"
#import "FMDBMember.h"
#import "ClassifyModel.h"
#import "ProductModel.h"
#import "OrderViewController.h"
#import "ChooseComboViewController.h"
#import "PurchaseCarAnimationTool.h"
#import "ShopCarTableViewCell.h"
#import "INV_ProductModel.h"
#import "ChooseTastView.h"
#import "POSDIModel.h"
#import "PayDetailViewController.h"
#import "BillStateViewController.h"
#import "MyAddressViewController.h"
#define headerHeight 30
#define limitHeight   screen_height/2

@interface DownOrderViewController ()<UITableViewDataSource,UITableViewDelegate,CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview2;
@property (strong, nonatomic) IBOutlet UITableView *tableview1;
@property (strong, nonatomic) IBOutlet UITableView *tableview3;
@property(nonatomic,strong)UITableView *tableview4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Theight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Twidth;
@property(nonatomic,strong)MJRefreshAutoGifFooter *footer;
@property(nonatomic,strong)MJRefreshGifHeader *header;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;
@property (strong, nonatomic) IBOutlet UILabel *countLable;
@property (strong, nonatomic) IBOutlet UIView *backview;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property(nonatomic,strong) ChooseTastView *chooseView;
@property(nonatomic,assign)BOOL iseqal;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)MemberModel *model;
@property(nonatomic,copy)NSString *conitionStr;
@property(nonatomic,strong)NSMutableArray *classifyArray;
@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)NSMutableArray *shopCarArray;
@property(nonatomic,strong)NSMutableArray *tastArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ClassifyModel *partModel;
@property(nonatomic,copy)NSString* adeessID;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *productPatno;
@end

@implementation DownOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //订单号
    if (_adModel) {
        self.dingDanNo=[self getQuciklyOrderNo];
    }
}
-(NSString *)productPatno
{
    if (!_productPatno) {
        _productPatno=@"";
    }
    return _productPatno;
}
-(NSInteger)index
{
    if (!_index) {
        _index=1;
    }
    return _index;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArray];
    if (_adModel)
    {
        self.Theight.constant=40;
        
        self.model=[[FMDBMember shareInstance]getMemberData][0];
        _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.adModel.company,self.adModel.shopid];
        //获取默认送货地址
        [self getDefautAdress];
  
        
    }else
    {
          _Theight.constant=80;
        self.model=[[FMDBMember shareInstance]getMemberData][0];
        _conitionStr=[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@",self.model.COMPANY,self.model.SHOPID];
        if (!_isAdd) {
            if (!self.dingDanNo.length) {
                self.dingDanNo=[self getQuciklyOrderNo];
            }
        }
        
    }

    [self creatUI];
    self.partModel=[[ClassifyModel alloc]init];
    _partModel.classifyNo=@"";
    [self getClassifyDataWithModel:_partModel];
    //
    [self fresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(giveup) name:@"giveup" object:nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)setTwidth:(NSLayoutConstraint *)Twidth
{
    _Twidth=Twidth;
    if (screen_width==320) {
        _Twidth.constant=80;
    }
}
-(void)getDefautAdress
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic;
    dic = @{@"FromTableName":@"CMS_MyAddress",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"COMPANY$=$%@$AND$SHOPID$=$%@$AND$DefaultAddr$=$True",self.model.COMPANY,self.model.SHOPID],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance] getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1 = [JsonTools getData:responseObject];
        NSArray *array= [addressModel getDataWithDic:dic1];
        addressModel *model=array[0];
        ChooseTableViewCell *Cell=(ChooseTableViewCell*)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        Cell.contentLable.text=[NSString stringWithFormat:@" 送货地址:     %@%@",model.area, model.address];
        self.adeessID=model.ID;
        NSLog(@"%@",dic1);
      
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error)
    }];

    
}
-(void)paySuccess
{
   
    [_shopCarArray removeAllObjects];
    [self changeUI];
    [_tableview3 reloadData];
    //刷新订单号
    self.dingDanNo=[self getQuciklyOrderNo];
    [self.tableview1 reloadData];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initArray
{
    self.classifyArray=[NSMutableArray array];
    _productArray=[NSMutableArray array];
    _shopCarArray=[NSMutableArray array];
}
-(void)alertShowWithStr:(NSString*)str
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)selecteIndex:(NSInteger)index
{
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableview2 selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
    NSIndexPath * path = [NSIndexPath indexPathForItem:index  inSection:0];
    [self tableView:self.tableview2 didSelectRowAtIndexPath:path];
}

-(void)getClassifyDataWithModel:(ClassifyModel*)model
{
//    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
        [SVProgressHUD showWithStatus:@"加载中"];
 
    NSString *condition;
  
    if ([model.classifyNo isEqualToString:@"some"])
    {
          condition=[NSString stringWithFormat:@"parentno$=$%@$AND$%@",model.parentno,_conitionStr];
        
        
    }else
    {
          condition=[NSString stringWithFormat:@"parentno$=$%@$AND$%@",model.classifyNo,_conitionStr];
    }
    
 
        NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic1=[JsonTools getData:responseObject];

      
            if ([ClassifyModel getDataWithDic:dic1].count>=1) {

                [_classifyArray removeAllObjects];
                [_classifyArray addObjectsFromArray:[ClassifyModel getDataWithDic:dic1]];
            }
            if ([ClassifyModel getDataWithDic:dic1].count>=1)
            {
                 ClassifyModel *pmodel=_classifyArray[0];
                 [_classifyArray  insertObject:[self addAllWithStr:pmodel.parentno] atIndex:0];
                
                if ([self isAdd])
                {
                [_classifyArray insertObject:[self addBackWithStr:pmodel.parentno] atIndex:0];
                    
                }
                if ([model.classifyNo isEqualToString:@"some"])
                {
                    [self tableviewAnimationWithInt:UIViewAnimationOptionTransitionFlipFromRight];
                }else
                {
                    [self tableviewAnimationWithInt:UIViewAnimationOptionTransitionFlipFromLeft];
                }
               
                    if ([model.classifyNo isEqualToString:@"some"])
                    {
                        return ;
                        
                    }else
                        
                    {
                        if ([self isAdd])
                        {
                            [self selecteIndex:1];
                        }else
                        {
                            [self selecteIndex:0];
                        }
                    }
            }else
            {
                self.index=1;
                self.productPatno=model.classifyNo;
                [self getProductDataWithStr:model.classifyNo];
            }
          
        
        } Faile:^(NSError *error) {
          
        }];

    
}
-(void)tableviewAnimationWithInt:(NSInteger)k
{

    [UIView transitionWithView:_tableview2
                      duration: 0.5f
                       options: k
                    animations: ^(void)
     {
         [_tableview2 reloadData];
     }
                    completion: ^(BOOL isFinished)
     {  
         
     }];
}

-(void)getBackDataWithModel:(ClassifyModel*)model
{

    NSString *condition=[NSString stringWithFormat:@"classifyNo$=$%@$AND$%@",model.parentno,_conitionStr];
    NSDictionary *dic=@{@"FromTableName":@"inv_classify",@"SelectField":@"*",@"Condition":condition,@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
//        [SVProgressHUD dismiss];
      NSDictionary *dic1=[JsonTools getData:responseObject];
      ClassifyModel *cmodel=[ClassifyModel getDataWithDic:dic1][0];
        cmodel.classifyNo=model.classifyNo;
      [self getClassifyDataWithModel:cmodel];
        
        
        
    } Faile:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];

}

-(BOOL)isAdd
{
    ClassifyModel *model=_classifyArray[1];
    if (!model.parentno.length)
    {
        return NO;
    }else
    {
        return YES;
    }
}

-(void)getProductDataWithStr:(NSString*)str
{

    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *company;
    NSString *shopid;
  
    if (_adModel)
    {
        company=_adModel.company;
        shopid=_adModel.shopid;
      
    }else
    {
        company=self.model.COMPANY;
        shopid=self.model.SHOPID;
    }
        NSDictionary *dic=@{@"strCompany":company,@"strShop":shopid,@"strClassify":str,@"pageindex":[NSString stringWithFormat:@"%ld",self.index],@"pagesize":requsetSize,@"CipherText":CIPHERTEXT};
       NSLog(@"%@",dic);
        [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"/GoodsService.asmx/GetPOSGoodsInfo_Page" With:dic and:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic1=[JsonTools getData:responseObject];
          
            if (self.index==1)
            {
                //不是加载的情况
                [_productArray removeAllObjects];
                
            }
            
            [_productArray addObjectsFromArray:[INV_ProductModel getDataWithDic:dic1]];
            [self chanFootWithArray:[INV_ProductModel getDataWithDic:dic1]];
            
            [self.tableview3 reloadData];
             [self endFresh];
        } Faile:^(NSError *error) {
        
        }];
}


-(ClassifyModel*)addBackWithStr:(NSString*)str
{
    
    ClassifyModel *model=[[ClassifyModel alloc]init];
    model.classifyName=@"^返回^";
    model.parentno=str;
    model.classifyNo=@"some";
    return model;
    
}
-(ClassifyModel*)addAllWithStr:(NSString*)str
{
    
    ClassifyModel *model=[[ClassifyModel alloc]init];
    model.classifyName=@"全部";
    model.parentno=str;
    model.classifyNo=@"all";
    return model;
    
}

//点击购物车
- (IBAction)shopCarClick:(UIButton *)sender
{
    if (![self.view.subviews containsObject:_coverView])
    {
        [self creatTable];
    }else
    {
        [self.coverView removeFromSuperview];
    }
}
-(void)creatTable
{

    self.coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screen_width, screen_height)];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    _coverView.userInteractionEnabled=YES;
    [_coverView addGestureRecognizer:tap];
        [self.view addSubview:_coverView];
        //     [[[UIApplication sharedApplication] keyWindow] addSubview:_coverView];
        //动画测试
    if ([self retrunTableRowHeight]+headerHeight>limitHeight)
    {
        _tableview4=[[UITableView alloc]initWithFrame:CGRectMake(0, _coverView.height-limitHeight-59, _coverView.width,limitHeight) style:UITableViewStylePlain];
        
    }else
    {
        _tableview4=[[UITableView alloc]initWithFrame:CGRectMake(0, _coverView.height-[self retrunTableRowHeight]-headerHeight-59, _coverView.width, [self retrunTableRowHeight]+headerHeight) style:UITableViewStylePlain];
    }
    
        _tableview4.delegate=self;
        _tableview4.dataSource=self;
        _tableview4.scrollsToTop=NO;
        _tableview4.pagingEnabled=NO;
        _tableview4.transform=CGAffineTransformMakeTranslation(0,[self retrunTableRowHeight]+headerHeight);
        [UIView animateWithDuration:0.3 animations:^{
            
            _tableview4.transform=CGAffineTransformIdentity;
            
        }];
        
        [self.coverView addSubview:_tableview4];
        
    
 
}
-(CGFloat)retrunTableRowHeight
{
    float s=0  ;
    for (INV_ProductModel *model in _shopCarArray) {
        if (!model.height) {
            model.height=8;
        }
        s=s+model.height+38;
    }
    return s;
    
}
-(void)dismiss
{
    [_coverView removeFromSuperview];
}
//送单
- (IBAction)sendBill:(UIButton *)sender
{
    if (_shopCarArray.count>0)
    {
        //判断
        if (_adModel)
        {
            //供货商
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认送单？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self sendStockBill];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];

            
        }else
        {
            //餐厅
            if ([self.runModel isEqualToString:@"01"])
                
            {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认送单？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self seatSendBill];
                }];
                [alert addAction:action];
                [alert addAction:action1];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else
            {
                //快餐
                [self getBillNeedArray];
                PayDetailViewController *pay=[[PayDetailViewController alloc]init];
                pay.billNo=self.dingDanNo;
                pay.seatNo=self.seatModel.SI002;
                pay.totalPrice=self.priceLable.text;
                pay.tastArray=_tastArray;
                pay.dataArray=_dataArray;
                pay.title=@"支付";
                [self.navigationController pushViewController:pay animated:YES];
                
            }

            
        }
        
    }else
    {
        [self alertShowWithStr:@"购物车是空的请选择商品"];
    }
    

}
-(NSString *)adeessID
{
    if (!_adeessID) {
        _adeessID=@"";
    }
    return _adeessID;
}
-(void)sendStockBill
{
    //房台
    MemberModel *model=[[FMDBMember shareInstance]getMemberData][0];
    NSArray *bjsonArray=[NSArray array];
 bjsonArray=@[@{@"COMPANY":_adModel.company,@"SHOPID":_adModel.shopid,@"SB004":@"1",@"SB002":self.dingDanNo,@"SB001":PC01,@"OnLineAddressID":self.adeessID,@"SB016":model.SHOPID}];
    [self getBillNeedArray];
    NSMutableArray *pjsonArray=[NSMutableArray array];
    for (INV_ProductModel *model in _dataArray)
    {
        NSDictionary *dic;
        if ([model isKindOfClass:[INV_ProductModel class]])
        {
            dic=@{@"SBP004":model.ProductNo,@"SBP009":[NSString stringWithFormat:@"%ld",model.count],@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP015":model.RetailPrice};
        }else
        {
            dic=@{@"SBP004":model.ProductNo,@"SBP009":model.Dosage,@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP027":model.SBP027,@"SBP015":model.RetailPrice};
            
        }
        
        [pjsonArray addObject:dic];
    }

    NSData *data1=[NSJSONSerialization dataWithJSONObject:bjsonArray options:kNilOptions error:nil];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:pjsonArray options:kNilOptions error:nil];
    NSString *bjsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSString *pjsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",bjsonStr);
    NSLog(@"%@",pjsonStr);

    NSDictionary *jsonDic;

        jsonDic=@{@"possbJson":bjsonStr,@"possbpJson":pjsonStr,@"CipherText":CIPHERTEXT};
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url=@"B2BService.asmx/B2BCreateBill";
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:url With:jsonDic and:^(id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str containsString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"送单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BillStateViewController *bill=[[BillStateViewController alloc]init];
                bill.title=@"我的";
                [self.navigationController pushViewController:bill animated:YES];
            });
            
        }else
        {
            [self alertShowWithStr:str];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        
        
    } Faile:^(NSError *error)
     {
         NSLog(@"错误%@",error);
     }];

    
}
-(void)seatSendBill
{
    //房台
    [self getBillNeedArray];

    //公共参数获取
    NSString *DeviceNo =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN001"];
    NSString *Area =[[NSUserDefaults standardUserDefaults]valueForKey:@"DN006"];
    NSString *ClassesInfo =[[NSUserDefaults standardUserDefaults]valueForKey:@"ClassesInfo"];
    NSArray *classArray=[ClassesInfo componentsSeparatedByString:@","];
    NSString *ClassesNo=classArray[0];
    NSString *ClassesIndex=classArray[2];
    

    NSArray *bjsonArray=[NSArray array];

    if (!_isAdd) {
      
        bjsonArray=@[@{@"COMPANY":_model.COMPANY,@"SHOPID":_model.SHOPID,@"SB005":self.seatModel.SI001,@"SB009":self.count,@"SB004":@"1",@"SB002":self.dingDanNo,@"DeviceNo":DeviceNo,@"Area":Area,@"ClassesNo":ClassesNo,@"ClassesIndex":ClassesIndex,@"SB001":PC01}];
    }

    NSMutableArray *pjsonArray=[NSMutableArray array];
    for (INV_ProductModel *model in _dataArray)
    {
        NSDictionary *dic;
        if ([model isKindOfClass:[INV_ProductModel class]])
        {
            dic=@{@"SBP004":model.ProductNo,@"SBP009":[NSString stringWithFormat:@"%ld",model.count],@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP015":model.RetailPrice};
        }else
        {
            
            dic=@{@"SBP004":model.ProductNo,@"SBP009":model.Dosage,@"SBP010":model.RetailPrice,@"SBP021":@"I",@"SBP026":@"",@"SBP003":model.SBP003,@"SBP027":model.SBP027,@"SBP015":model.RetailPrice};
            
        }
        
        [pjsonArray addObject:dic];
    }
    //得到possbptJson
    NSMutableArray *possbptJsonArray=[NSMutableArray array];
    
    for (POSDIModel *model in self.tastArray) {
        NSDictionary *dic=@{@"SPT003":model.SPT003,@"SPT005":model.DI001,@"SPT006":model.DI006,@"SPT007":model.DI007};
        [possbptJsonArray addObject:dic];
    }
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:bjsonArray options:kNilOptions error:nil];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:pjsonArray options:kNilOptions error:nil];
    NSData *data3=[NSJSONSerialization dataWithJSONObject:possbptJsonArray options:kNilOptions error:nil];
    NSString *possjsonSyr=[[NSString alloc]initWithData:data3 encoding:NSUTF8StringEncoding];
    NSString *bjsonStr=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSString *pjsonStr=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",possjsonSyr);
    NSLog(@"%@",bjsonStr);
    NSLog(@"%@",pjsonStr);
    //
    
    NSDictionary *jsonDic;
    //区分加菜和送单
    if (_isAdd)
    {
    
        jsonDic=@{@"billno":self.dingDanNo,@"possbpJson":pjsonStr,@"possbptJson":possjsonSyr,@"CipherText":CIPHERTEXT,@"posstsJson":@""};
        
    }else
    {
        jsonDic=@{@"possbJson":bjsonStr,@"possbpJson":pjsonStr,@"possbptJson":possjsonSyr,@"posstsJson":@"",@"CipherText":CIPHERTEXT};

        //
        
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url;
    if (_isAdd) {
       url=@"/posservice.asmx/MerchantAddBill";
    }else
    {
         url=@"/posservice.asmx/MerchantCreateBill";
    }
    
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:url With:jsonDic and:^(id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str containsString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //通知中心
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendBillSuccess" object:nil userInfo:nil];
                [SVProgressHUD dismiss];
                if (_isAdd) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    NSArray *controArray=self.navigationController.viewControllers;
                    [self.navigationController popToViewController:controArray[1] animated:YES];
                    
                }
               
            });
            
        }else
        {
            NSLog(@"-------%@",str);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        
        
    } Faile:^(NSError *error)
     {
         NSLog(@"错误%@",error);
     }];

    
}
-(void)getBillNeedArray
{
    _dataArray=[NSMutableArray array];
     _tastArray=[NSMutableArray array];
    NSInteger P=1;
    for (INV_ProductModel *inModel in _shopCarArray)
    {
        inModel.SBP003=[NSString stringWithFormat:@"%ld",P];
        inModel.SBP027=@"0";
        [_dataArray addObject:inModel];
        //套餐
        if (inModel.DetailProductArray)
        {
            
            for (ProductModel *pModel in inModel.DetailProductArray)
            {
            
                P++;
                
                pModel.SBP003=[NSString stringWithFormat:@"%ld",P];
                pModel.SBP027=inModel.SBP003;
                pModel.RetailPrice=@"0";
                pModel.Dosage=[NSString stringWithFormat:@"%ld",pModel.Dosage.intValue*inModel.count];
                [_dataArray addObject:pModel];
              
            }
        }
     
        
     
        //口味
       
        if (inModel.POSDIArray)
        {
            
            for (POSDIModel *posModel in inModel.POSDIArray)
            {
                posModel.SPT003=inModel.SBP003;
                [_tastArray addObject:posModel];
                
            }
        }else
        {
            continue;
            
        }
        P++;
      
        
    }


}
-(void)creatUI
{self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableview2.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.tableview2.layer.borderWidth=1;
    self.countLable.layer.cornerRadius=10;
    self.countLable.layer.masksToBounds=YES;
    self.countLable.backgroundColor=[ColorTool colorWithHexString:@"#f09a32"];
    self.backview.backgroundColor=[ColorTool colorWithHexString:@"#494949"];
      if ([self.runModel isEqualToString:@"02"])
      {
          [self.doneButton setTitle:@"去付款" forState:UIControlStateNormal];
      }
    self.doneButton.backgroundColor=[ColorTool colorWithHexString:@"#f09a32"];
    _countLable.hidden=YES;
    _priceLable.hidden=YES;
    _shopButton.enabled=NO;
  
    
}
#pragma mark--前端产生订单号
-(NSString *)getQuciklyOrderNo
{
    //DateTime.Now.ToString("yyMMddHHmmssfff") + (new Random()).Next(10000, 99999).ToString();
    //日期
    NSString *dateString;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    dateString = [dateFormatter stringFromDate:currentDate];
    //随机数
    int k=[self getRandomNumber:10000 to:99999];
    NSString *kStr=[NSString stringWithFormat:@"%d",k];
    NSString *arcStr=[NSString stringWithFormat:@"%@%@",dateString,kStr];
    NSMutableString  *str=[NSMutableString stringWithString:arcStr];
    [str deleteCharactersInRange:NSMakeRange(0, 2)];
    return str;
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
#pragma mark--table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_tableview1)
    {
         if (_adModel)
         {
               return 1;
         }else
         {
              return 2;
         }
      
    }else if (tableView==_tableview2)
    {
         return _classifyArray.count;
        
    }else if(tableView==_tableview3)
    {
         return _productArray.count;
    }else
    {
        
         return _shopCarArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"AddDetailTableViewCell";
    
    
    if (tableView==_tableview1)
    {
       
        ChooseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        }
        cell.contentLable.textAlignment=NSTextAlignmentLeft;
        if (indexPath.row==0)
        {
            
            if (_adModel)
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.contentLable.text=[NSString stringWithFormat:@"  送货地址:  %@",@"广东省东莞市莞城区"];
            }else
            {
               cell.contentLable.text=[NSString stringWithFormat:@"   订单号:  %@",self.dingDanNo];
            }
            
            
        
        }else
        {
            if ([self.runModel isEqualToString:@"01"])
            {
                //房台模式
                 cell.contentLable.text=[NSString stringWithFormat:@"   房台号:  %@",self.seatModel.SI002];
                
            }else
            {
                //其他
                cell.contentLable.text=@"   快餐模式";
                
            }
           
        }
        return cell;
    }else if (tableView==_tableview2)
        
    {
        ClassifyModel *model=_classifyArray[indexPath.row];
        ChooseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        }
        if ([model.classifyNo isEqualToString:@"some"]) {
            cell.contentLable.textColor=MainColor;
        }
        cell.contentLable.text=model.classifyName;
        return cell;
       
        
    }else if(tableView==_tableview3)
    {
        INV_ProductModel *model=_productArray[indexPath.row];
        DownOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"DownOrderTableViewCell" owner:nil options:nil][0];
        }
        if (_shopCarArray.count)
        {
            for (INV_ProductModel *smodel in _shopCarArray) {
                if ([model.ProductNo isEqualToString:smodel.ProductNo]) {
                    model.count=smodel.count;
                }
            }
        }else
        {
            model.count=0;
        }
      
        [cell setDataWithModel:model];
       //获取数量
    
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //加
        __weak typeof(self)weakSelf=self;
        cell.pluseBlock=^(UIImageView *headImage){
            
            weakSelf.iseqal=NO;
            for (INV_ProductModel *pmodel in weakSelf.shopCarArray) {
                if ([pmodel.ProductNo isEqualToString:model.ProductNo])
                {
                    pmodel.count++;
                    weakSelf.iseqal=YES;
                    break;
                }else
                {
                    
                }
            }
            if (!weakSelf.iseqal) {
                model.count++;
                [weakSelf.shopCarArray addObject:model];
            }
            
            [weakSelf.tableview3 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
            CGRect rect=[headImage convertRect:headImage.frame toView:self.view];
            [[PurchaseCarAnimationTool shareTool]startAnimationandView:headImage andRect:rect andFinisnRect:CGPointMake(40, screen_height-60)  andFatherView:self.view andFinishBlock:^(BOOL finish) {
                UIView *tabbarBtn = _shopButton;
                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
                [weakSelf changeUI];
            }];
           
            
            
        };
        //减
        cell.minceBlock=^{
      
         
            if (model.count>0) {

                for (INV_ProductModel *pmodel in weakSelf.shopCarArray) {
                    if ([pmodel.ProductNo isEqualToString:model.ProductNo])
                    {
                        pmodel.count--;
                        if (pmodel.count==0)
                        {
                            [weakSelf.shopCarArray removeObject:model];
                            
                        }
                        [weakSelf changeUI];
                        break;
                    }
                }

            
                [weakSelf.tableview3 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }

            
        };
        //选择口味
        cell.chooseBlock=^(NSString *title){
            if ([title isEqualToString:@"选择套餐"])
            {
                INV_ProductModel *newModel=[weakSelf getNewModelWithModel:model];
                ChooseComboViewController *chose=[[ChooseComboViewController alloc]init];
                chose.backBlock=^(NSMutableArray *detailArray){
                    newModel.count=1;
                    [_shopCarArray addObject:newModel];
                    [newModel.DetailProductArray addObjectsFromArray:detailArray];
                    [weakSelf getModelDataWithModel:newModel];
                    [weakSelf changeUI];
                    
                };
                chose.productNo=model.ProductNo;
                chose.title=@"套餐选择";
                [weakSelf.navigationController pushViewController:chose animated:YES];
                
            }else
            {
                NSLog(@"口味选择");
                [weakSelf getTastViewWithModel:model];
            }
           
        };
        return cell;

       
    }else
    {
        __weak typeof(self)weakSelf=self;
        INV_ProductModel *model=_shopCarArray[indexPath.row];
        ShopCarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ShopCarTableViewCell" owner:nil options:nil][0];
        }
        [cell setDataWithModel:model];
        cell.addBlock=^{
            NSLog(@"加");
            model.count++;
            [weakSelf.tableview4 reloadData];
            [weakSelf.tableview3 reloadData];
            [weakSelf changeUI];
        };
        cell.minceBlock=^{
             NSLog(@"减");
            model.count--;
            
            if (model.count==0) {
                [weakSelf.shopCarArray removeObject:model];
               

                [weakSelf chanegeTableFrame];
            }
                [weakSelf.tableview4 reloadData];
                [weakSelf.tableview3 reloadData];
                [weakSelf changeUI];

        };
        return cell;
    }
    return nil;
}
-(void)chanegeTableFrame
{
    if ([self retrunTableRowHeight]+headerHeight>limitHeight)
    {
    
    }else
    {
          _tableview4.frame=CGRectMake(0, _coverView.height-[self retrunTableRowHeight]-headerHeight-59, _coverView.width, [self retrunTableRowHeight]+headerHeight);
    }
  
    
}
-(void)getModelDataWithModel:(INV_ProductModel*)model
{
    
    //套餐
    if (model.DetailProductArray.count>0) {
        
        for (ProductModel *pmodel in model.DetailProductArray) {
            
            
            NSString *str=[NSString stringWithFormat:@"+%@%@%@",pmodel.ProductName,[pmodel.Dosage removeZeroWithStr],pmodel.Unit];
            [model.detailMuStr appendString:str];
            
          
        }
        
    }
    //口味
    if (model.POSDIArray.count>0) {
      
        for (POSDIModel *posmodel in model.POSDIArray) {
            NSString *str=[NSString stringWithFormat:@"/%@",posmodel.DI002];
            [model.detailMuStr appendString:str];
           
        }
        
    }
    if (model.detailMuStr.length>0) {
        [model.detailMuStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
  
    //
    UILabel *lable=[[UILabel alloc]init];
    lable.numberOfLines=0;
    lable.text=model.detailMuStr;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lable sizeThatFits:CGSizeMake(screen_width-26, MAXFLOAT)];
    model.height=size.height;
//       NSLog(@"%f",model.height);
}
-(INV_ProductModel*)getNewModelWithModel:(INV_ProductModel*)model
{
    INV_ProductModel *Nmodel=[[INV_ProductModel alloc]init];
    Nmodel.ProductName=model.ProductName;
    Nmodel.ProductNo=model.ProductNo;
    Nmodel.RetailPrice=model.RetailPrice;
    Nmodel.POSDIArray=[NSMutableArray array];
    Nmodel.DetailProductArray=[NSMutableArray array];
    Nmodel.detailMuStr=[NSMutableString string];
    return Nmodel;
}
-(void)getTastViewWithModel:(INV_ProductModel *)model
{
    
    _chooseView=[[ChooseTastView alloc]initWithFrame:[UIScreen mainScreen].bounds Model:model];
    [self.view addSubview:_chooseView];
    __weak typeof(self)weakSelf=self;
  
    _chooseView.addShopCarBlock=^(NSMutableArray *tastArray){
//        NSLog(@"%ld",tastArray.count);
        //数据
        INV_ProductModel *newModel=[weakSelf getNewModelWithModel:model];
        newModel.count=1;
        [newModel.POSDIArray addObjectsFromArray:tastArray];
        [weakSelf getModelDataWithModel:newModel];
        [weakSelf.shopCarArray addObject:newModel];
    
        //动画
        //加入动画 先变小，
        [UIView animateWithDuration:0.45 animations:^{
            weakSelf.chooseView.transform=CGAffineTransformMakeScale(0.05, 0.05);
//            weakSelf.chooseView.backgroundColor=MainColor;
            
          
        }];
        //然后在弧线运动
        CGPoint point=[weakSelf.chooseView convertPoint:weakSelf.chooseView.center toView:weakSelf.view];
        [weakSelf joinAnimateWithPoint:point];
        
        
    };
    
}
#pragma mark--(选择口味后购物车动画)
-(void)joinAnimateWithPoint:(CGPoint)point
{
    CGFloat startX = point.x;
    CGFloat startY = point.y;
//    CGFloat endX=self.shopButton.center.x;
//    CGFloat enY=self.shopButton.center.y;
    CGFloat endX=31;
    CGFloat enY=screen_height-30;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    //三点曲线
    [path addCurveToPoint:CGPointMake(endX, enY)
            controlPoint1:CGPointMake(startX, startY)
            controlPoint2:CGPointMake(startX - 100, startY -30)];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_chooseView.layer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removetastView:) withObject:_chooseView.layer afterDelay:0.8f];
    
}
-(void)removetastView:(CALayer *)layerAnimation{
    
    
    [_chooseView removeFromSuperview];
    UIView *tabbarBtn = _shopButton;
    [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
    [self changeUI];

   
}
-(void)changeUI
{
    float prie=0;
    for (ProductModel *model in _shopCarArray) {
        prie=prie+model.count*model.RetailPrice.floatValue;
    }
    self.countLable.text=[NSString stringWithFormat:@"%ld",_shopCarArray.count];
    self.priceLable.text=[NSString stringWithFormat:@"%.2f",prie];
    if (_shopCarArray.count==0)
    {
        _countLable.hidden=YES;
        _priceLable.hidden=YES;
        _shopButton.enabled=NO;
        [self.coverView removeFromSuperview];
    }else
    {
         _countLable.hidden=NO;
         _priceLable.hidden=NO;
         _shopButton.enabled=YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableview3) {
        return 100;
    }else if(tableView==_tableview1)
    {
        return 40;
    }else if(tableView==_tableview4)
    {
        INV_ProductModel *model=_shopCarArray[indexPath.row];
        return model.height+38;
        
    }else
        
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableview4) {
        return headerHeight;
    }
    else
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableview4) {
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).offset(-10);
            make.width.mas_equalTo(90);
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
        }];
        [button setTitle:@"清空购物车" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAll) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    return nil;
}
-(void)removeAll
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确认清空购物车？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_shopCarArray removeAllObjects];
        [self.tableview3 reloadData];
        [self changeUI];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (tableView==_tableview1)
    {
        if (_adModel) {
              [tableView deselectRowAtIndexPath:indexPath animated:YES];
            MyAddressViewController *address = [[MyAddressViewController alloc] init];
            address.title = @"选择地址";
            address.ChooseType=@"choose";
            address.backBlock=^(addressModel*adressModel)
            {
                self.adeessID=adressModel.ID;
                ChooseTableViewCell *Cell=(ChooseTableViewCell*)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                Cell.contentLable.text=[NSString stringWithFormat:@" 送货地址:     %@%@",adressModel.area, adressModel.address];
                
            };
            [address setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:address animated:YES];
        }
     
     
    }else if (tableView==_tableview2)
    {
      
        ClassifyModel *model= _classifyArray[indexPath.row];
     
       

            if ([model.classifyNo isEqualToString:@"all"])
            {
              
                //获取全部子类商品
                self.index=1;
                self.productPatno=model.parentno;
                [self getProductDataWithStr:model.parentno];
              
                
            }else if ([model.classifyNo isEqualToString:@"some"])
            {
                //返回 获取父类

                [self getBackDataWithModel:model];
            }else
            {
                //获取分类子类
            
                [self getClassifyDataWithModel:model];
                
            }
            

        
      
     
        
    }else if(tableView==_tableview3)
    {
     
    }else
    {
        
       
    }

    
}
#pragma mark--mjFresh
-(void)addHeaderRefresh
{
    _header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        //1.重置页数
        self.index=1;
        //2.清空页数
        [_productArray removeAllObjects];
        //3.重新发生网络请求
        [self getProductDataWithStr:self.productPatno];
        
    }];
    //    NSArray *imageArr=@[[UIImage imageNamed:@"loadAni_1"],[UIImage imageNamed:@"loadAni_2"],[UIImage imageNamed:@"loadAni_3"],[UIImage imageNamed:@"loadAni_4"],[UIImage imageNamed:@"loadAni_5"]];
    //    //正在刷新中的状态
    //    [header setImages:imageArr forState:MJRefreshStateRefreshing];
    //    [header setImages:@[[UIImage imageNamed:@"loadAni_1"]] forState:MJRefreshStateIdle];
    
    [_header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
    self.tableview3.mj_header=_header;
    
}
-(void)fresh
{
    [self addHeaderRefresh];
    [self addFooterRefresh];
}
-(void)addFooterRefresh
{
    
    //上拉加载
    _footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
       ;
        //1.页数增加
        self.index++;
        
        //2.重新请求数据

        [self getProductDataWithStr:self.productPatno];
    }];
    
    
    self.tableview3.mj_footer=_footer;
}
-(void)endFresh
{
    //如果没有更多数据
    
    [_tableview3.mj_header endRefreshing];
    [_tableview3.mj_footer endRefreshing];
}
-(void)chanFootWithArray:(NSMutableArray *)array{
    if (array.count<requsetSize.integerValue)
    {
        _footer.hidden=YES;
    }else
    {
        _footer.hidden=NO;
    }
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
