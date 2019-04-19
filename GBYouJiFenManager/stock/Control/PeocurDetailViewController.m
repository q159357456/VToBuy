//
//  PeocurDetailViewController.m
//  GBYouJiFenManager
//
//  Created by 工博计算机 on 17/9/6.
//  Copyright © 2017年 秦根. All rights reserved.
//

#import "PeocurDetailViewController.h"
#import "ADShopInfoModel.h"
#import "ProDetailTableViewCell.h"
#import "ProDetailTwoTableViewCell.h"
#import "ProDetailThreeTbleViewCell.h"
#import "XRCarouselView.h"
#import "FMDBShopCar.h"
#import "ADShopInfoModel.h"
#import "StockShopViewController.h"
#import "FMDBShopInfo.h"
#import "STShopCarViewController.h"
#import "RegisterNav.h"
@interface PeocurDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>
@property(nonatomic,strong)NSMutableArray *pictArray;
@property(nonatomic,assign)BOOL isShop;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *shopCarButt;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *countLable;
@property (strong, nonatomic) IBOutlet UILabel *priceLable;
@property(nonatomic,strong)ADShopInfoModel *shopModel;
@property(nonatomic,retain)XRCarouselView *carouseview;
@property (nonatomic,strong) CALayer *dotLayer;
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation PeocurDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _doneButton.backgroundColor=navigationBarColor;
    self.countLable.backgroundColor=navigationBarColor;
    self.countLable.layer.cornerRadius=10;
    self.countLable.layer.masksToBounds=YES;
    [self getshopInfo];
    [self changeState];
 
    // Do any additional setup after loading the view from its nib.
}
//获取商品详情信息
//-(void)getProdeuctInfo
//{
//    [SVProgressHUD showWithStatus:@"加载中"];
//    NSDictionary *dic=@{@"company":self.proModel.COMPANY,@"shopid":self.proModel.SupplierNo,@"productno":self.proModel.ProductNo};
//        NSLog(@"%@",dic);
//    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"B2BService/B2BGetGoodsDetailInfo" With:dic and:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        NSDictionary *dic1=[JsonTools getData:responseObject];
//        //        NSLog(@"%@",dic1);
//        if (dic1) {
//            self.shopModel=[ADShopInfoModel getDatawithdic:dic1];
//        }
//        [self.tableview reloadData];
//        
//    } Faile:^(NSError *error) {
//        
//    }];
//
//}
//获取店铺信息
-(void)getshopInfo
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *dic=@{@"FromTableName":@"cms_shop",@"SelectField":@"*",@"Condition":[NSString stringWithFormat:@"shopid$=$%@",self.proModel.SupplierNo],@"SelectOrderBy":@"",@"CipherText":CIPHERTEXT};
//    NSLog(@"%@",dic);
    [[NetDataTool shareInstance]getNetData:ROOTPATH url:@"SystemCommService.asmx/GetCommSelectDataInfo3" With:dic and:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic1=[JsonTools getData:responseObject];

        if (dic1) {
            self.shopModel=[ADShopInfoModel getDatawithdic:dic1];
        }
        [self.tableview reloadData];
        
    } Faile:^(NSError *error) {
        
    }];
}
-(void)changeState
{
    NSArray *dataArray=[[FMDBShopCar shareInstance]getShopCarModel];
    
    if (dataArray.count==0) {
        
        self.doneButton.enabled=NO;
        self.priceLable.hidden=YES;
        self.countLable.hidden=YES;
        
    }else
    {
        
        self.doneButton.enabled=YES;
        self.countLable.text=[NSString stringWithFormat:@"%ld",dataArray.count];
        float prie=0;
        for (ProductModel *model in dataArray) {
            prie=prie+model.count*model.RetailPrice.floatValue;
            self.priceLable.text=[NSString stringWithFormat:@"%.2f",prie];
        }
    }
}

//轮播图数据
-(NSMutableArray *)pictArray
{
    if (!_pictArray) {

        NSString *str1=[[NSString stringWithFormat:@"%@/%@",PICTUREPATH,_proModel.PicAddress1] URLEncodedString];
         NSString *str2=[[NSString stringWithFormat:@"%@/%@",PICTUREPATH,_proModel.PicAddress2] URLEncodedString];
        _pictArray=[NSMutableArray arrayWithObjects:str1,str2,nil];
    }
    return _pictArray;
}

//产品参数
//产品详情
#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    if (section==0)
    {
        
        if (![_proModel.SupplierNo isEqualToString:@"MShop"]&&!_shop) {
          
                return 2;
        
        }else
        {
             return 1;
        }
    
       
    }else
    {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {

        if (indexPath.row==0)
        {
            ProDetailTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ProDetailTableViewCell" owner:nil options:nil][0];
            cell.lable1.text=self.proModel.ProductName;
            cell.lable2.text=self.proModel.RetailPrice;
            cell.lable3.text=[NSString stringWithFormat:@"%ld",self.proModel.count];
            DefineWeakSelf;
            __weak typeof(ProDetailTableViewCell*)weakCell=cell;
            cell.addBlock=^(UIButton *butt){
                self.proModel.count++;
                [[FMDBShopCar shareInstance]insertUser: self.proModel];
                [self insertShopInfoWithStr: self.proModel.shopname :self.proModel.SupplierNo];
                [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                CGRect rect=[weakCell convertRect:butt.frame toView:self.view];
                [self JoinCartAnimationWithRect:rect];
            };
            cell.minceBlock=^{
                if ( self.proModel.count>0) {
                    if ( self.proModel.count==1)
                    {
                         self.proModel.count--;
                        [[FMDBShopCar shareInstance]deleteTable: self.proModel];
                        
                        [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                        [weakSelf changeState];
                        
                    }else
                    {
                         self.proModel.count--;
                        [[FMDBShopCar shareInstance]insertUser: self.proModel];
                        [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                        [weakSelf changeState];
                    }
                    
                }
                
            };
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            ProDetailTwoTableViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ProDetailTwoTableViewCell" owner:nil options:nil][0];
            [cell setDataWithModel:self.shopModel];
              cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else
    {
        ProDetailThreeTbleViewCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ProDetailThreeTbleViewCell" owner:nil options:nil][0];
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0)
    {
        
        if (indexPath.row==0)
        {
            return 200;
        }else
        {
            return 100;
        }
        
    }else
    {
        return 200;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return screen_width/2;
    }else
        return 10;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (![self.tableview.subviews containsObject:_carouseview]) {

            _carouseview=[[XRCarouselView alloc]initWithFrame:CGRectZero];
       
            _carouseview.imageArray=self.pictArray;
            _carouseview.time=2;
            _carouseview.imageClickBlock=^(NSInteger index){
                
            };
            
        }
        return _carouseview;
    }
    else
        
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==1)
        {
            StockShopViewController *shop=[[StockShopViewController alloc]init];
            shop.title=self.shopModel.ShopName;
            shop.shopModel=self.shopModel;
            [self.navigationController pushViewController:shop animated:YES];
        }
    }
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
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    CGRect brect=[self.shopCarButt convertRect:self.shopCarButt.frame toView:self.view];
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
