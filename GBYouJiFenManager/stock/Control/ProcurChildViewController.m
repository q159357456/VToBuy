//
//  ProcurChildViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "ProcurChildViewController.h"
#import "ADClassifyModel.h"
#import "ProductModel.h"
#import "ChooseTableViewCell.h"
#import "DownOrderTableViewCell.h"
#import "PeocurDetailViewController.h"
#import "BillStateViewController.h"
#import "ShopCarTableViewCell.h"
#import "STShopCarViewController.h"
#import "FMDBShopCar.h"
#import "RegisterNav.h"
#import "FMDBShopInfo.h"
#import "ADShopInfoModel.h"
@interface ProcurChildViewController ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property(nonatomic,strong)NSMutableArray *smallClassifyArray;
@property(nonatomic,strong)NSMutableArray *productArray;
@property (strong, nonatomic) IBOutlet UITableView *tableview1;
@property (strong, nonatomic) IBOutlet UITableView *tableview2;
@property (strong, nonatomic) IBOutlet UILabel *contLable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *shopCarButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property (nonatomic,strong) CALayer *dotLayer;
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation ProcurChildViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableview1.tableFooterView = [[UIView alloc] init];
     _tableview2.tableFooterView = [[UIView alloc] init];
    _tableview1.backgroundColor=[ColorTool colorWithHexString:@"#f4f4f4"];
    _doneButton.backgroundColor=navigationBarColor;
    self.contLable.backgroundColor=navigationBarColor;
    self.contLable.layer.cornerRadius=10;
    self.contLable.layer.masksToBounds=YES;
    [self changeState];
    [self getClassifyDataWithMode:self.classiNo];
    //
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData:) name:NotifacStock object:nil];
   
}
-(void)reloadData:(NSNotification*)notice
{
    NSInteger k=[notice.object intValue];
    if (k==self.flag) {
      
        [self.tableview2 reloadData];
        
    }
    
}
            
    
// Do any additional setup after loading the view from its nib.

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"视图已经出现----");
    [self.tableview2 reloadData];
    [self changeState];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];

}
-(void)viewChange:(NSNotification*)notic
{
    NSLog(@"收到通知后获取数据1");
    NSInteger k=[notic.object intValue];
    ADClassifyModel *model=_titleArray[k-1];
    if ([self.classiNo isEqualToString:model.ClassifyNo])
        {
            if (!self.smallClassifyArray.count) {
                 NSLog(@"收到通知后获取数据2");
                [self getClassifyDataWithMode:self.classiNo];
                
            }
            
        }
   
}
- (UIViewController *)viewController
{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
-(NSMutableArray *)smallClassifyArray
{
    if (!_smallClassifyArray) {
        _smallClassifyArray=[NSMutableArray array];
    }
    return _smallClassifyArray;
}
-(NSMutableArray *)productArray
{
    if (!_productArray) {
        _productArray=[NSMutableArray array];
    }
    return _productArray;
}
-(void)selecteIndex:(NSInteger)index
{
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableview1 selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
    NSIndexPath * path = [NSIndexPath indexPathForItem:index  inSection:0];
    [self tableView:self.tableview1 didSelectRowAtIndexPath:path];
}
//获得大类子类
-(void)getClassifyDataWithMode:(NSString*)classNo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":MCompany,@"shopid":MShop,@"parentno":classNo};
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BClassifyInfo" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
        self.smallClassifyArray=[ADClassifyModel getDatawithdic:dic1];
        [self.smallClassifyArray insertObject:[self addAll] atIndex:0];
        [self.tableview1 reloadData];
        [self selecteIndex:0];
    } Faile:^(NSError *error) {
        
    }];
}
//获得商品
-(void)getProductDataWithStr:(NSString*)classiNo
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"company":MCompany,@"shopid":MShop,@"classify":classiNo,@"pageindex":@"1",@"pagesize":requsetSize};
  
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService.asmx/B2BGetGoodsInfo_POS" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];
//        NSLog(@"%@",dic1);
        self.productArray=[ProductModel getDataWithDic:dic1];

        [self.tableview2 reloadData];
        
    } Faile:^(NSError *error) {
        
    }];
}
-(ADClassifyModel*)addAll
{
    
    ADClassifyModel *model=[[ADClassifyModel alloc]init];
    model.ClassifyName=@"全部";
    model.ClassifyNo=self.classiNo;
    return model;
    
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableview1)
    {
        return self.smallClassifyArray.count;
        
    }else
    {
        return self.productArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tableview1)
    {
        return 50;
        
    }else
    {
        return 110;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableview1)
    {
        static NSString *cellid=@"ChooseTableViewCell";
        ChooseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ChooseTableViewCell" owner:nil options:nil][0];
        }
        //背景
        UIView *view=[[UIView alloc]initWithFrame:cell.frame];
        view.backgroundColor=[UIColor whiteColor];
        [cell setSelectedBackgroundView:view];
        //未选中
        UIView *selView=[[UIView alloc]initWithFrame:cell.frame];
        selView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [cell setBackgroundView:selView];
        if (_smallClassifyArray.count) {
            ADClassifyModel *model=_smallClassifyArray[indexPath.row];
            cell.contentLable.text=model.ClassifyName;
            if ([model.ClassifyName isEqualToString:@"全部"]) {
                cell.contentLable.textColor=navigationBarColor;
            }
        }
        
        
        return cell;
        
    }else
    {
    
        static NSString *cellid=@"DownOrderTableViewCell";
       DownOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"DownOrderTableViewCell" owner:nil options:nil][0];
        }
        if (self.productArray.count) {
            ProductModel *model=self.productArray[indexPath.row];
           
            //count
            BOOL is=NO;
            for (ProductModel *pmodel in [[FMDBShopCar shareInstance]getShopCarModel]) {
                if ([model.ProductNo isEqualToString:pmodel.ProductNo])
                {
                    is=YES;
                    model.count=pmodel.count;
                    break;
                }
            }
            if (!is) {
                model.count=0;
            }
            NSString *url=[NSString stringWithFormat:@"%@%@",PICTUREPATH,model.PicAddress1];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[url URLEncodedString]] placeholderImage:[UIImage imageNamed:@"holder"]];
            cell.lable1.text=model.ProductName;
            cell.lable2.text=[NSString stringWithFormat:@"¥%@",model.RetailPrice];
            cell.lable4.text=[NSString stringWithFormat:@"%ld",model.count];
            cell.pluseButton.hidden=NO;
            cell.minceButton.hidden=NO;
            cell.TastButton.hidden=YES;
            if (model.count==0)
            {   cell.lable4.hidden=YES;
                cell.minceButton.hidden=YES;
            }else
            {  cell.lable4.hidden=NO;
                cell.minceButton.hidden=NO;
            }
            DefineWeakSelf;
            __weak typeof(DownOrderTableViewCell*)weakCell=cell;
            cell.pluseBlock=^(UIImageView *image,UIButton *butt){
                model.count++;
                [[FMDBShopCar shareInstance]insertUser:model];
                [self insertShopInfoWithStr:model.shopname :model.SupplierNo];
              [weakSelf.tableview2 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            CGRect rect=[weakCell convertRect:butt.frame toView:self.view];
            [self JoinCartAnimationWithRect:rect];
                
            };
            cell.minceBlock=^{
                if (model.count>0) {
                if (model.count==1)
                {
                    model.count--;
                    [[FMDBShopCar shareInstance]deleteTable:model];
                    
                    [weakSelf.tableview2 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                    [weakSelf changeState];
                    
                }else
            {
                model.count--;
              [[FMDBShopCar shareInstance]insertUser:model];
               [weakSelf.tableview2 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                  [weakSelf changeState];
                
            }
                                   
                    
                }
                                 

                
            };
         
            
        }

        return cell;
        
    }
    return nil;
  
}
-(void)insertShopInfoWithStr:(NSString*)shopName :(NSString*)shopid
{
    ADShopInfoModel *model=[[ADShopInfoModel alloc]init];
    model.SHOPID=shopid;
    model.ShopName=shopName;
    [[FMDBShopInfo shareInstance]insertShopInfo:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableview1)
    {
        if (_smallClassifyArray.count) {
        ADClassifyModel *model=_smallClassifyArray[indexPath.row];
            [self getProductDataWithStr:model.ClassifyNo];
    }
    }else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //详情
        ProductModel *model=self.productArray[indexPath.row];
        PeocurDetailViewController *detail=[[PeocurDetailViewController alloc]init];
        detail.title=@"商品详情";
        detail.proModel=model;
        [self.navigationController pushViewController:detail animated:YES];
       
    }

}
-(void)changeState
{

    NSArray *dataArray=[[FMDBShopCar shareInstance]getShopCarModel];
  
    if (dataArray.count==0) {
      
        self.doneButton.enabled=NO;
        self.priceLable.hidden=YES;
        self.contLable.hidden=YES;
        self.shopCarButton.enabled=NO;
        
    }else
    {
     self.shopCarButton.enabled=YES;
        self.doneButton.enabled=YES;
         self.contLable.hidden=NO;
        self.contLable.text=[NSString stringWithFormat:@"%ld",dataArray.count];
        float prie=0;
        for (ProductModel *model in dataArray) {
            prie=prie+model.count*model.RetailPrice.floatValue;
            self.priceLable.text=[NSString stringWithFormat:@"%.2f",prie];
        }
    }
}
- (IBAction)done:(UIButton *)sender
{
    STShopCarViewController *shop=[[STShopCarViewController alloc]init];
    RegisterNav *reNav= [[RegisterNav alloc] initWithRootViewController:shop];
    CCViewController *fancyViewController = (CCViewController *) self;
    
    fancyViewController.interactionEnabled = YES;
    NSString *className = @"CCLayerAnimation";
    id transitionInstance = [[NSClassFromString(className) alloc] init];
    fancyViewController.animationController = transitionInstance;
    fancyViewController.animationController.type = 0;
    if ([self respondsToSelector:@selector(setTransitioningDelegate:)]){
        reNav.transitioningDelegate = self.transitioningDelegate;
    }
    shop.title=@"购物车";
    [self presentViewController:reNav animated:YES completion:nil];

}
- (IBAction)shopCar:(UIButton *)sender {
    STShopCarViewController *shop=[[STShopCarViewController alloc]init];
    RegisterNav *reNav= [[RegisterNav alloc] initWithRootViewController:shop];
    CCViewController *fancyViewController = (CCViewController *) self;
    
    fancyViewController.interactionEnabled = YES;
    NSString *className = @"CCLayerAnimation";
    id transitionInstance = [[NSClassFromString(className) alloc] init];
    fancyViewController.animationController = transitionInstance;
    fancyViewController.animationController.type = 0;
    if ([self respondsToSelector:@selector(setTransitioningDelegate:)]){
        reNav.transitioningDelegate = self.transitioningDelegate;
    }
    shop.title=@"购物车";
    [self presentViewController:reNav animated:YES completion:nil];
}
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    CGRect brect=[self.shopCarButton convertRect:self.shopCarButton.frame toView:self.view];
    CGFloat endX=brect.origin.x+20;
    CGFloat enY=brect.origin.y+20;
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endX, enY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 150, startY - 150)];
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
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
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    [self changeState];
    [layerAnimation removeFromSuperlayer];
    
    
    
}
-(void)dealloc
{
//    NSLog(@"prochild 释放");
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
